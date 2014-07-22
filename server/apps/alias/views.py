import os
from lib.utils import *
from apps.alias.forms import *
from django.shortcuts import render
from django.views.decorators.http import *


# Creation
# ====================================

def create_mingle_view(request):
    """
    Represents the actual page used to create a mingle account.

    Unlike the create facebook function, this should be accessed from a web browser
    (most likely called from the safari browser in the app).
    """
    if request.method == 'POST':
        form = CreateMingleAliasForm(request.POST)
        if form.is_valid():

            new_alias = form.save(commit=False)
            new_alias.email = form.cleaned_data['email']

            # If the user exists, they had a Facebook account
            # We can therefore use the old salt value, and simply set the password
            try:
                alias = Alias.objects.get(email=new_alias.email)
                sha = hashlib.sha256((alias.salt + new_alias.password).encode('UTF-8'))
                alias.password = base64.b64encode(sha.digest()).decode()
                alias.save()

            # Otherwise, we make a new salt
            except Alias.DoesNotExist:
                new_alias.salt = base64.b64encode(os.urandom(12)).decode()
                sha = hashlib.sha256((new_alias.salt + new_alias.password).encode('UTF-8'))
                new_alias.password = base64.b64encode(sha.digest()).decode()
                new_alias.save()

            # Contains a button that notifies the user of a success and launches back to the login
            return render(request, 'alias/created.html', {})
    else:
        form = CreateMingleAliasForm()

    # Allows the user to submit credentials for a new account
    return render(request, 'alias/create.html', {'form': form})


# Login
# ====================================

@validate_user
def login_view(request):
    """
    The user can login via facebook or mingle.
    """

    # Login with Mingle
    form = LoginMingleAliasForm(request.POST)
    if form.is_valid():

        # Change the user's last login time and get user info
        response = ErrorCode.message(ErrorCode.NO_ERROR)
        alias = Alias.objects.get(email=form.cleaned_data['email'])
        response['user_data'] = alias.to_json()
        alias.save()

        return response

    else:
        error = ErrorCode.message(ErrorCode.INVALID_MINGLE_LOGIN)
        error.update(form.errors)
        return error


# Profile
# ====================================

@validate_user
def profile_view(request):
    """
    Returns information about a person's profile.

    Note we do not require any credentials- this is public information. We simply return
    all information regarding the passed alias id.
    """
    response = Alias.objects.get(email=request.POST['email']).to_json()
    response.update(ErrorCode.message(ErrorCode.NO_ERROR))
    return response