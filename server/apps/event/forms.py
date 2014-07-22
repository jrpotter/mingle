import pytz
from datetime import datetime
from django.contrib.gis import forms
from django.contrib.gis.geos import Point
from apps.event.models import *


# Create
# ====================================

class EventForm(forms.ModelForm):
    """
    The event form used when creating or updating an event.

    Though derived from the Event model, this form only has two "required" fields:
    latitude and longitude. This is used to build the location. In addition, all image
    fields are also not required, but we ensure at least one image is properly specified
    when cleaning.
    """

    # Note the location field is created here through the latitude
    # and longitude fields, which is why it isn't required
    latitude = forms.DecimalField(max_digits=10, decimal_places=8)
    longitude = forms.DecimalField(max_digits=11, decimal_places=8)

    # Allow empty values since we ensure one visual is provided when cleaning
    picture = forms.ImageField(required=False)
    zoom = forms.IntegerField(required=False)
    pitch = forms.DecimalField(max_digits=10, decimal_places=8, required=False)
    heading = forms.DecimalField(max_digits=10, decimal_places=7, required=False)

    class Meta:
        model = Event
        exclude = ['creator', 'tags', 'categories', 'location']

    def clean(self):

        cleaned_data = super().clean()

        # Timezone validation
        try:
            pytz.timezone(cleaned_data['timezone'])
        except (KeyError, pytz.UnknownTimeZoneError):
            raise forms.ValidationError("Invalid Timezone")

        # Get the needed location
        try:
            latitude = float(cleaned_data['latitude'])
            longitude = float(cleaned_data['longitude'])
            cleaned_data['location'] = Point(longitude, latitude, srid=4326)
        except KeyError:
            raise forms.ValidationError("Invalid location specified")

        # Ensure we have some visual for the event
        if 'picture' not in self.data:
            if 'zoom' not in self.data:
                raise forms.ValidationError("No Zoom Value Specified")
            elif 'pitch' not in self.data:
                raise forms.ValidationError("No Pitch Value Specified")
            elif 'heading' not in self.data:
                raise forms.ValidationError("No Heading Value Specified")

        return cleaned_data


# Query (Events & Groups)
# ====================================

class EventQueryForm(forms.Form):
    """
    The following only requires a position, start, and count.

    The data returned is adjusted according to the passed query string.
    The following parameters may be passed:
    - start: Allows paginating
    - count: How many responses to return
    - latitude: The user's current latitude. Defaults to None (must also provide longitude if included)
    - longitude: The user's current longitude. Defaults to None (must also provide latitude if included)
    - distance: The distance from the passed lat/lon pair to consider. Defaults to 25 miles
    - min_time: A minimum time(stamp) events should begin after (defaults to Now)
    - max_time: A maximum time(stamp) events should end before (defaults to Forever)
    - tags: An array of tags to search for. Parameters should be separated by a |
    - filter: An array of category types that should not be included in the query. Defaults to []
              Parameters should be separated by a |
    """

    # The number of events to return. Note this is paginated so multiple requests can be made in chunks
    start = forms.IntegerField()
    count = forms.IntegerField()

    # The user's current position
    latitude = forms.DecimalField(max_digits=10, decimal_places=8)
    longitude = forms.DecimalField(max_digits=11, decimal_places=8)

    # This is the radius from the user's current position in miles
    distance = forms.IntegerField(required=False)

    # Timing of events
    timezone = forms.CharField(max_length=64)
    min_datetime = forms.DateTimeField(required=False)
    max_datetime = forms.DateTimeField(required=False)

    def clean(self):

        cleaned_data = super().clean()

        # Get the user's location
        try:
            latitude = float(cleaned_data['latitude'])
            longitude = float(cleaned_data['longitude'])
            cleaned_data['location'] = Point(longitude, latitude)
        except KeyError:
            raise forms.ValidationError("Invalid location specified")

        # Default distance
        if 'distance' not in self.data:
            cleaned_data['distance'] = 25

        try:
            try:
                pytz.timezone(cleaned_data['timezone'])
            except KeyError:
                raise pytz.UnknownTimeZoneError

            if 'min_time' not in self.data:
                cleaned_data['min_datetime'] = datetime.now()
            if 'max_time' not in self.data:
                cleaned_data['max_datetime'] = datetime.max

        except pytz.UnknownTimeZoneError:
            raise forms.ValidationError("Invalid Timezone")

        return cleaned_data


class EventGroupQueryForm(forms.Form):
    """
    The following only requires an event id, a start, and a count.

    The data returned is adjusted according to the passed query string. The following parameters may be passed:
    - id: The id of the event being queried
    - start: Allows paginating
    - count: How many responses to return
    """
    start = forms.IntegerField()
    count = forms.IntegerField()
    id = forms.ModelChoiceField(queryset=Event.objects.all())