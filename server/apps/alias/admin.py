from django.contrib import admin
from apps.alias.models import *


class AliasAdmin(admin.ModelAdmin):
    fields = ['email', 'first_name', 'last_name', 'last_login', 'date_added']


admin.site.register(Alias, AliasAdmin)