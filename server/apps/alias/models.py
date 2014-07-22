from django.db import models
from apps.event.models import Event


class AliasPictures(models.Model):
    """
    The following contains all the paths to a user's images.
    """
    alias = models.ForeignKey('alias.Alias')
    is_profile_picture = models.BooleanField(default=False)
    picture = models.ImageField(upload_to="alias_picture/%Y/%m")


class Alias(models.Model):
    """
    The alias allows a user to have multiple accounts, under the same member account.

    This was initially employed since OpenShift does not allow sharing of databases.
    Yet this could also be useful, as it allows people to have different accounts
    depending on their app, enabling privacy.

    Note: Look into OpenShift Origins and purchasing a server at some point.
    """

    # Mandatory
    name = models.CharField(max_length=71)
    email = models.EmailField(max_length=254, unique=True)

    # Optional
    date_of_birth = models.DateField(null=True)
    about_me = models.TextField(max_length=2000, blank=True)
    phone_number = models.IntegerField(max_length=10, null=True)

    # Note: Django sets this up to be symmetrical so if someone if a friend with one
    # person, that person is a friend with the original person
    friends = models.ManyToManyField('self')

    # Security
    # In both the Facebook account or Mingle account, a salt is needed
    # The password is a permanent storage (unless a change is requested by the user), as opposed
    # to the session_password. It is only populated if the user chooses to create a Mingle account.
    salt = models.CharField(max_length=16)
    password = models.CharField(max_length=64, null=True)

    # Dates
    last_login = models.DateTimeField(auto_now=True)
    date_added = models.DateTimeField(auto_now_add=True)

    def to_json(self):
        """
        Return a dictionary ("JSON") containing publicly accessible alias properties.
        """

        response = {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'about_me': self.about_me,
            'phone_number': self.phone_number,
            'friend_count': self.friends.count(),
            'event_count': Event.objects.filter(creator=self.id).count(),
            'image_count': AliasPictures.objects.filter(alias=self.id).count(),
            'date_joined': "{:%B %d, %Y}".format(self.date_added),
        }

        # Try to return the path to the user's profile image
        try:
            profile = AliasPictures.objects.get(models.Q(alias=self.id) & models.Q(is_profile_picture=True))
            response['profile_picture'] = profile.picture.url
        except AliasPictures.DoesNotExist:
            response['profile_picture'] = ''
        except AliasPictures.MultipleObjectsReturned:
            print('This is an error. Get Logging!')
            response['profile_picture'] = ''

        return response