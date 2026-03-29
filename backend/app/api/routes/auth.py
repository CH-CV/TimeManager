from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import Optional

router = APIRouter(prefix="/auth", tags=["auth"])


class LoginRequest(BaseModel):
    phone: Optional[str] = None
    email: Optional[str] = None
    password: str


class RegisterRequest(BaseModel):
    phone: Optional[str] = None
    email: Optional[str] = None
    password: str
    username: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


users_db = {}


@router.post("/register", response_model=TokenResponse)
async def register(request: RegisterRequest):
    user_id = f"user_{len(users_db) + 1}"
    users_db[user_id] = {
        "id": user_id,
        "username": request.username,
        "phone": request.phone,
        "email": request.email,
    }
    return TokenResponse(access_token=f"token_{user_id}")


@router.post("/login", response_model=TokenResponse)
async def login(request: LoginRequest):
    return TokenResponse(access_token="mock_token")
