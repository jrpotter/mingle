from django.conf.urls import patterns, include, url

urlpatterns = patterns('',
    url(r'^$', 'apps.home.views.index', name='home_index'),
    url(r'^alias/', include('apps.alias.urls')),
    url(r'^event/', include('apps.event.urls')),
)