# 02 - Ubuntu 与 VNC 配置

## 一、安装 Ubuntu 20.04

1. 登录云服务商控制台
2. 创建 / 选择实例，镜像选 **Ubuntu 20.04 LTS**
3. 设置 root 密码或 SSH 密钥
4. 记录 **公网 IP 地址**

## 二、开放防火墙端口

在云控制台 → **防火墙 / 安全组** 中添加规则：

| 端口 | 协议 | 说明 |
|------|------|------|
| 5901 | TCP | VNC 远程桌面 |
| 8123 | TCP | Home Assistant |
| 22   | TCP | SSH（可选，建议限制来源 IP） |

## 三、SSH 登录服务器

```bash
ssh root@你的公网IP
```

## 四、一键安装桌面 + VNC

将本项目克隆到服务器后执行：

```bash
git clone git@github.com:hbjinpeng-maker/HOME-Asiistant.git
cd HOME-Asiistant
sudo bash scripts/setup-vnc.sh
```

或手动执行（与原教程一致）：

```bash
sudo -i
apt-get update
apt install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal ubuntu-desktop
apt-get install -y tightvncserver
```

## 五、配置 VNC 启动脚本

编辑 `~/.vnc/xstartup`，**整文件替换**为：

```bash
#!/bin/sh
export XKL_XMODMAP_DISABLE=1
export XDG_CURRENT_DESKTOP="GNOME-Flashback:GNOME"
export XDG_MENU_PREFIX="gnome-flashback-"
gnome-session --session=gnome-flashback-metacity --disable-acceleration-check &
```

保存退出（vi: 按 `ESC` → 输入 `:wq`）。

## 六、启动 VNC 服务

```bash
# 切换到普通用户（不要用 root 跑 VNC）
su - 你的用户名

# 首次启动，设置 VNC 桌面密码
vncserver :1

# 重启并设置分辨率
vncserver -kill :1
vncserver -geometry 1920x1080 :1
```

## 七、本地连接 VNC

1. 下载 [VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/)
2. 地址填写：`公网IP:1`（英文冒号）
3. 输入前面设置的 VNC 密码
4. 成功进入 Ubuntu 桌面

## 验证

- [ ] VNC 能正常连接并看到桌面
- [ ] 桌面内能打开 Firefox / Chromium 浏览器
- [ ] 防火墙 5901 端口已放行

下一步 → [03-Docker安装.md](./03-Docker安装.md)
