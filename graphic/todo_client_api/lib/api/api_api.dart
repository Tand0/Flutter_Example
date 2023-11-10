//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ApiApi {
  ApiApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Delete Items User
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] yyyy (required):
  ///
  /// * [int] mm (required):
  Future<Response> deleteItemsUserApiItemsYyyyMmDeleteWithHttpInfo(int yyyy, int mm,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/items/{yyyy}/{mm}'
      .replaceAll('{yyyy}', yyyy.toString())
      .replaceAll('{mm}', mm.toString());

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

  /// Delete Items User
  ///
  /// Parameters:
  ///
  /// * [int] yyyy (required):
  ///
  /// * [int] mm (required):
  Future<void> deleteItemsUserApiItemsYyyyMmDelete(int yyyy, int mm,) async {
    final response = await deleteItemsUserApiItemsYyyyMmDeleteWithHttpInfo(yyyy, mm,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete Web User
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  Future<Response> deleteWebUserApiUserUsernameDeleteWithHttpInfo(String username,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/user/{username}'
      .replaceAll('{username}', username);

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

  /// Delete Web User
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  Future<void> deleteWebUserApiUserUsernameDelete(String username,) async {
    final response = await deleteWebUserApiUserUsernameDeleteWithHttpInfo(username,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get Items All
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] yyyy (required):
  ///
  /// * [int] mm (required):
  Future<Response> getItemsAllApiItemsAllYyyyMmGetWithHttpInfo(int yyyy, int mm,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/items/All/{yyyy}/{mm}'
      .replaceAll('{yyyy}', yyyy.toString())
      .replaceAll('{mm}', mm.toString());

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

  /// Get Items All
  ///
  /// Parameters:
  ///
  /// * [int] yyyy (required):
  ///
  /// * [int] mm (required):
  Future<void> getItemsAllApiItemsAllYyyyMmGet(int yyyy, int mm,) async {
    final response = await getItemsAllApiItemsAllYyyyMmGetWithHttpInfo(yyyy, mm,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get Items
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getItemsApiItemsAllGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/items/All';

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
  Future<void> getItemsApiItemsAllGet() async {
    final response = await getItemsApiItemsAllGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get Items User
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] yyyy (required):
  ///
  /// * [int] mm (required):
  Future<Response> getItemsUserApiItemsYyyyMmGetWithHttpInfo(int yyyy, int mm,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/items/{yyyy}/{mm}'
      .replaceAll('{yyyy}', yyyy.toString())
      .replaceAll('{mm}', mm.toString());

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

  /// Get Items User
  ///
  /// Parameters:
  ///
  /// * [int] yyyy (required):
  ///
  /// * [int] mm (required):
  Future<void> getItemsUserApiItemsYyyyMmGet(int yyyy, int mm,) async {
    final response = await getItemsUserApiItemsYyyyMmGetWithHttpInfo(yyyy, mm,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get Web User
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getWebUserApiUserGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/user';

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

  /// Get Web User
  Future<void> getWebUserApiUserGet() async {
    final response = await getWebUserApiUserGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
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
  Future<Response> loginForAccessTokenApiTokenPostWithHttpInfo(String username, String password, { String? grantType, String? scope, String? clientId, String? clientSecret, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/token';

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
  Future<Token?> loginForAccessTokenApiTokenPost(String username, String password, { String? grantType, String? scope, String? clientId, String? clientSecret, }) async {
    final response = await loginForAccessTokenApiTokenPostWithHttpInfo(username, password,  grantType: grantType, scope: scope, clientId: clientId, clientSecret: clientSecret, );
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

  /// Post Items User
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] yyyy (required):
  ///
  /// * [int] mm (required):
  ///
  /// * [Object] body (required):
  Future<Response> postItemsUserApiItemsYyyyMmPostWithHttpInfo(int yyyy, int mm, Object body,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/items/{yyyy}/{mm}'
      .replaceAll('{yyyy}', yyyy.toString())
      .replaceAll('{mm}', mm.toString());

    // ignore: prefer_final_locals
    Object? postBody = body;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


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

  /// Post Items User
  ///
  /// Parameters:
  ///
  /// * [int] yyyy (required):
  ///
  /// * [int] mm (required):
  ///
  /// * [Object] body (required):
  Future<void> postItemsUserApiItemsYyyyMmPost(int yyyy, int mm, Object body,) async {
    final response = await postItemsUserApiItemsYyyyMmPostWithHttpInfo(yyyy, mm, body,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Post Web User
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] passwd (required):
  Future<Response> postWebUserApiUserUsernamePostWithHttpInfo(String username, String passwd,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/user/{username}'
      .replaceAll('{username}', username);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'passwd', passwd));

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

  /// Post Web User
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] passwd (required):
  Future<void> postWebUserApiUserUsernamePost(String username, String passwd,) async {
    final response = await postWebUserApiUserUsernamePostWithHttpInfo(username, passwd,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
