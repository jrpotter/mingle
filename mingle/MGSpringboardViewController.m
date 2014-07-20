//
//  MGSpringboardViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGSpringboardViewController.h"
#import "MGSpringboardHeaderViewController.h"
#import "MGIconButtonViewController.h"

static NSString *eventTitle = @"Events";
static NSString *accountTitle = @"Account";
static NSString *aboutTitle = @"About";

@interface MGSpringboardViewController ()
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *sections;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (strong, nonatomic) MGSpringboardHeaderViewController *header;
@end

@implementation MGSpringboardViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        _delegate = nil;
        
        _header = [[MGSpringboardHeaderViewController alloc] init];
        [_header.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_header.view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView setBackgroundColor:[MINGLE_COLOR colorWithAlphaComponent:0.65]];
        
        // Layout the section titles, row icons, and row branch enumeration
        _sectionTitles = @[eventTitle, accountTitle, aboutTitle];
        _sections = @{eventTitle:   @[@"Featured", FEATURED_ICON, [[NSNumber alloc] initWithInt:FEATURED_BRANCH],
                                      @"Browse",   BROWSE_ICON,   [[NSNumber alloc] initWithInt:BROWSE_BRANCH],
                                      @"Create",   CREATE_ICON,   [[NSNumber alloc] initWithInt:CREATE_BRANCH],
                                      @"Search",   SEARCH_ICON,   [[NSNumber alloc] initWithInt:SEARCH_BRANCH],
                                      @"Settings", SETTINGS_ICON, [[NSNumber alloc] initWithInt:SETTINGS_BRANCH]],
                      accountTitle: @[@"Profile",  PROFILE_ICON,  [[NSNumber alloc] initWithInt:PROFILE_BRANCH],
                                      @"Friends",  FRIENDS_ICON,  [[NSNumber alloc] initWithInt:FRIENDS_BRANCH],
                                      @"Invite",   INVITE_ICON,   [[NSNumber alloc] initWithInt:INVITE_BRANCH],
                                      @"Logout",   LOGOUT_ION,    [[NSNumber alloc] initWithInt:LOGOUT_BRANCH]],
                      aboutTitle:   @[@"About",    ABOUT_ICON,    [[NSNumber alloc] initWithInt:ABOUT_BRANCH]]};
        
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mingle_background.png"]]];
    }
    
    return self;
}

- (void)dealloc
{
    [_tableView setDelegate:nil];
    [_tableView setDataSource:nil];
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self addChildViewController:self.header];
    [self.view addSubview:self.header.view];
    [self.view addSubview:self.tableView];
    
    // Add Constraints (Header)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[header(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"header": self.tableView, @"view": self.view}]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.header.view
                              attribute:NSLayoutAttributeLeft
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeft
                              multiplier:1.0
                              constant:0]];
    
    // Add Constraints (Table View)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[table(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"table": self.tableView, @"view": self.view}]];
    
    // Layout Vertically
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[header]-6-[table]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"header": self.header.view, @"table": self.tableView}]];
}


#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self.sectionTitles objectAtIndex:indexPath.section];
    NSString *label = [[self.sections objectForKey:title] objectAtIndex:indexPath.row * 3];
    NSString *icon = [[self.sections objectForKey:title] objectAtIndex:indexPath.row * 3 + 1];
    
    // Create new cell (or cached version)
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
    }
    
    // Create new button
    MGIconButtonViewController *controller = [[MGIconButtonViewController alloc] initWithTitle:label icon:icon];
    [controller.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [controller.button setTextFont:[UIFont fontWithName:@"Helvetica" size:20]];
    
    // Enable propagation of event to table view
    [controller.button setIdentifier:indexPath];
    [controller.button addTarget:self action:@selector(selectedRow:) forControlEvents:UIControlEventTouchUpInside];
    
    // Build Hierarchy
    [self addChildViewController:controller];
    [cell.contentView addSubview:controller.view];
    
    // Layout
    [cell.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-0-[button(==cell)]-0-|"
                                      options:NSLayoutFormatAlignAllCenterY
                                      metrics:nil
                                      views:@{@"button": controller.view, @"cell": cell.contentView}]];
    
    [cell.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-0-[button(==cell)]-0-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"button": controller.view, @"cell": cell.contentView}]];
    
    [cell setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.25]];
    
    return cell;
}

// Adjusts the display of the currently active button and propagates delegation outward
- (void)selectedRow:(id)sender
{
    static MGIconButton *last = nil;
    if(last) {
        [last setSelected:NO];
        [last setBackgroundColor:[UIColor clearColor]];
    }
    
    last = (MGIconButton *)sender;
    [last setSelected:YES];
    [last setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.35]];
    
    if(self.delegate) {
        NSIndexPath *path = last.identifier;
        NSString *title = [self.sectionTitles objectAtIndex:path.section];
        NSNumber *value = [[self.sections objectForKey:title] objectAtIndex:path.row * 3 + 2];
        [self.delegate selectedBranch:[value intValue]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *title = [self.sectionTitles objectAtIndex:section];
    return [[self.sections objectForKey:title] count] / 3;
}


@end
