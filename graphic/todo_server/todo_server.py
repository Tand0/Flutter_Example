from datetime import datetime, timedelta
from typing import Union

from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi.responses import PlainTextResponse, JSONResponse

from jose import JWTError, jwt
import passlib.hash
from pydantic import BaseModel

import uvicorn
import json

from fastapi.middleware.cors import CORSMiddleware

# to get a string like this run:
# openssl rand -hex 32
SECRET_KEY = "09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8dfff"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


class User(BaseModel):
    username: str
    hashed_password: str


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Union[str, None] = None


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

app = FastAPI()

# for CORS start
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)
# for CORS stop


def get_password_hash(password):
    str = passlib.hash.bcrypt.hash(password, salt=SECRET_KEY[7:29])
    return str


real_db = None


def get_user(username: str):
    global real_db
    if (real_db is None):
        real_db = {}
        real_db["root"] = {"username": "root", "hashed_password": get_password_hash("root")}
    if username in real_db:
        return real_db[username]
    return None


def authenticate_user(username: str, hashed_password: str):
    user = get_user(username)
    if user is None:
        return None
    if hashed_password != user["hashed_password"]:
        return None
    return user


def create_access_token(data: dict, expires_delta: Union[timedelta, None] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except JWTError:
        raise credentials_exception
    user = get_user(username=token_data.username)
    if user is None:
        raise credentials_exception
    return user


@app.get("/", response_class=PlainTextResponse)
def get_top():
    return "<html><body>hello world</body></html>"


@app.post("/token", response_model=Token)
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()):
    hashed_password = get_password_hash(form_data.password)
    user = authenticate_user(form_data.username, hashed_password)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": form_data.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


@app.get("/user", response_model=list)
def get_web_user(_: User = Depends(get_current_user)):
    global real_db
    result = []
    for k, _ in real_db.items():
        result.append(k)
    return result


@app.post("/user")
def post_web_user(username: str, passwd: str, _: User = Depends(get_current_user)):
    global real_db
    real_db[username] = {"username": username, "hashed_password": get_password_hash(passwd)}
    return "OK"


@app.delete("/user")
def delete_web_user(username: str, _: User = Depends(get_current_user)):
    global real_db
    if (username in real_db):
        del real_db[username]
    return "OK"


ITEM = {}


@app.get("/items/{yyyy}/{mm}", response_model=str)
def get_items_user(yyyy: int, mm: int, _: User = Depends(get_current_user)):
    year = str(yyyy)
    month = str(mm)
    if (year in ITEM):
        if (month in ITEM[year]):
            result = json.dumps(ITEM[year][month])
            return result
    return "{}"


@app.post("/items/{yyyy}/{mm}/{dd}", response_class=JSONResponse)
def post_items_user(yyyy: int, mm: int, dd: int, event: str, user: User = Depends(get_current_user)):
    year = str(yyyy)
    month = str(mm)
    day = str(dd)
    print(event)
    if (year not in ITEM):
        ITEM[str(year)] = {}
    if (month not in ITEM[year]):
        ITEM[year][month] = {}
    if (dd not in ITEM[year][month]):
        ITEM[year][month][day] = {}
    if (user["username"] not in ITEM[year][month][day]):
        ITEM[year][month][day][user["username"]] = {}
    ITEM[year][month][day][user["username"]] = event
    return "OK"


def main():
    uvicorn.run(__name__ + ":app", host="192.168.1.1", port=3003, reload=True)


if __name__ == "__main__":
    main()

#
