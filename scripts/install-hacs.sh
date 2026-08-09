#!/usr/bin/env bash
# 安装 HACS（Home Assistant Community Store）
# 用法: sudo bash scripts/install-hacs.sh
#
# HACS 版本需与 Home Assistant 版本匹配，详见: https://github.com/hacs/integration/releases

set -euo pipefail

HA_CONFIG_DIR="${HA_CONFIG_DIR:-/data/homeassistant}"
HACS_VERSION="${HACS_VERSION:-1.34.0}"
CUSTOM_COMPONENTS="$HA_CONFIG_DIR/custom_components"
HACS_DIR="$CUSTOM_COMPONENTS/hacs"

if [[ ! -d "$HA_CONFIG_DIR" ]]; then
  echo "错误: 配置目录不存在 $HA_CONFIG_DIR"
  echo "请先运行 deploy-ha.sh 并完成首次启动"
  exit 1
fi

echo "==> 创建 custom_components 目录..."
mkdir -p "$HACS_DIR"

echo "==> 下载 HACS v${HACS_VERSION}..."
TMP_ZIP="/tmp/hacs.zip"
curl -fsSL -o "$TMP_ZIP" \
  "https://github.com/hacs/integration/releases/download/${HACS_VERSION}/hacs.zip"

echo "==> 解压到 $HACS_DIR ..."
unzip -oq "$TMP_ZIP" -d "$HACS_DIR"
rm -f "$TMP_ZIP"

echo ""
echo "=========================================="
echo "  HACS 文件已安装"
echo "=========================================="
echo ""
echo "下一步:"
echo "1. 重启 Home Assistant:"
echo "   docker restart homeassistant"
echo ""
echo "2. 浏览器打开 HA -> 设置 -> 设备与服务 -> 添加集成"
echo "3. 搜索 HACS 并完成配置（需要 GitHub 账号授权）"
echo ""
echo "4. 在 HACS 中搜索并安装: Xiaomi Miot Auto"
echo "   仓库: https://github.com/al-one/hass-xiaomi-miot"
echo "=========================================="
