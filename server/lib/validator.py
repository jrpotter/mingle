from django.core.exceptions import ValidationError


def strip_values(fields, cleaned_data):
    """
    Strips the values of the passed form data.

    This only performs stripping on string values and throws an error if any of
    the values are empty.
    """
    try:
        for key in fields:
            if isinstance(cleaned_data[key], str):
                cleaned_data[key] = cleaned_data[key].strip()
                if not cleaned_data[key]:
                    raise KeyError
            else:
                raise ValidationError("Passed non-string object")
    except KeyError:
        raise ValidationError("Not all fields provided")