from fastapi import FastAPI
# from pydantic import BaseModel
import uvicorn

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


def main():
    uvicorn.run(__name__ + ":app", host="192.168.1.1", port=3001, reload=True)


if __name__ == "__main__":
    main()
#
