from fastapi import APIRouter, HTTPException, Depends
from typing import List, Optional
from datetime import datetime
from pydantic import BaseModel

router = APIRouter(prefix="/tasks", tags=["tasks"])


class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    deadline: Optional[datetime] = None
    priority: str = "medium"
    category: Optional[str] = None
    estimated_duration: Optional[int] = None
    repeat: Optional[str] = None


class TaskCreate(TaskBase):
    pass


class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    deadline: Optional[datetime] = None
    priority: Optional[str] = None
    category: Optional[str] = None
    estimated_duration: Optional[int] = None
    repeat: Optional[str] = None
    completed: Optional[bool] = None


class TaskResponse(TaskBase):
    id: str
    completed: bool = False
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


tasks_db = {}


@router.post("/", response_model=TaskResponse)
async def create_task(task: TaskCreate):
    task_id = f"task_{len(tasks_db) + 1}"
    now = datetime.now()
    task_data = {
        "id": task_id,
        **task.model_dump(),
        "completed": False,
        "created_at": now,
        "updated_at": now,
    }
    tasks_db[task_id] = task_data
    return task_data


@router.get("/", response_model=List[TaskResponse])
async def get_tasks(completed: Optional[bool] = None):
    tasks = list(tasks_db.values())
    if completed is not None:
        tasks = [t for t in tasks if t["completed"] == completed]
    return tasks


@router.get("/{task_id}", response_model=TaskResponse)
async def get_task(task_id: str):
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    return tasks_db[task_id]


@router.put("/{task_id}", response_model=TaskResponse)
async def update_task(task_id: str, task_update: TaskUpdate):
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    task_data = tasks_db[task_id]
    update_data = task_update.model_dump(exclude_unset=True)
    task_data.update(update_data)
    task_data["updated_at"] = datetime.now()
    tasks_db[task_id] = task_data
    return task_data


@router.delete("/{task_id}")
async def delete_task(task_id: str):
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    del tasks_db[task_id]
    return {"message": "Task deleted"}
