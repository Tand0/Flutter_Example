import 'package:openapi/api.dart';

Future<void> main() async {
  ApiClient defaultApiClient = ApiClient(basePath: "http://192.168.1.1:3002");
  final DefaultApi apiInstance = DefaultApi(defaultApiClient);
  try {
    String? result = await apiInstance.getTopGet();
    print(result);
    //
    const username = "root"; // String |
    const password = "root"; // String |
    //
    Token? token =
        await apiInstance.loginForAccessTokenTokenPost(username, password);
    String? accessToken = token?.accessToken;
    print(accessToken);
    //
    var authentication = HttpBearerAuth();
    authentication.accessToken = accessToken;
    var newClient = ApiClient(
      basePath: 'http://192.168.1.1:3002',
      authentication: authentication,
    );
    final DefaultApi newApiInstance = DefaultApi(newClient);
    int itemId = 0;
    Item item = Item(id: itemId, name: "world");
    await newApiInstance.putItemItemsItemIdPut(itemId.toString(), item);
    //
    final Item? getResult =
        await newApiInstance.getItemsItemsItemIdGet(itemId.toString());
    print(getResult?.name);
  } catch (e) {
    print('Exception when calling DefaultApi->getTopGet: $e\n');
  }
}
