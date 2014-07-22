# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding field 'Event.timezone'
        db.add_column('event_event', 'timezone',
                      self.gf('django.db.models.fields.CharField')(max_length=63, default='America/New_York'),
                      keep_default=False)


    def backwards(self, orm):
        # Deleting field 'Event.timezone'
        db.delete_column('event_event', 'timezone')


    models = {
        'alias.alias': {
            'Meta': {'object_name': 'Alias'},
            'about_me': ('django.db.models.fields.TextField', [], {'blank': 'True', 'max_length': '2000'}),
            'date_added': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'date_of_birth': ('django.db.models.fields.DateField', [], {'null': 'True'}),
            'email': ('django.db.models.fields.EmailField', [], {'unique': 'True', 'max_length': '254'}),
            'has_facebook': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'has_mingle': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'last_login': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '71'}),
            'password': ('django.db.models.fields.CharField', [], {'null': 'True', 'max_length': '64'}),
            'phone_number': ('django.db.models.fields.IntegerField', [], {'null': 'True', 'max_length': '10'}),
            'picture': ('django.db.models.fields.files.ImageField', [], {'null': 'True', 'max_length': '100'}),
            'salt': ('django.db.models.fields.CharField', [], {'max_length': '16'}),
            'session_password': ('django.db.models.fields.CharField', [], {'null': 'True', 'max_length': '64'})
        },
        'event.event': {
            'Meta': {'object_name': 'Event'},
            'categories': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['interest.Category']", 'symmetrical': 'False'}),
            'creator': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['alias.Alias']"}),
            'date_time': ('django.db.models.fields.DateTimeField', [], {}),
            'heading': ('django.db.models.fields.DecimalField', [], {'null': 'True', 'decimal_places': '7', 'max_digits': '10'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.contrib.gis.db.models.fields.PointField', [], {}),
            'max_size': ('django.db.models.fields.IntegerField', [], {'null': 'True'}),
            'picture': ('django.db.models.fields.files.FileField', [], {'null': 'True', 'max_length': '100'}),
            'pitch': ('django.db.models.fields.DecimalField', [], {'null': 'True', 'decimal_places': '8', 'max_digits': '10'}),
            'tags': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['interest.Interest']", 'symmetrical': 'False'}),
            'timezone': ('django.db.models.fields.CharField', [], {'max_length': '63'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'zoom': ('django.db.models.fields.IntegerField', [], {'null': 'True'})
        },
        'event.eventgroup': {
            'Meta': {'object_name': 'EventGroup'},
            'event': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['event.Event']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'maximum_size': ('django.db.models.fields.IntegerField', [], {}),
            'meeting_place': ('django.db.models.fields.TextField', [], {}),
            'members': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['alias.Alias']", 'symmetrical': 'False'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'interest.category': {
            'Meta': {'object_name': 'Category'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'interest.interest': {
            'Meta': {'object_name': 'Interest'},
            'category': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['interest.Category']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        }
    }

    complete_apps = ['event']