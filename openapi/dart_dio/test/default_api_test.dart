import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for DefaultApi
void main() {
  final instance = Openapi().getDefaultApi();

  group(DefaultApi, () {
    // Delete Item
    //
    //Future deleteItemItemsItemIdDelete(String itemId) async
    test('test deleteItemItemsItemIdDelete', () async {
      // TODO
    });

    // Get Item
    //
    //Future getItemItemsGet() async
    test('test getItemItemsGet', () async {
      // TODO
    });

    // Get Items
    //
    //Future<Item> getItemsItemsItemIdGet(String itemId) async
    test('test getItemsItemsItemIdGet', () async {
      // TODO
    });

    // Get Top
    //
    //Future<String> getTopGet() async
    test('test getTopGet', () async {
      // TODO
    });

    // Login For Access Token
    //
    //Future<Token> loginForAccessTokenTokenPost(String username, String password, { String grantType, String scope, String clientId, String clientSecret }) async
    test('test loginForAccessTokenTokenPost', () async {
      // TODO
    });

    // Post Item
    //
    //Future postItemItemsPost() async
    test('test postItemItemsPost', () async {
      // TODO
    });

    // Post Items
    //
    //Future<Item> postItemsItemsItemIdPost(String itemId) async
    test('test postItemsItemsItemIdPost', () async {
      // TODO
    });

    // Put Item
    //
    //Future<Item> putItemItemsItemIdPut(String itemId, Item item) async
    test('test putItemItemsItemIdPut', () async {
      // TODO
    });

  });
}
