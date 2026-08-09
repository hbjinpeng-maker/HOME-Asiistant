#!/usr/bin/env bash
# Ubuntu 20.04+ 安装 Docker（使用阿里云镜像源）
# 用法: sudo bash scripts/install-docker.sh

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "请使用 root 运行: sudo bash $0"
  exit 1
fi

echo "==> 更新软件包索引..."
apt-get update

echo "==> 安装依赖..."
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  gnupg \
  lsb-release

echo "==> 添加 Docker GPG 密钥..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "==> 添加 Docker 软件源（阿里云镜像）..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  http://mirrors.aliyun.com/docker-ce/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "==> 将当前用户加入 docker 组..."
if [[ -n "${SUDO_USER:-}" ]]; then
  usermod -aG docker "$SUDO_USER"
  echo "已将用户 $SUDO_USER 加入 docker 组，重新登录后生效"
fi

docker --version
docker compose version

echo "==> Docker 安装完成"
