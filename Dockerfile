# PNOS-docker：纯组装镜像，从 pnos-runtime 和 pnos-web 的构建产物中复制
ARG RUNTIME_VERSION=latest
ARG WEB_VERSION=latest
FROM ghcr.io/pandanetos/pnos-runtime:${RUNTIME_VERSION} AS runtime
FROM ghcr.io/pandanetos/pnos-web:${WEB_VERSION} AS web

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates tzdata curl && rm -rf /var/lib/apt/lists/*

# 复制二进制和前端静态文件
COPY --from=runtime /usr/local/bin/pnos-runtime /usr/local/bin/pnos-runtime
COPY --from=web /dist /var/www/pnos-web

# 创建数据目录
RUN mkdir -p /pnos/data /pnos/media

EXPOSE 80

ENV PNOS_PORT=80
ENV PNOS_DATA_DIR=/pnos/data
ENV PNOS_MEDIA_DIR=/pnos/media
ENV RUST_LOG=info

VOLUME ["/pnos"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:80/health || exit 1

ENTRYPOINT ["pnos-runtime"]
