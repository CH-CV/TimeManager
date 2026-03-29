from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Optional

router = APIRouter(prefix="/ai", tags=["ai"])


class Message(BaseModel):
    role: str
    content: str


class ChatRequest(BaseModel):
    messages: List[Message]
    user_id: Optional[str] = None


class ChatResponse(BaseModel):
    message: str
    tasks_created: Optional[List[dict]] = None


class TaskParseRequest(BaseModel):
    text: str


class TaskDecomposeRequest(BaseModel):
    task_id: str
    task_title: str


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    return ChatResponse(
        message="AI response (需要配置 OpenAI API Key)", tasks_created=None
    )


@router.post("/parse-task", response_model=ChatResponse)
async def parse_task(request: TaskParseRequest):
    return ChatResponse(message=f"解析任务: {request.text}", tasks_created=None)


@router.post("/decompose-task", response_model=ChatResponse)
async def decompose_task(request: TaskDecomposeRequest):
    return ChatResponse(
        message=f"分解任务: {request.task_title}",
        tasks_created=[
            {"title": "子任务1", "description": "自动生成"},
            {"title": "子任务2", "description": "自动生成"},
        ],
    )
