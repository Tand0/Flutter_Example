import requests
import json


# openapi-generator-cli generate -g dart -i todo_server/openapi.json -o todo_client_api

def main():
    with requests.Session() as session:
        result = session.get("http://192.168.1.1:3003/openapi.json")
        if (result.status_code != 200):
            print("ERROR: status_code=" + str(result.status_code))
            return
        data = json.loads(result.text)
        if (("components" in data) and ("schemas" in data["components"])
            and ("ValidationError" in data["components"]["schemas"])
            and ("properties" in data["components"]["schemas"]["ValidationError"])
                and ("loc" in data["components"]["schemas"]["ValidationError"]["properties"])
                and ("items" in data["components"]["schemas"]["ValidationError"]["properties"]["loc"])):
            data["components"]["schemas"]["ValidationError"]["properties"]["loc"]["items"] = {"type": "string"}
        with open('./todo_server/openapi.json', 'w') as f:
            json.dump(data, f, indent=2)


if __name__ == "__main__":
    main()

#
