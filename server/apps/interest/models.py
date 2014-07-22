from django.db import models


class Category(models.Model):
    """
    All events can be broken into categories.

    This allows the user to filter by events he is interested in, as well
    as mark they type (or types) of events a custom event it.
    """
    name = models.CharField(max_length=255)


class Interest(models.Model):
    """
    Used in both an event and user context.

    Under an event context, interests allow for fine tuning of a search.
    Though an event is under categories, this allows the user to search
    for tags tied to an event.

    Under a user context, this allows us to weight events that are more
    attuned to the user's interests.
    """
    name = models.CharField(max_length=255)
    category = models.ForeignKey('interest.Category')