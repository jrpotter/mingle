import base64
import hashlib

from django import forms
from lib import validator
from apps.alias.models import Alias


# Create
# ====================================

class CreateMingleAliasForm(forms.ModelForm):
    """
    Allows the user to create a new Mingle account.

    Note this will generally only be accessed when clicking the sign up button
    from the mingle app login screen. All data beyond name, password, and email
    can be updated on the update screen of the application, to limit the amount
    of work for the client to get started.

    Note the email does not necessarily have to be unique since the user could have
    had a Facebook account and decided to create a Mingle account.
    """
    name = forms.CharField(widget=forms.TextInput(attrs={'placeholder': 'Name'}))
    password = forms.CharField(widget=forms.PasswordInput(attrs={'placeholder': 'Password'}))
    email = forms.EmailField(widget=forms.EmailInput(attrs={'placeholder': 'Email'}))

    class Meta:
        model = Alias
        fields = ['name', 'password']

    def clean(self):
        cleaned_data = super().clean()
        validator.strip_values(['name', 'email', 'password'], cleaned_data)
        try:
            alias = Alias.objects.get(email=cleaned_data['email'])
            msg = "An account has been made with this email"
            self._errors["email"] = self.error_class([msg])
            raise forms.ValidationError(msg)
        except Alias.DoesNotExist:
            pass

        return cleaned_data


# Login
# ====================================

class LoginMingleAliasForm(forms.Form):
    """
    Authorizes user is a verified Mingle user.
    """
    email = forms.EmailField(max_length=254)
    password = forms.CharField(widget=forms.PasswordInput)

    def clean(self):
        """
        Check the user's (if he exists) provided password matches salted password.
        """
        cleaned_data = super().clean()
        validator.strip_values(['email', 'password'], cleaned_data)

        try:
            # Check the user's password matches
            alias = Alias.objects.get(email=cleaned_data['email'])
            sha = hashlib.sha256((alias.salt + cleaned_data['password']).encode('UTF-8'))
            digest = base64.b64encode(sha.digest()).decode()
            if digest != alias.password:
                raise forms.ValidationError("User's password does not match expected value")

        except Alias.DoesNotExist:
            raise forms.ValidationError("User does not have a mingle account")

        return cleaned_data