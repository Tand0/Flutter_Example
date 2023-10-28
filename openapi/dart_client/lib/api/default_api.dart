//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class DefaultApi {
  DefaultApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Delete Item
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] itemId (required):
  Future<Response> deleteItemItemsItemIdDeleteWithHttpInfo(String itemId,) async {
    // ignore: prefer_const_declarations
    final path = r'/items/{item_id}'
      .replaceAll('{item_id}', itemId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete Item
  ///
  /// Parameters:
  ///
  /// * [String] itemId (required):
  Future<void> deleteItemItemsItemIdDelete(String itemId,) async {
    final response = await deleteItemItemsItemIdDeleteWithHttpInfo(itemId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get Item
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getItemItemsGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/items';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get Item
  Future<void> getItemItemsGet() async {
    final response = await getItemItemsGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get Items
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] itemId (required):
  Future<Response> getItemsItemsItemIdGetWithHttpInfo(String itemId,) async {
    // ignore: prefer_const_declarations
    final path = r'/items/{item_id}'
      .replaceAll('{item_id}', itemId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get Items
  ///
  /// Parameters:
  ///
  /// * [String] itemId (required):
  Future<Item?> getItemsItemsItemIdGet(String itemId,) async {
    final response = await getItemsItemsItemIdGetWithHttpInfo(itemId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Item',) as Item;
    
    }
    return null;
  }

  /// Get Top
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getTopGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get Top
  Future<String?> getTopGet() async {
    final response = await getTopGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Login For Access Token
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] password (required):
  ///
  /// * [String] grantType:
  ///
  /// * [String] scope:
  ///
  /// * [String] clientId:
  ///
  /// * [String] clientSecret:
  Future<Response> loginForAccessTokenTokenPostWithHttpInfo(String username, String password, { String? grantType, String? scope, String? clientId, String? clientSecret, }) async {
    // ignore: prefer_const_declarations
    final path = r'/token';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/x-www-form-urlencoded'];

    if (grantType != null) {
      formParams[r'grant_type'] = parameterToString(grantType);
    }
    if (username != null) {
      formParams[r'username'] = parameterToString(username);
    }
    if (password != null) {
      formParams[r'password'] = parameterToString(password);
    }
    if (scope != null) {
      formParams[r'scope'] = parameterToString(scope);
    }
    if (clientId != null) {
      formParams[r'client_id'] = parameterToString(clientId);
    }
    if (clientSecret != null) {
      formParams[r'client_secret'] = parameterToString(clientSecret);
    }

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Login For Access Token
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] password (required):
  ///
  /// * [String] grantType:
  ///
  /// * [String] scope:
  ///
  /// * [String] clientId:
  ///
  /// * [String] clientSecret:
  Future<Token?> loginForAccessTokenTokenPost(String username, String password, { String? grantType, String? scope, String? clientId, String? clientSecret, }) async {
    final response = await loginForAccessTokenTokenPostWithHttpInfo(username, password,  grantType: grantType, scope: scope, clientId: clientId, clientSecret: clientSecret, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Token',) as Token;
    
    }
    return null;
  }

  /// Post Item
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> postItemItemsPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/items';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Post Item
  Future<void> postItemItemsPost() async {
    final response = await postItemItemsPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Post Items
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] itemId (required):
  Future<Response> postItemsItemsItemIdPostWithHttpInfo(String itemId,) async {
    // ignore: prefer_const_declarations
    final path = r'/items/{item_id}'
      .replaceAll('{item_id}', itemId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Post Items
  ///
  /// Parameters:
  ///
  /// * [String] itemId (required):
  Future<Item?> postItemsItemsItemIdPost(String itemId,) async {
    final response = await postItemsItemsItemIdPostWithHttpInfo(itemId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Item',) as Item;
    
    }
    return null;
  }

  /// Put Item
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] itemId (required):
  ///
  /// * [Item] item (required):
  Future<Response> putItemItemsItemIdPutWithHttpInfo(String itemId, Item item,) async {
    // ignore: prefer_const_declarations
    final path = r'/items/{item_id}'
      .replaceAll('{item_id}', itemId);

    // ignore: prefer_final_locals
    Object? postBody = item;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Put Item
  ///
  /// Parameters:
  ///
  /// * [String] itemId (required):
  ///
  /// * [Item] item (required):
  Future<Item?> putItemItemsItemIdPut(String itemId, Item item,) async {
    final response = await putItemItemsItemIdPutWithHttpInfo(itemId, item,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Item',) as Item;
    
    }
    return null;
  }
}
