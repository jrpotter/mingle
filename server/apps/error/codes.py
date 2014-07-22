class ErrorCode:
    """

    """
    NO_ERROR = 0

    INVALID_LOGIN_TYPE = 100
    INVALID_MINGLE_LOGIN = 101
    INVALID_FACEBOOK_LOGIN = 102
    INVALID_CREDENTIAL_REQUEST = 103

    INVALID_EVENT_QUERY_REQUEST = 200
    INVALID_EVENT_CREATION_REQUEST = 201
    INVALID_EVENT_GROUP_QUERY_REQUEST = 202

    @classmethod
    def message(cls, code):

        response = {'code': code}

        if code == cls.INVALID_LOGIN_TYPE:
            response.update({'error': "Invalid Login Type Passed"})
        elif code == cls.INVALID_MINGLE_LOGIN:
            response.update({'error': "Mingle credentials are invalid"})
        elif code == cls.INVALID_FACEBOOK_LOGIN:
            response.update({'error': "Facebook credentials are invalid"})
        elif code == cls.INVALID_CREDENTIAL_REQUEST:
            response.update({'error': "Request with invalid credentials"})

        elif code == cls.INVALID_EVENT_QUERY_REQUEST:
            response.update({'error': "Invalid event query"})
        elif code == cls.INVALID_EVENT_CREATION_REQUEST:
            response.update({'error': "Invalid event creation form"})
        elif code == cls.INVALID_EVENT_GROUP_QUERY_REQUEST:
            response.update({'error': "Invalid event group request"})

        return response