from django import template
register = template.Library()

@register.filter(name='set_class')
def ste_class(field, css):
    """

    """
    return field.as_widget(attrs={"class": css})

