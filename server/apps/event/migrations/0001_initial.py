# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Event'
        db.create_table('event_event', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('date_time', self.gf('django.db.models.fields.DateTimeField')()),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('max_size', self.gf('django.db.models.fields.IntegerField')(null=True)),
            ('zoom', self.gf('django.db.models.fields.IntegerField')(null=True)),
            ('pitch', self.gf('django.db.models.fields.DecimalField')(null=True, decimal_places=8, max_digits=10)),
            ('heading', self.gf('django.db.models.fields.DecimalField')(null=True, decimal_places=7, max_digits=10)),
            ('picture', self.gf('django.db.models.fields.files.FileField')(null=True, max_length=100)),
            ('creator', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['alias.Alias'])),
            ('location', self.gf('django.contrib.gis.db.models.fields.PointField')()),
        ))
        db.send_create_signal('event', ['Event'])

        # Adding M2M table for field tags on 'Event'
        m2m_table_name = db.shorten_name('event_event_tags')
        db.create_table(m2m_table_name, (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('event', models.ForeignKey(orm['event.event'], null=False)),
            ('interest', models.ForeignKey(orm['interest.interest'], null=False))
        ))
        db.create_unique(m2m_table_name, ['event_id', 'interest_id'])

        # Adding M2M table for field categories on 'Event'
        m2m_table_name = db.shorten_name('event_event_categories')
        db.create_table(m2m_table_name, (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('event', models.ForeignKey(orm['event.event'], null=False)),
            ('category', models.ForeignKey(orm['interest.category'], null=False))
        ))
        db.create_unique(m2m_table_name, ['event_id', 'category_id'])

        # Adding model 'EventGroup'
        db.create_table('event_eventgroup', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('maximum_size', self.gf('django.db.models.fields.IntegerField')()),
            ('meeting_place', self.gf('django.db.models.fields.TextField')()),
            ('event', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['event.Event'])),
        ))
        db.send_create_signal('event', ['EventGroup'])

        # Adding M2M table for field members on 'EventGroup'
        m2m_table_name = db.shorten_name('event_eventgroup_members')
        db.create_table(m2m_table_name, (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('eventgroup', models.ForeignKey(orm['event.eventgroup'], null=False)),
            ('alias', models.ForeignKey(orm['alias.alias'], null=False))
        ))
        db.create_unique(m2m_table_name, ['eventgroup_id', 'alias_id'])


    def backwards(self, orm):
        # Deleting model 'Event'
        db.delete_table('event_event')

        # Removing M2M table for field tags on 'Event'
        db.delete_table(db.shorten_name('event_event_tags'))

        # Removing M2M table for field categories on 'Event'
        db.delete_table(db.shorten_name('event_event_categories'))

        # Deleting model 'EventGroup'
        db.delete_table('event_eventgroup')

        # Removing M2M table for field members on 'EventGroup'
        db.delete_table(db.shorten_name('event_eventgroup_members'))


    models = {
        'alias.alias': {
            'Meta': {'object_name': 'Alias'},
            'about_me': ('django.db.models.fields.TextField', [], {'max_length': '2000', 'blank': 'True'}),
            'date_added': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'date_of_birth': ('django.db.models.fields.DateField', [], {'null': 'True'}),
            'email': ('django.db.models.fields.EmailField', [], {'max_length': '254', 'unique': 'True'}),
            'has_facebook': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'has_mingle': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'last_login': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
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
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'picture': ('django.db.models.fields.files.FileField', [], {'null': 'True', 'max_length': '100'}),
            'pitch': ('django.db.models.fields.DecimalField', [], {'null': 'True', 'decimal_places': '8', 'max_digits': '10'}),
            'tags': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['interest.Interest']", 'symmetrical': 'False'}),
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