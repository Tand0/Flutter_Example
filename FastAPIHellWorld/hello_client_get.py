import requests
import pprint


def main():
    with requests.Session() as session:
        result = session.get("http://192.168.1.1:3001/item")
        pprint.pprint(vars(result))


if __name__ == "__main__":
    main()

#
