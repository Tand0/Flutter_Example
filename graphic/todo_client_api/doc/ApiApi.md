# openapi.api.ApiApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteItemsUserApiItemsYyyyMmDelete**](ApiApi.md#deleteitemsuserapiitemsyyyymmdelete) | **DELETE** /api/items/{yyyy}/{mm} | Delete Items User
[**deleteWebUserApiUserUsernameDelete**](ApiApi.md#deletewebuserapiuserusernamedelete) | **DELETE** /api/user/{username} | Delete Web User
[**getItemsAllApiItemsAllYyyyMmGet**](ApiApi.md#getitemsallapiitemsallyyyymmget) | **GET** /api/items/All/{yyyy}/{mm} | Get Items All
[**getItemsApiItemsAllGet**](ApiApi.md#getitemsapiitemsallget) | **GET** /api/items/All | Get Items
[**getItemsUserApiItemsYyyyMmGet**](ApiApi.md#getitemsuserapiitemsyyyymmget) | **GET** /api/items/{yyyy}/{mm} | Get Items User
[**getWebUserApiUserGet**](ApiApi.md#getwebuserapiuserget) | **GET** /api/user | Get Web User
[**loginForAccessTokenApiTokenPost**](ApiApi.md#loginforaccesstokenapitokenpost) | **POST** /api/token | Login For Access Token
[**postItemsUserApiItemsYyyyMmPost**](ApiApi.md#postitemsuserapiitemsyyyymmpost) | **POST** /api/items/{yyyy}/{mm} | Post Items User
[**postWebUserApiUserUsernamePost**](ApiApi.md#postwebuserapiuserusernamepost) | **POST** /api/user/{username} | Post Web User


# **deleteItemsUserApiItemsYyyyMmDelete**
> deleteItemsUserApiItemsYyyyMmDelete(yyyy, mm)

Delete Items User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = ApiApi();
final yyyy = 56; // int | 
final mm = 56; // int | 

try {
    api_instance.deleteItemsUserApiItemsYyyyMmDelete(yyyy, mm);
} catch (e) {
    print('Exception when calling ApiApi->deleteItemsUserApiItemsYyyyMmDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **yyyy** | **int**|  | 
 **mm** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteWebUserApiUserUsernameDelete**
> deleteWebUserApiUserUsernameDelete(username)

Delete Web User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = ApiApi();
final username = username_example; // String | 

try {
    api_instance.deleteWebUserApiUserUsernameDelete(username);
} catch (e) {
    print('Exception when calling ApiApi->deleteWebUserApiUserUsernameDelete: $e\n');
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

# **getItemsAllApiItemsAllYyyyMmGet**
> getItemsAllApiItemsAllYyyyMmGet(yyyy, mm)

Get Items All

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = ApiApi();
final yyyy = 56; // int | 
final mm = 56; // int | 

try {
    api_instance.getItemsAllApiItemsAllYyyyMmGet(yyyy, mm);
} catch (e) {
    print('Exception when calling ApiApi->getItemsAllApiItemsAllYyyyMmGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **yyyy** | **int**|  | 
 **mm** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getItemsApiItemsAllGet**
> getItemsApiItemsAllGet()

Get Items

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = ApiApi();

try {
    api_instance.getItemsApiItemsAllGet();
} catch (e) {
    print('Exception when calling ApiApi->getItemsApiItemsAllGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getItemsUserApiItemsYyyyMmGet**
> getItemsUserApiItemsYyyyMmGet(yyyy, mm)

Get Items User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = ApiApi();
final yyyy = 56; // int | 
final mm = 56; // int | 

try {
    api_instance.getItemsUserApiItemsYyyyMmGet(yyyy, mm);
} catch (e) {
    print('Exception when calling ApiApi->getItemsUserApiItemsYyyyMmGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **yyyy** | **int**|  | 
 **mm** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWebUserApiUserGet**
> getWebUserApiUserGet()

Get Web User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = ApiApi();

try {
    api_instance.getWebUserApiUserGet();
} catch (e) {
    print('Exception when calling ApiApi->getWebUserApiUserGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginForAccessTokenApiTokenPost**
> Token loginForAccessTokenApiTokenPost(username, password, grantType, scope, clientId, clientSecret)

Login For Access Token

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ApiApi();
final username = username_example; // String | 
final password = password_example; // String | 
final grantType = grantType_example; // String | 
final scope = scope_example; // String | 
final clientId = clientId_example; // String | 
final clientSecret = clientSecret_example; // String | 

try {
    final result = api_instance.loginForAccessTokenApiTokenPost(username, password, grantType, scope, clientId, clientSecret);
    print(result);
} catch (e) {
    print('Exception when calling ApiApi->loginForAccessTokenApiTokenPost: $e\n');
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

# **postItemsUserApiItemsYyyyMmPost**
> postItemsUserApiItemsYyyyMmPost(yyyy, mm, body)

Post Items User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = ApiApi();
final yyyy = 56; // int | 
final mm = 56; // int | 
final body = Object(); // Object | 

try {
    api_instance.postItemsUserApiItemsYyyyMmPost(yyyy, mm, body);
} catch (e) {
    print('Exception when calling ApiApi->postItemsUserApiItemsYyyyMmPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **yyyy** | **int**|  | 
 **mm** | **int**|  | 
 **body** | **Object**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postWebUserApiUserUsernamePost**
> postWebUserApiUserUsernamePost(username, passwd)

Post Web User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = ApiApi();
final username = username_example; // String | 
final passwd = passwd_example; // String | 

try {
    api_instance.postWebUserApiUserUsernamePost(username, passwd);
} catch (e) {
    print('Exception when calling ApiApi->postWebUserApiUserUsernamePost: $e\n');
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

