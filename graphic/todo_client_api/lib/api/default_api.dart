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

  /// Delete Web User
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  Future<Response> deleteWebUserUserDeleteWithHttpInfo(String username,) async {
    // ignore: prefer_const_declarations
    final path = r'/user';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'username', username));

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
  Future<void> deleteWebUserUserDelete(String username,) async {
    final response = await deleteWebUserUserDeleteWithHttpInfo(username,);
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
  Future<Response> getItemsUserItemsYyyyMmGetWithHttpInfo(int yyyy, int mm,) async {
    // ignore: prefer_const_declarations
    final path = r'/items/{yyyy}/{mm}'
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
  Future<String?> getItemsUserItemsYyyyMmGet(int yyyy, int mm,) async {
    final response = await getItemsUserItemsYyyyMmGetWithHttpInfo(yyyy, mm,);
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

  /// Get Web User
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getWebUserUserGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user';

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
  Future<List<String>?> getWebUserUserGet() async {
    final response = await getWebUserUserGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<String>') as List)
        .cast<String>()
        .toList(growable: false);

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
  /// * [int] dd (required):
  ///
  /// * [DayEventBody] dayEventBody (required):
  Future<Response> postItemsUserItemsYyyyMmDdPostWithHttpInfo(int yyyy, int mm, int dd, DayEventBody dayEventBody,) async {
    // ignore: prefer_const_declarations
    final path = r'/items/{yyyy}/{mm}/{dd}'
      .replaceAll('{yyyy}', yyyy.toString())
      .replaceAll('{mm}', mm.toString())
      .replaceAll('{dd}', dd.toString());

    // ignore: prefer_final_locals
    Object? postBody = dayEventBody;

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
  /// * [int] dd (required):
  ///
  /// * [DayEventBody] dayEventBody (required):
  Future<void> postItemsUserItemsYyyyMmDdPost(int yyyy, int mm, int dd, DayEventBody dayEventBody,) async {
    final response = await postItemsUserItemsYyyyMmDdPostWithHttpInfo(yyyy, mm, dd, dayEventBody,);
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
  Future<Response> postWebUserUserPostWithHttpInfo(String username, String passwd,) async {
    // ignore: prefer_const_declarations
    final path = r'/user';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'username', username));
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
  Future<void> postWebUserUserPost(String username, String passwd,) async {
    final response = await postWebUserUserPostWithHttpInfo(username, passwd,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
