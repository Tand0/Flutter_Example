from fastapi import FastAPI
import uvicorn
import os

app = FastAPI()

ITEM = {"hello": "world"}


def get_item():
    return ITEM


@app.get("/item")
def read_root():
    return get_item()


def main():
    file_path = os.path.basename(__file__)
    file_name = os.path.splitext(os.path.basename(file_path))[0]
    uvicorn.run(file_name + ":app", host="192.168.1.1", port=3001, reload=True)


if __name__ == "__main__":
    main()
#
