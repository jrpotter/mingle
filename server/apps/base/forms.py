from django import forms


class LoginForm(forms.Form):
    """
    The login form simply allows the user to login to their account.

    Note each app will have an alias- in this manner, I can conglomerate users specific
    to a particular app. Their user ids will map directly to the base user database, but
    this can be done after purchasing more space for our home site.

    The user, when signing up for their account, can either pull data from a particular alias,
    or create a new alias for the app (which will be copied into the database).
    """
    email = forms.EmailField(widget=forms.TextInput(attrs={'placeholder': 'Email'}))
    password = forms.CharField(widget=forms.PasswordInput(attrs={'placeholder': 'Password'}))


class SearchForm(forms.Form):
    """
    Searches for tags on particular articles displayed on the site.

    Searching is rather tricky, since we must be able to search all our sister
    sites in one fatal swoop. I will have to do some thinking regarding this.
    """
    query = forms.CharField(max_length=200)
