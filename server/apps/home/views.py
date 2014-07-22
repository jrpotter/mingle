from django.shortcuts import render
import apps.base.lib.utils as base_utils


@base_utils.inject_site_bar
def index(request, context):
    """
    This is the initial page one sees when visiting the Mingle site.
    """
    return render(request, 'home/index.html', context)
