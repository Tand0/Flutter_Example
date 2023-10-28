# openapi (EXPERIMENTAL)
No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)

This Dart package is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: 0.1.0
- Build package: org.openapitools.codegen.languages.DartDioClientCodegen

## Requirements

* Dart 2.15.0+ or Flutter 2.8.0+
* Dio 5.0.0+ (https://pub.dev/packages/dio)

## Installation & Usage

### pub.dev
To use the package from [pub.dev](https://pub.dev), please include the following in pubspec.yaml
```yaml
dependencies:
  openapi: 1.0.0
```

### Github
If this Dart package is published to Github, please include the following in pubspec.yaml
```yaml
dependencies:
  openapi:
    git:
      url: https://github.com/GIT_USER_ID/GIT_REPO_ID.git
      #ref: main
```

### Local development
To use the package from your local drive, please include the following in pubspec.yaml
```yaml
dependencies:
  openapi:
    path: /path/to/openapi
```

## Getting Started

Please follow the [installation procedure](#installation--usage) and then run the following:

```dart
import 'package:openapi/openapi.dart';


final api = Openapi().getDefaultApi();
final String itemId = itemId_example; // String | 

try {
    api.deleteItemItemsItemIdDelete(itemId);
} catch on DioException (e) {
    print("Exception when calling DefaultApi->deleteItemItemsItemIdDelete: $e\n");
}

```

## Documentation for API Endpoints

All URIs are relative to *http://localhost*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
[*DefaultApi*](doc/DefaultApi.md) | [**deleteItemItemsItemIdDelete**](doc/DefaultApi.md#deleteitemitemsitemiddelete) | **DELETE** /items/{item_id} | Delete Item
[*DefaultApi*](doc/DefaultApi.md) | [**getItemItemsGet**](doc/DefaultApi.md#getitemitemsget) | **GET** /items | Get Item
[*DefaultApi*](doc/DefaultApi.md) | [**getItemsItemsItemIdGet**](doc/DefaultApi.md#getitemsitemsitemidget) | **GET** /items/{item_id} | Get Items
[*DefaultApi*](doc/DefaultApi.md) | [**getTopGet**](doc/DefaultApi.md#gettopget) | **GET** / | Get Top
[*DefaultApi*](doc/DefaultApi.md) | [**loginForAccessTokenTokenPost**](doc/DefaultApi.md#loginforaccesstokentokenpost) | **POST** /token | Login For Access Token
[*DefaultApi*](doc/DefaultApi.md) | [**postItemItemsPost**](doc/DefaultApi.md#postitemitemspost) | **POST** /items | Post Item
[*DefaultApi*](doc/DefaultApi.md) | [**postItemsItemsItemIdPost**](doc/DefaultApi.md#postitemsitemsitemidpost) | **POST** /items/{item_id} | Post Items
[*DefaultApi*](doc/DefaultApi.md) | [**putItemItemsItemIdPut**](doc/DefaultApi.md#putitemitemsitemidput) | **PUT** /items/{item_id} | Put Item


## Documentation For Models

 - [HTTPValidationError](doc/HTTPValidationError.md)
 - [Item](doc/Item.md)
 - [Token](doc/Token.md)
 - [ValidationError](doc/ValidationError.md)
 - [ValidationErrorLocInner](doc/ValidationErrorLocInner.md)


## Documentation For Authorization


Authentication schemes defined for the API:
### OAuth2PasswordBearer

- **Type**: OAuth
- **Flow**: password
- **Authorization URL**: 
- **Scopes**: N/A


## Author


