# 03 - Docker 安装

> 目标：在 Ubuntu 上安装 Docker 容器环境。Docker 是运行 Home Assistant 的「沙盒」，让程序互不干扰、随时启停。

## 一、两种安装方式（任选其一）

### 方式 A：使用本项目一键脚本（推荐）

```bash
# 1. 克隆项目（如果还没克隆）
git clone git@github.com:hbjinpeng-maker/HOME-Asiistant.git
cd HOME-Asiistant

# 2. 执行安装脚本
sudo bash scripts/install-docker.sh
```

脚本会自动完成：更新软件源 → 添加 Docker 官方仓库（使用阿里云镜像加速）→ 安装 Docker → 把当前用户加入 docker 组。

### 方式 B：手动安装（适合想了解原理）

```bash
# 更新软件源
sudo apt-get update

# 安装依赖
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# 添加 Docker 官方 GPG 密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 添加 Docker 软件源（阿里云镜像）
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

# 再次更新并安装
sudo apt-get update
sudo apt-get install -y docker-ce

# 将当前用户加入 docker 组（避免每次用 sudo）
sudo usermod -a -G docker $USER
```

## 二、验证安装

```bash
# 查看 Docker 版本
docker --version

# 查看 Docker Compose 版本
docker compose version

# 查看 Docker 运行状态（出现 "active (running)" 即正常）
sudo systemctl status docker
```

## 三、常见问题

| 问题 | 解决 |
|------|------|
| `permission denied` 无法使用 docker | 退出重新登录 SSH（让 docker 组生效），或重新执行 `sudo usermod -a -G docker $USER` |
| 拉取镜像很慢 | 本项目脚本已使用阿里云镜像源；也可配置国内 Docker 镜像加速器 |
| `docker compose` 找不到命令 | 确认安装的是 `docker-ce docker-ce-cli containerd.io docker-compose-plugin`（含 compose 插件） |

## 验证

- [ ] `docker --version` 能输出版本号
- [ ] `docker compose version` 能输出版本号
- [ ] 重新登录 SSH 后 `docker ps` 不报权限错误

下一步 → [04-HomeAssistant部署.md](./04-HomeAssistant部署.md)
