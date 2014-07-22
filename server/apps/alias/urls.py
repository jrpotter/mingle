from django.conf.urls import patterns, url

urlpatterns = patterns('apps.alias.views',
    url(r'^login/', 'login_view', name='alias_login'),
    url(r'^profile/', 'profile_view', name='alias_profile'),
    url(r'^create/', 'create_mingle_view', name='alias_create'),
)