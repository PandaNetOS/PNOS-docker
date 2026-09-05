# ===== Stage 1: 构建 pnos-web =====
FROM node:20-bookworm-slim AS web-builder
WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/PandaNetOS/pnos-web.git .
RUN npm ci
RUN npm run build

# ===== Stage 2: 构建 pnos-runtime =====
FROM rust:1.77-bookworm AS runtime-builder
WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/PandaNetOS/pnos-spec.git
RUN git clone https://github.com/PandaNetOS/pnos-runtime.git
WORKDIR /build/pnos-runtime
RUN cargo build --release

# ===== Stage 3: 运行时 =====
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates tzdata curl && rm -rf /var/lib/apt/lists/*

# 复制二进制和前端静态文件
COPY --from=runtime-builder /build/pnos-runtime/target/release/pnos-runtime /usr/local/bin/pnos-runtime
COPY --from=web-builder /build/dist /var/www/pnos-web

# 创建数据目录
RUN mkdir -p /data /media

EXPOSE 80

ENV PNOS_PORT=80
ENV PNOS_DATA_DIR=/data
ENV PNOS_MEDIA_DIR=/media
ENV RUST_LOG=info

VOLUME ["/data", "/media"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:80/health || exit 1

ENTRYPOINT ["pnos-runtime"]
