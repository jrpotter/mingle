"""
A modification of dj_database_url that allows specification of which database
needed to be used.
"""
import os
import urllib.parse as urlparse

# Register database schemes in URLs.
urlparse.uses_netloc.append('postgres')
urlparse.uses_netloc.append('postgresql')
urlparse.uses_netloc.append('pgsql')
urlparse.uses_netloc.append('postgis')

SCHEMES = {
    'postgres': 'django.db.backends.postgresql_psycopg2',
    'postgresql': 'django.db.backends.postgresql_psycopg2',
    'pgsql': 'django.db.backends.postgresql_psycopg2',
    'postgis': 'django.contrib.gis.db.backends.postgis',
}


def config(env, name, **options):
    """
    By default, Openshift has an environment variable called OPENSHIFT_POSTGRESQL_DB_URL
    that specifies the cartridge, but does not allow specifying the name of the database
    you want. This is a small revision to dj_database_url.config to allow me to do this.
    """
    url = os.path.join(os.environ[env], name)
    url_parsed = urlparse.urlparse(url)

    # Remove query strings.
    path = url_parsed.path[1:]
    path = path.split('?', 2)[0]

    # Update with environment configuration.
    conf = {
        'NAME': path or '',
        'USER': url_parsed.username or '',
        'PASSWORD': url_parsed.password or '',
        'HOST': url_parsed.hostname or '',
        'PORT': url_parsed.port or '',
        'ENGINE': SCHEMES[url_parsed.scheme],
    }

    # Override with options
    conf.update(options)
    if 'ENGINE' in options:
        conf['ENGINE'] = SCHEMES[options['ENGINE']]

    return conf
