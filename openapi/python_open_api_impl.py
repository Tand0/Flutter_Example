import sys
sys.path.append("./python")
from openapi_client import Configuration, ApiClient, DefaultApi
# from openapi_client.models.token import Token
from openapi_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = Configuration("http://192.168.1.1:3002")


# Enter a context with an instance of the API client
with ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = DefaultApi(api_client)
    username = 'root'
    password = 'root'
    # grant_type = 'grant_type_example' # str |  (optional)
    # scope = '' # str |  (optional) (default to '')
    # client_id = 'client_id_example' # str |  (optional)
    # client_secret = 'client_secret_example' # str |  (optional)

    try:
        # Login For Access Token
        api_response = api_instance.login_for_access_token_token_post(username, password)
        print("The response of DefaultApi->login_for_access_token_token_post:\n")
        pprint(api_response)
    except ApiException as e:
        print("Exception when calling DefaultApi->login_for_access_token_token_post: %s\n" % e)

#
