from django.contrib.gis.db import models


class Event(models.Model):
    """
    Contains information regarding the particular event.

    We enable geocoding on the client side, defining the event location to be
    just a latitude/longitude point. If this point isn't available in Google
    Street view, we expect the user to upload their own picture.
    """

    # Date and Time
    datetime = models.DateTimeField()
    timezone = models.CharField(max_length=64)

    # Detail
    title = models.CharField(max_length=255)
    max_size = models.IntegerField(null=True)

    # Display
    # One can either choose a google street view image (in which case we must
    # have a zoom, pitch, and heading) or provide their own picture
    zoom = models.IntegerField(null=True)
    pitch = models.DecimalField(max_digits=10, decimal_places=8, null=True)
    heading = models.DecimalField(max_digits=10, decimal_places=7, null=True)
    picture = models.FileField(upload_to="event_photo/%Y/%m", null=True)

    # Relational
    creator = models.ForeignKey('alias.Alias')
    tags = models.ManyToManyField('interest.Interest')
    categories = models.ManyToManyField('interest.Category')

    # GeoDjango
    objects = models.GeoManager()
    location = models.PointField()

    def latitude(self):
        return self.location.y

    def longitude(self):
        return self.location.x

    def to_json(self):
        return {
            'id': self.id,
            'title': self.title,
            'max_size': self.max_size,
            'timezone': self.timezone,
            'latitude': self.latitude(),
            'longitude': self.longitude(),
            'zoom': float(self.zoom) if self.zoom else '',
            'pitch': float(self.pitch) if self.pitch else '',
            'heading': float(self.heading) if self.heading else '',
            'picture': self.picture.url if self.picture else '',
            'datetime': '{:%m/%d/%Y %I:%M %p}'.format(self.datetime),
        }


class EventGroup(models.Model):
    """
    Contains the users involved in the event.

    When the max limit of a group is hit, users are no longer allowed to
    enter into the group.
    """
    name = models.CharField(max_length=255)
    maximum_size = models.IntegerField()
    meeting_place = models.TextField()

    event = models.ForeignKey('event.Event')
    members = models.ManyToManyField('alias.Alias')

    def to_json(self):
        """
        JSON version of object, but without reference to any foreign keys.
        """
        return {
            'id': self.id,
            'name': self.name,
            'meeting_place': self.meeting_place,
        }