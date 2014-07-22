//
//  MGSession.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGSession.h"
#import "MGConnection.h"
#import "MGAppDelegate.h"

// Keys Used
static NSString *emailKey = @"email";
static NSString *passwordKey = @"password";
static NSString *typeKey = @"type";

@implementation MGSession

#pragma mark - Initialization

+ (id)instance
{
    static MGSession *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


#pragma mark - Login/Logout

- (void)logout
{
    [MGSession deleteValueForKey:typeKey];
    [MGSession deleteValueForKey:emailKey];
    [MGSession deleteValueForKey:passwordKey];
}

// During the login, we save any data related to the user, as well as their credentials so they
// do not have to repeatedly enter their login information
- (void)login:(NSDictionary *)entries complete:(void (^)(NSDictionary *response, NSError *error))complete;
{
    [MGConnection sendOpenRequest:MINGLE_LOGIN_URL data:entries complete:^(NSDictionary *response, NSError *error) {
        if(error == nil && [response[@"code"] intValue] == 0) {
            [self saveCredentials:entries];
            [[MGSession instance] setUserData:response[@"user_data"]];
        }
        
        complete(response, error);
    }];
}

- (BOOL)getLoginStatus
{
    return [MGSession loadValueForKey:typeKey] != nil;
}

- (NSString *)getLoginType:(LOGIN_TYPE)type
{
    switch(type) {
        case MINGLE_TYPE: return @"mingle";
        case FACEBOOK_TYPE: return @"facebook";
        case TWITTER_TYPE: return @"twitter";
    }
}


#pragma mark - Credentials

- (NSDictionary *)credentials
{
    return @{
        typeKey: [MGSession loadValueForKey:typeKey],
        emailKey: [MGSession loadValueForKey:emailKey],
        passwordKey: [MGSession loadValueForKey:passwordKey],
    };
}

- (void)saveCredentials:(NSDictionary *)credentials
{
    [MGSession saveValue:credentials[typeKey] forKey:typeKey];
    [MGSession saveValue:credentials[emailKey] forKey:emailKey];
    [MGSession saveValue:credentials[passwordKey] forKey:passwordKey];
}


#pragma mark - Security

//  Note the following was borrowed from:
//  Created by Jeremias Nunez on 5/10/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//
//  jeremias.np@gmail.com

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key
{
    // see http://developer.apple.com/library/ios/#DOCUMENTATION/Security/Reference/keychainservices/Reference/reference.html
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
            key, (__bridge id)kSecAttrService,
            key, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock, (__bridge id)kSecAttrAccessible,
            nil];
}

+ (void)saveValue:(id)data forKey:(NSString*)key
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    // delete any previous value with this key
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)loadValueForKey:(NSString *)key
{
    id value = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    CFDataRef keyData = NULL;
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        }
        @finally {}
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return value;
}

+ (void)deleteValueForKey:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}


@end
