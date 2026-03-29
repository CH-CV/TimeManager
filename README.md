# TimeWise - 时间管理 App

> 一款以 AI 智能为核心的时间管理应用

## 项目简介

TimeWise 是一款帮助用户高效管理时间、完成任务的时间管理应用，核心差异化是 AI 智能功能，包括：
- 自然语言创建任务
- AI 智能安排日程
- 记忆用户习惯，主动提醒

## 技术栈

### 前端
- **框架**：Flutter
- **语言**：Dart
- **状态管理**：Riverpod
- **本地存储**：Hive
- **路由**：go_router

### 后端
- **框架**：FastAPI
- **语言**：Python
- **数据库**：SQLite
- **认证**：JWT
- **AI**：OpenAI API

## 项目结构

```
TimeWise/
├── frontend/          # Flutter App
│   ├── lib/
│   ├── pubspec.yaml
│   └── ...
├── backend/           # FastAPI 后端服务
│   ├── app/
│   ├── requirements.txt
│   └── ...
└── README.md
```

## 起步

### 前端

```bash
cd frontend
flutter pub get
flutter run
```

### 后端

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Linux/macOS
# 或
venv\Scripts\activate     # Windows

pip install -r requirements.txt
uvicorn app.main:app --reload
```

## API 文档

后端运行后访问：http://localhost:8000/docs

## 功能模块

- [ ] 任务管理（基础CRUD完成，分类/重复UI完成待完善逻辑）
- [ ] 番茄钟（计时完成，无通知）
- [ ] 时间轴（仅显示有截止时间的任务）
- [ ] 数据统计（空白）
- [ ] AI 助手（空白）
- [ ] 登录认证（后续开发）

## 开源协议

本项目采用 [MIT License](LICENSE) 开源。

## 开发计划

详见 [开发计划.md](./开发计划.md)

## 许可证

待定
