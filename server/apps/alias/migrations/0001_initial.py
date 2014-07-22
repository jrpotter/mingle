# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Alias'
        db.create_table('alias_alias', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=71)),
            ('email', self.gf('django.db.models.fields.EmailField')(unique=True, max_length=254)),
            ('date_of_birth', self.gf('django.db.models.fields.DateField')(null=True)),
            ('about_me', self.gf('django.db.models.fields.TextField')(blank=True, max_length=2000)),
            ('phone_number', self.gf('django.db.models.fields.IntegerField')(null=True, max_length=10)),
            ('picture', self.gf('django.db.models.fields.files.ImageField')(null=True, max_length=100)),
            ('salt', self.gf('django.db.models.fields.CharField')(max_length=16)),
            ('password', self.gf('django.db.models.fields.CharField')(null=True, max_length=64)),
            ('session_password', self.gf('django.db.models.fields.CharField')(null=True, max_length=64)),
            ('has_mingle', self.gf('django.db.models.fields.BooleanField')(default=False)),
            ('has_facebook', self.gf('django.db.models.fields.BooleanField')(default=False)),
            ('last_login', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('date_added', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal('alias', ['Alias'])


    def backwards(self, orm):
        # Deleting model 'Alias'
        db.delete_table('alias_alias')


    models = {
        'alias.alias': {
            'Meta': {'object_name': 'Alias'},
            'about_me': ('django.db.models.fields.TextField', [], {'blank': 'True', 'max_length': '2000'}),
            'date_added': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'date_of_birth': ('django.db.models.fields.DateField', [], {'null': 'True'}),
            'email': ('django.db.models.fields.EmailField', [], {'unique': 'True', 'max_length': '254'}),
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
        }
    }

    complete_apps = ['alias']