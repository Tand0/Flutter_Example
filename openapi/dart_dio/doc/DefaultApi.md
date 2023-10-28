# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *&#39;http://192.168.1.1:3002&#39;*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteItemItemsItemIdDelete**](DefaultApi.md#deleteitemitemsitemiddelete) | **DELETE** /items/{item_id} | Delete Item
[**getItemItemsGet**](DefaultApi.md#getitemitemsget) | **GET** /items | Get Item
[**getItemsItemsItemIdGet**](DefaultApi.md#getitemsitemsitemidget) | **GET** /items/{item_id} | Get Items
[**getTopGet**](DefaultApi.md#gettopget) | **GET** / | Get Top
[**loginForAccessTokenTokenPost**](DefaultApi.md#loginforaccesstokentokenpost) | **POST** /token | Login For Access Token
[**postItemItemsPost**](DefaultApi.md#postitemitemspost) | **POST** /items | Post Item
[**postItemsItemsItemIdPost**](DefaultApi.md#postitemsitemsitemidpost) | **POST** /items/{item_id} | Post Items
[**putItemItemsItemIdPut**](DefaultApi.md#putitemitemsitemidput) | **PUT** /items/{item_id} | Put Item


# **deleteItemItemsItemIdDelete**
> deleteItemItemsItemIdDelete(itemId)

Delete Item

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDefaultApi();
final String itemId = itemId_example; // String | 

try {
    api.deleteItemItemsItemIdDelete(itemId);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->deleteItemItemsItemIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **itemId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getItemItemsGet**
> getItemItemsGet()

Get Item

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDefaultApi();

try {
    api.getItemItemsGet();
} catch on DioException (e) {
    print('Exception when calling DefaultApi->getItemItemsGet: $e\n');
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

# **getItemsItemsItemIdGet**
> Item getItemsItemsItemIdGet(itemId)

Get Items

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDefaultApi();
final String itemId = itemId_example; // String | 

try {
    final response = api.getItemsItemsItemIdGet(itemId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->getItemsItemsItemIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **itemId** | **String**|  | 

### Return type

[**Item**](Item.md)

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

final api = Openapi().getDefaultApi();

try {
    final response = api.getTopGet();
    print(response);
} catch on DioException (e) {
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

# **loginForAccessTokenTokenPost**
> Token loginForAccessTokenTokenPost(username, password, grantType, scope, clientId, clientSecret)

Login For Access Token

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final String username = username_example; // String | 
final String password = password_example; // String | 
final String grantType = grantType_example; // String | 
final String scope = scope_example; // String | 
final String clientId = clientId_example; // String | 
final String clientSecret = clientSecret_example; // String | 

try {
    final response = api.loginForAccessTokenTokenPost(username, password, grantType, scope, clientId, clientSecret);
    print(response);
} catch on DioException (e) {
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

# **postItemItemsPost**
> postItemItemsPost()

Post Item

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDefaultApi();

try {
    api.postItemItemsPost();
} catch on DioException (e) {
    print('Exception when calling DefaultApi->postItemItemsPost: $e\n');
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

# **postItemsItemsItemIdPost**
> Item postItemsItemsItemIdPost(itemId)

Post Items

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDefaultApi();
final String itemId = itemId_example; // String | 

try {
    final response = api.postItemsItemsItemIdPost(itemId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->postItemsItemsItemIdPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **itemId** | **String**|  | 

### Return type

[**Item**](Item.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **putItemItemsItemIdPut**
> Item putItemItemsItemIdPut(itemId, item)

Put Item

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDefaultApi();
final String itemId = itemId_example; // String | 
final Item item = ; // Item | 

try {
    final response = api.putItemItemsItemIdPut(itemId, item);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->putItemItemsItemIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **itemId** | **String**|  | 
 **item** | [**Item**](Item.md)|  | 

### Return type

[**Item**](Item.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

