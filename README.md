# pnos-docker

pnos 系统的 Docker 镜像分发。包含 pnos-runtime（后端）和 pnos-web（前端），一体化运行。

## 当前阶段

MVP 阶段，仅提供系统监控和 WebUI。容器管理和应用商店功能后续迭代。

## 快速开始

```bash
docker compose up -d
```

打开 http://localhost 即可看到 pnos 管理界面。

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `PNOS_PORT` | `80` | 监听端口 |
| `PNOS_DATA_DIR` | `/data` | 应用数据目录 |
| `PNOS_MEDIA_DIR` | `/media` | 媒体目录 |
| `RUST_LOG` | `info` | 日志级别 |

## 卷

| 路径 | 说明 |
|------|------|
| `/data` | 应用数据（持久化） |
| `/media` | 媒体文件 |

## 构建

```bash
docker build -t pandanetos/pnos:latest .
```

多阶段构建：
1. Node 20 构建 pnos-web
2. Rust 1.77 构建 pnos-runtime
3. Debian slim 运行时（约 150MB）

## 健康检查

容器内置健康检查，访问 `http://localhost:80/health` 返回 `ok`。

## 许可证

MIT
