# TimeWise Backend

FastAPI 后端服务

## 技术栈

- **框架**: FastAPI
- **数据库**: SQLAlchemy + SQLite
- **认证**: JWT (python-jose)
- **AI**: OpenAI API

## 快速开始

### 1. 创建虚拟环境

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
```

### 2. 安装依赖

```bash
pip install -r requirements.txt
```

### 3. 运行服务

```bash
uvicorn app.main:app --reload
```

### 4. 访问 API 文档

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API 端点

| 端点 | 方法 | 说明 |
|------|------|------|
| `/api/v1/tasks` | GET | 获取任务列表 |
| `/api/v1/tasks` | POST | 创建任务 |
| `/api/v1/tasks/{id}` | GET | 获取任务详情 |
| `/api/v1/tasks/{id}` | PUT | 更新任务 |
| `/api/v1/tasks/{id}` | DELETE | 删除任务 |
| `/api/v1/auth/register` | POST | 用户注册 |
| `/api/v1/auth/login` | POST | 用户登录 |
| `/api/v1/ai/chat` | POST | AI 对话 |
| `/api/v1/ai/parse-task` | POST | 自然语言解析任务 |
| `/api/v1/ai/decompose-task` | POST | 任务智能分解 |

## 环境变量

创建 `.env` 文件：

```env
DATABASE_URL=sqlite+aiosqlite:///./timewise.db
SECRET_KEY=your-secret-key
OPENAI_API_KEY=your-openai-api-key
```
