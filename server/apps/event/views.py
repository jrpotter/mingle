from lib.utils import *
from apps.event.forms import *
from django.shortcuts import render
from django.contrib.gis.measure import D


# Create
# ====================================

@validate_user
def create_view(request):
    """
    The following allows one to create an event for later displaying.

    The passed address is stored, and later passed into the Google Maps geocoding service.
    Since geocoding is an expensive process, the results are cached after the first time
    the event is viewed (by whoever does the viewing), and later retrievals of the view
    simply uses latitude and longitude.
    """
    form = EventForm(request.POST)
    if not form.is_valid():
        error = ErrorCode.message(ErrorCode.INVALID_EVENT_CREATION_REQUEST)
        error.update(form.errors)
        return error

    event = form.save(commit=False)
    event.location = form.cleaned_data['location']
    event.creator = Alias.objects.get(email=request.POST['email'])
    event.save()

    return ErrorCode.message(ErrorCode.NO_ERROR)


# Query (Events & Groups)
# ====================================

@validate_user
def query_view(request):
    """
    The following returns a JSON formatted dictionary of events.

    The options are explained in the corresponding EventQueryForm. Note the only required
    value passed is the latitude and longitude. Everything else is defaulted in the form.
    """
    form = EventQueryForm(request.POST)
    if not form.is_valid():
        response = ErrorCode.message(ErrorCode.INVALID_EVENT_QUERY_REQUEST)
        response.update(form.errors)
        return response

    # Attributes of form
    start = form.cleaned_data['start']
    count = form.cleaned_data['count']
    distance = form.cleaned_data['distance']
    location = form.cleaned_data['location']

    # Begin building response
    events = Event.objects.filter(location__distance_lte=(location, D(mi=distance))) \
                          .filter(datetime__gte=form.cleaned_data['min_datetime'])   \
                          .filter(datetime__lte=form.cleaned_data['max_datetime'])   \
                          .order_by('datetime')

    response = ErrorCode.message(ErrorCode.NO_ERROR)
    response['events'] = [event.to_json() for event in events[start:count]]
    return response


@validate_user
def group_view(request):
    """
    The following returns a JSON response of event groups, for the specific event id passed.
    """
    form = EventGroupQueryForm(request.POST)
    if not form.is_valid():
        response = ErrorCode.message(ErrorCode.INVALID_EVENT_GROUP_QUERY_REQUEST)
        response.update(form.errors)
        return response

    start = form.cleaned_data['start']
    count = form.cleaned_data['count']

    # Build Response
    response = ErrorCode.message(ErrorCode.NO_ERROR)
    groups = EventGroup.objects.filter(event=form.cleaned_data['id'])

    response['groups'] = list()
    for group in groups[start:count]:
        successor = group.to_json()
        successor['members'] = list()
        for alias in group.members_set().all():
            successor['members'].append(alias.to_json())

        response['groups'].append(successor)

    return response


# Views
# ====================================

@require_GET
def street_view(request):
    """
    The following displays a street view of the passed address (or a static image of passed view).

    Since client-side requests are recommended - each unique IP address increases a counter when using
    the Google Maps API. If done from the server, a single IP address would be considered and the 25,000
    daily quota could potentially get hit quickly.

    Here we only return that street-view, though it takes up the entire screen. This is done since the
    Mingle application will open up an instance of an embeddable web browser, viewing this specific page
    only.

    The following are parameters that may be passed to the function:
    - latitude: The latitude of the street view the user is viewing
    - longitude: The longitude of the street view the user is viewing
    - zoom: How close the camera is on the current view
    - pitch: Angle variance of the street view camera's initial view
    - heading: Rotation angle around the camera locus in degrees relative from N
    """
    return render(request, 'event/street.html', {
        'zoom': request.GET.get('zoom', 1),
        'pitch': request.GET.get('pitch', 0),
        'heading': request.GET.get('heading', 0),
        'latitude': request.GET.get('latitude', 0),
        'longitude': request.GET.get('longitude', 0),
    })