#!/usr/bin/env bash
# 部署 Home Assistant（Docker Compose）
# 用法: sudo bash scripts/deploy-ha.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
COMPOSE_DIR="$PROJECT_DIR/docker"
HA_CONFIG_DIR="${HA_CONFIG_DIR:-/data/homeassistant}"

echo "==> 创建配置目录: $HA_CONFIG_DIR"
mkdir -p "$HA_CONFIG_DIR"

if [[ ! -f "$COMPOSE_DIR/.env" ]]; then
  echo "==> 复制环境变量模板..."
  cp "$COMPOSE_DIR/.env.example" "$COMPOSE_DIR/.env"
  sed -i "s|HA_CONFIG_DIR=.*|HA_CONFIG_DIR=$HA_CONFIG_DIR|" "$COMPOSE_DIR/.env" 2>/dev/null || true
fi

echo "==> 拉取并启动 Home Assistant..."
cd "$COMPOSE_DIR"
docker compose pull
docker compose up -d

echo ""
echo "=========================================="
echo "  Home Assistant 部署完成"
echo "=========================================="
echo ""
echo "访问地址: http://<服务器公网IP>:8123"
echo "首次访问需完成 onboarding 向导（创建账号、设置位置等）"
echo ""
echo "查看日志: docker logs -f homeassistant"
echo "重启服务: cd $COMPOSE_DIR && docker compose restart"
echo "=========================================="
