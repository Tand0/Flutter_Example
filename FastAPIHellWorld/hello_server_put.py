from fastapi import FastAPI, HTTPException
from fastapi.responses import PlainTextResponse
from pydantic import BaseModel
import uvicorn
import os

app = FastAPI()


class Item(BaseModel):
    id: int
    name: str


ITEM = {}


@app.get("/", response_class=PlainTextResponse)
def get_top():
    return "Hello world"


@app.get("/items")
def get_item():
    return ITEM


@app.get("/items/{item_id}", response_model=Item)
def get_items(item_id: str):
    if item_id not in ITEM:
        ITEM.pop(item_id)
    else:
        raise HTTPException(status_code=404, detail="Item not found")
    return ITEM[item_id]


@app.post("/items")
def post_item():
    return get_item()


@app.post("/items/{item_id}", response_model=Item)
def post_items(item_id: str):
    return get_items(item_id)


@app.put("/items/{item_id}", response_model=Item)
def put_item(item_id: str, item: Item):
    ITEM[item_id] = item
    return item


@app.delete("/items/{item_id}")
def delete_item(item_id: str):
    if item_id in ITEM:
        ITEM.pop(item_id)
    return "OK"


def main():
    file_path = os.path.basename(__file__)
    file_name = os.path.splitext(os.path.basename(file_path))[0]
    uvicorn.run(file_name + ":app", host="192.168.1.1", port=3005, reload=True)


if __name__ == "__main__":
    main()
#
