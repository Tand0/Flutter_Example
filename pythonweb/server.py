from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
import uvicorn
from fastapi.staticfiles import StaticFiles

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)


app.mount("/web", StaticFiles(directory="./web", html=True), name="web")


def main():
    uvicorn.run(__name__ + ":app", host="192.168.1.1", port=3001, reload=True)


if __name__ == "__main__":

    main()
#
