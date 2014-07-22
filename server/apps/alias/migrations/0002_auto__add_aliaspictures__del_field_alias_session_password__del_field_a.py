# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'AliasPictures'
        db.create_table('alias_aliaspictures', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('alias', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['alias.Alias'])),
            ('is_profile_picture', self.gf('django.db.models.fields.BooleanField')(default=False)),
            ('picture', self.gf('django.db.models.fields.files.ImageField')(max_length=100)),
        ))
        db.send_create_signal('alias', ['AliasPictures'])

        # Deleting field 'Alias.session_password'
        db.delete_column('alias_alias', 'session_password')

        # Deleting field 'Alias.picture'
        db.delete_column('alias_alias', 'picture')

        # Deleting field 'Alias.has_mingle'
        db.delete_column('alias_alias', 'has_mingle')

        # Deleting field 'Alias.has_facebook'
        db.delete_column('alias_alias', 'has_facebook')

        # Adding M2M table for field friends on 'Alias'
        m2m_table_name = db.shorten_name('alias_alias_friends')
        db.create_table(m2m_table_name, (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('from_alias', models.ForeignKey(orm['alias.alias'], null=False)),
            ('to_alias', models.ForeignKey(orm['alias.alias'], null=False))
        ))
        db.create_unique(m2m_table_name, ['from_alias_id', 'to_alias_id'])


    def backwards(self, orm):
        # Deleting model 'AliasPictures'
        db.delete_table('alias_aliaspictures')

        # Adding field 'Alias.session_password'
        db.add_column('alias_alias', 'session_password',
                      self.gf('django.db.models.fields.CharField')(max_length=64, null=True),
                      keep_default=False)

        # Adding field 'Alias.picture'
        db.add_column('alias_alias', 'picture',
                      self.gf('django.db.models.fields.files.ImageField')(max_length=100, null=True),
                      keep_default=False)

        # Adding field 'Alias.has_mingle'
        db.add_column('alias_alias', 'has_mingle',
                      self.gf('django.db.models.fields.BooleanField')(default=False),
                      keep_default=False)

        # Adding field 'Alias.has_facebook'
        db.add_column('alias_alias', 'has_facebook',
                      self.gf('django.db.models.fields.BooleanField')(default=False),
                      keep_default=False)

        # Removing M2M table for field friends on 'Alias'
        db.delete_table(db.shorten_name('alias_alias_friends'))


    models = {
        'alias.alias': {
            'Meta': {'object_name': 'Alias'},
            'about_me': ('django.db.models.fields.TextField', [], {'blank': 'True', 'max_length': '2000'}),
            'date_added': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now_add': 'True'}),
            'date_of_birth': ('django.db.models.fields.DateField', [], {'null': 'True'}),
            'email': ('django.db.models.fields.EmailField', [], {'unique': 'True', 'max_length': '254'}),
            'friends': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'friends_rel_+'", 'to': "orm['alias.Alias']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'last_login': ('django.db.models.fields.DateTimeField', [], {'blank': 'True', 'auto_now': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '71'}),
            'password': ('django.db.models.fields.CharField', [], {'max_length': '64', 'null': 'True'}),
            'phone_number': ('django.db.models.fields.IntegerField', [], {'max_length': '10', 'null': 'True'}),
            'salt': ('django.db.models.fields.CharField', [], {'max_length': '16'})
        },
        'alias.aliaspictures': {
            'Meta': {'object_name': 'AliasPictures'},
            'alias': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['alias.Alias']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'is_profile_picture': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'picture': ('django.db.models.fields.files.ImageField', [], {'max_length': '100'})
        }
    }

    complete_apps = ['alias']