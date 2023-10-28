import requests


def main():

    with requests.Session() as session:
        #
        item = {
            "id": 1,
            "name": "hello"
        }
        #
        result = session.get("http://192.168.1.1:3005/items")
        print(result.status_code)
        print(result.text)
        #
        result = session.put("http://192.168.1.1:3005/items/1", json=item)
        print(result.status_code)
        print(result.text)
        #
        result = session.delete("http://192.168.1.1:3005/items/1")
        print(result.status_code)
        print(result.text)
        #
        result = session.post("http://192.168.1.1:3005/items/")
        print(result.status_code)
        print(result.text)
        #


if __name__ == "__main__":
    main()

#
