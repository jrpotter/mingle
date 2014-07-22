from django.conf.urls import patterns, url

urlpatterns = patterns('apps.event.views',
    url(r'^query/', 'query_view', name='event_query'),
    url(r'^group/', 'group_view', name='event_group'),
    url(r'^create/', 'create_view', name='event_create'),
    url(r'^street/', 'street_view', name='event_street'),
)