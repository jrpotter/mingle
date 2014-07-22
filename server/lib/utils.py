import json
import base64
import hashlib
from apps.alias.models import Alias
from apps.error.codes import ErrorCode
from django.views.decorators.http import *
from django.views.decorators.csrf import csrf_exempt


def json_response(func):
    """
    Decorator to return JSON response.

    Note a user should pass in valid credentials before receiving a proper response.
    Therefore this decorator will normally be used in conjunction with the validate_user
    decorator (though not in some cases like account creation).
    """
    @csrf_exempt
    def wrapper(request):
        response = func(request)
        return HttpResponse(json.dumps(response), content_type='application_json')

    return wrapper


def validate_user(func):
    """
    Ensures the passed credentials are referring to an actual user.

    We use the require POST so we can ensure we get access to the passed credentials.
    This function should only ever be used in this context.
    """
    @require_POST
    @json_response
    def wrapper(request):
        valid = False
        credentials = request.POST

        # Verify passed data
        if 'email' in credentials and 'password' in credentials:
            if credentials.get('type') in ['mingle', 'facebook']:
                try:
                    alias = Alias.objects.get(email=credentials['email'])
                    sha = hashlib.sha256((alias.salt + credentials['password']).encode('UTF-8'))
                    digest = base64.b64encode(sha.digest()).decode()
                    if credentials['type'] == 'mingle':
                        valid = (digest == alias.password)

                except Alias.DoesNotExist:
                    pass

        # Respond accordingly
        return func(request) if valid else ErrorCode.message(ErrorCode.INVALID_CREDENTIAL_REQUEST)

    return wrapper