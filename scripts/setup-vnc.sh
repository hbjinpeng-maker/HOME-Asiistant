#!/usr/bin/env bash
# 安装 Ubuntu 桌面环境 + TightVNC（云服务器远程图形界面）
# 用法: sudo bash scripts/setup-vnc.sh
#
# 说明: 米家账号登录必须在 VNC 桌面内的浏览器完成，这是本项目的核心步骤之一

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "请使用 root 运行: sudo bash $0"
  exit 1
fi

VNC_DISPLAY="${VNC_DISPLAY:-:1}"
VNC_GEOMETRY="${VNC_GEOMETRY:-1920x1080}"

echo "==> 更新软件包..."
apt-get update

echo "==> 安装桌面环境（耗时较长，请耐心等待）..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal ubuntu-desktop

echo "==> 安装 TightVNC..."
apt-get install -y tightvncserver

echo "==> 配置 VNC 启动脚本..."
VNC_USER="${SUDO_USER:-root}"
VNC_HOME=$(eval echo "~$VNC_USER")
XSTARTUP="$VNC_HOME/.vnc/xstartup"

mkdir -p "$VNC_HOME/.vnc"
cat > "$XSTARTUP" << 'EOF'
#!/bin/sh
export XKL_XMODMAP_DISABLE=1
export XDG_CURRENT_DESKTOP="GNOME-Flashback:GNOME"
export XDG_MENU_PREFIX="gnome-flashback-"
gnome-session --session=gnome-flashback-metacity --disable-acceleration-check &
EOF
chmod +x "$XSTARTUP"
chown -R "$VNC_USER:$VNC_USER" "$VNC_HOME/.vnc"

echo ""
echo "=========================================="
echo "  下一步（切换到普通用户 $VNC_USER 执行）:"
echo "=========================================="
echo ""
echo "1. 首次启动 VNC 并设置桌面密码:"
echo "   su - $VNC_USER"
echo "   vncserver $VNC_DISPLAY"
echo ""
echo "2. 重启 VNC 并设置分辨率:"
echo "   vncserver -kill $VNC_DISPLAY"
echo "   vncserver -geometry $VNC_GEOMETRY $VNC_DISPLAY"
echo ""
echo "3. 在云厂商防火墙放行 5901 端口（:1 对应 5901）"
echo ""
echo "4. 本地安装 VNC Viewer，连接: 公网IP:1"
echo ""
echo "5. 在 VNC 桌面内打开浏览器，登录米家账号"
echo "=========================================="
