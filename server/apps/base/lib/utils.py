from apps.base.forms import LoginForm
from apps.base.forms import SearchForm


def inject_site_bar(func):
    """
    The site bar is present at the top of all FuzzyKayak pages.

    This bar contains the ability to login/logout, search functionality, RSS feeding, etc.
    Here we ensure the needed functionality is always present for any pages.

    In addition, the site bar will look differently depending on whether
    the user is logged in or not. This function will reflect those differences.
    """
    context = {
        'login': True,
        'login_form': LoginForm(),
        'search_form': SearchForm(),
    }

    def wrapper(request):
        return func(request, context)

    return wrapper