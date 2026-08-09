# 04 - Home Assistant 部署

> 目标：使用 Docker 运行 Home Assistant 主程序，让你的智能家居中枢跑起来。

## 一、一键部署（推荐）

```bash
# 在项目根目录执行
sudo bash scripts/deploy-ha.sh
```

脚本会自动：
1. 创建 HA 配置目录 `/data/homeassistant`
2. 生成 `docker/.env` 环境变量文件
3. 拉取 Home Assistant 镜像并后台启动

## 二、手动部署（Docker Compose 方式）

```bash
cd docker
cp .env.example .env          # 复制环境变量模板
vim .env                       # 按需修改（时区、配置目录、镜像版本）
docker compose up -d           # 拉取镜像并启动
```

**docker-compose.yml 说明**（已包含在项目 `docker/` 目录）：

```yaml
services:
  homeassistant:
    container_name: homeassistant
    image: ghcr.io/home-assistant/home-assistant:stable   # 固定稳定版镜像
    restart: unless-stopped      # 异常退出自动重启
    privileged: true             # 允许访问硬件设备（USB 网关等）
    network_mode: host           # 使用宿主机网络，米家局域网发现依赖此配置
    environment:
      - TZ=Asia/Shanghai         # 时区
    volumes:
      - /data/homeassistant:/config   # 配置持久化
```

> 如果不使用 Compose，也可以直接运行原始命令：
>
> ```bash
> docker run -d \
>   --name homeassistant \
>   --privileged \
>   --restart=unless-stopped \
>   -e TZ=Asia/Shanghai \
>   -v /data/homeassistant:/config \
>   --network=host \
>   homeassistant/home-assistant
> ```

## 三、初始化设置（重要）

1. 浏览器访问 **`http://服务器公网IP:8123`**
2. 完成首次初始化向导：
   - 设置管理员账号和密码（**务必记好**）
   - 设置家的大致位置（用于日出日落等自动化）
   - 时区选择 **上海**（Asia/Shanghai）
3. 等待设备发现完成，进入主界面

## 四、常用命令

```bash
# 查看运行状态
docker ps

# 查看 HA 日志（排错时用，Ctrl+C 退出）
docker logs -f homeassistant

# 重启 HA
docker restart homeassistant

# 停止 HA
docker stop homeassistant
```

## 五、常见问题

| 问题 | 解决 |
|------|------|
| 8123 端口打不开 | 检查云防火墙是否放行 8123；`docker ps` 确认容器在运行 |
| 容器反复重启 | `docker logs homeassistant` 看日志，常见是配置目录权限问题 |
| 重启后配置丢失 | 确认挂载了 `/data/homeassistant:/config` 卷 |

## 验证

- [ ] `docker ps` 能看到 `homeassistant` 容器状态为 `Up`
- [ ] 浏览器能打开 HA 登录界面
- [ ] 管理员账号创建成功

下一步 → [05-HACS与米家接入.md](./05-HACS与米家接入.md)
