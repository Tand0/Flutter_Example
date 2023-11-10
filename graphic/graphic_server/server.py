from fastapi import FastAPI
# from pydantic import BaseModel
from starlette.middleware.cors import CORSMiddleware
import uvicorn
import json
import os
from fastapi.staticfiles import StaticFiles


app = FastAPI()
TEXT_NAME = "./data.json"

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)


@app.get("/items", response_model=dict)
def get_item():
    item = {}
    if os.path.isfile(TEXT_NAME):
        try:
            with open(TEXT_NAME, encoding="utf-8") as f:
                text = f.read()
                item = json.loads(text)
        except json.JSONDecodeError as e:
            print(e)
    return item


@app.post("/items", response_model=dict)
def post_item(item: dict):
    text = json.dumps(item)
    with open(TEXT_NAME, 'w', encoding="utf-8") as f:
        f.write(text)
    return item


app.mount("/web", StaticFiles(directory="./web", html=True), name="web")


def main():
    host = "192.168.1.1"
    port = 3001
    url_json = "{\"url\": \"http://" + host + ":" + str(port) + "\"}"
    with open("./web/assets/ip.json", 'w') as f:
        f.write(url_json)
    #
    uvicorn.run(__name__ + ":app", host="192.168.1.1", port=3001, reload=True)


if __name__ == "__main__":

    main()
#
