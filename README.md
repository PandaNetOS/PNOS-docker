# PNOS-docker

pnos 系统的 Docker 镜像分发。包含 pnos-runtime（后端）和 pnos-web（前端），一体化运行。

## 当前阶段

MVP 阶段，仅提供系统监控和 WebUI。容器管理和应用商店功能后续迭代。

## 快速开始

```bash
docker compose up -d
```

打开 http://localhost 即可看到 pnos 管理界面。

## 镜像地址

CI 自动构建并推送到三个镜像仓库：

| 仓库 | 地址 |
|------|------|
| Docker Hub | `docker.io/<namespace>/PNOS-docker` |
| GitHub Container Registry | `ghcr.io/pandanetos/PNOS-docker` |
| 阿里云 ACR | `<registry>/<namespace>/PNOS-docker` |

支持架构：`linux/amd64`、`linux/arm64`

标签策略：
- `latest` — main 分支最新构建
- `main` — main 分支
- `v1.0.0` — Git tag
- `abc1234` — Git commit short sha

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

### 本地构建

```bash
docker build -t PNOS-docker:latest .
```

### CI 构建

推送到 main 分支或打 tag 自动触发 GitHub Actions 构建。

多阶段构建：
1. Node 20 构建 pnos-web
2. Rust 1.77 构建 pnos-runtime
3. Debian slim 运行时（约 150MB）

## GitHub Secrets 配置

在仓库 Settings → Secrets and variables → Actions 中配置以下 Secrets：

### Docker Hub

| Secret | 说明 |
|--------|------|
| `DOCKERHUB_USERNAME` | Docker Hub 用户名 |
| `DOCKERHUB_TOKEN` | Docker Hub Access Token |
| `DOCKERHUB_NAMESPACE` | 命名空间（用户名或组织名） |

### 阿里云 ACR

| Secret | 说明 | 示例 |
|--------|------|------|
| `ACR_REGISTRY` | 注册表地址 | `registry.cn-hangzhou.aliyuncs.com` |
| `ACR_USERNAME` | 用户名 | 阿里云账号全名 |
| `ACR_PASSWORD` | 密码 | 固定密码 |
| `ACR_NAMESPACE` | 命名空间 | 你的 ACR 命名空间 |

### GHCR

无需配置，使用自动生成的 `GITHUB_TOKEN`。

## 健康检查

容器内置健康检查，访问 `http://localhost:80/health` 返回 `ok`。

## 许可证

MIT
