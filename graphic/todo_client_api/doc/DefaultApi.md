# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteWebUserUserDelete**](DefaultApi.md#deletewebuseruserdelete) | **DELETE** /user | Delete Web User
[**getItemsUserItemsYyyyMmGet**](DefaultApi.md#getitemsuseritemsyyyymmget) | **GET** /items/{yyyy}/{mm} | Get Items User
[**getTopGet**](DefaultApi.md#gettopget) | **GET** / | Get Top
[**getWebUserUserGet**](DefaultApi.md#getwebuseruserget) | **GET** /user | Get Web User
[**loginForAccessTokenTokenPost**](DefaultApi.md#loginforaccesstokentokenpost) | **POST** /token | Login For Access Token
[**postItemsUserItemsYyyyMmDdPost**](DefaultApi.md#postitemsuseritemsyyyymmddpost) | **POST** /items/{yyyy}/{mm}/{dd} | Post Items User
[**postWebUserUserPost**](DefaultApi.md#postwebuseruserpost) | **POST** /user | Post Web User


# **deleteWebUserUserDelete**
> deleteWebUserUserDelete(username)

Delete Web User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = DefaultApi();
final username = username_example; // String | 

try {
    api_instance.deleteWebUserUserDelete(username);
} catch (e) {
    print('Exception when calling DefaultApi->deleteWebUserUserDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getItemsUserItemsYyyyMmGet**
> String getItemsUserItemsYyyyMmGet(yyyy, mm)

Get Items User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = DefaultApi();
final yyyy = 56; // int | 
final mm = 56; // int | 

try {
    final result = api_instance.getItemsUserItemsYyyyMmGet(yyyy, mm);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getItemsUserItemsYyyyMmGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **yyyy** | **int**|  | 
 **mm** | **int**|  | 

### Return type

**String**

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTopGet**
> String getTopGet()

Get Top

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();

try {
    final result = api_instance.getTopGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getTopGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWebUserUserGet**
> List<String> getWebUserUserGet()

Get Web User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = DefaultApi();

try {
    final result = api_instance.getWebUserUserGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getWebUserUserGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**List<String>**

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginForAccessTokenTokenPost**
> Token loginForAccessTokenTokenPost(username, password, grantType, scope, clientId, clientSecret)

Login For Access Token

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();
final username = username_example; // String | 
final password = password_example; // String | 
final grantType = grantType_example; // String | 
final scope = scope_example; // String | 
final clientId = clientId_example; // String | 
final clientSecret = clientSecret_example; // String | 

try {
    final result = api_instance.loginForAccessTokenTokenPost(username, password, grantType, scope, clientId, clientSecret);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->loginForAccessTokenTokenPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **String**|  | 
 **password** | **String**|  | 
 **grantType** | **String**|  | [optional] 
 **scope** | **String**|  | [optional] [default to '']
 **clientId** | **String**|  | [optional] 
 **clientSecret** | **String**|  | [optional] 

### Return type

[**Token**](Token.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postItemsUserItemsYyyyMmDdPost**
> postItemsUserItemsYyyyMmDdPost(yyyy, mm, dd, event)

Post Items User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = DefaultApi();
final yyyy = 56; // int | 
final mm = 56; // int | 
final dd = 56; // int | 
final event = event_example; // String | 

try {
    api_instance.postItemsUserItemsYyyyMmDdPost(yyyy, mm, dd, event);
} catch (e) {
    print('Exception when calling DefaultApi->postItemsUserItemsYyyyMmDdPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **yyyy** | **int**|  | 
 **mm** | **int**|  | 
 **dd** | **int**|  | 
 **event** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postWebUserUserPost**
> postWebUserUserPost(username, passwd)

Post Web User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = DefaultApi();
final username = username_example; // String | 
final passwd = passwd_example; // String | 

try {
    api_instance.postWebUserUserPost(username, passwd);
} catch (e) {
    print('Exception when calling DefaultApi->postWebUserUserPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **String**|  | 
 **passwd** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

