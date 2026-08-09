# 🏠 HOME-Asiistant

> 小白也能看懂的 **云服务器搭建 Home Assistant 智能家居中枢** 完整教程 + 一键部署脚本

---

## 一、这个项目是什么？

### 1.1 Home Assistant 是什么？

**Home Assistant（简称 HA）** 是一个开源的智能家居控制中心，你可以把它理解成智能家居的 **「总遥控器」**：

- 🔌 把 **米家、涂鸦、HomeKit** 等不同品牌的智能设备，统一到一个界面里管理
- ⚡ 创建自动化场景，比如「回家自动开灯」「出门自动关空调」
- 📱 在 **网页** 或 **手机 App** 上随时查看和控制家里所有设备
- 🧠 搭配 HACS 社区插件，功能可以无限扩展

### 1.2 为什么用云服务器？

| 方式 | 优点 | 缺点 |
|------|------|------|
| 家里的电脑 / 树莓派 | 免费、本地可控 | 要 24 小时开机，断电断网就瘫痪 |
| ☁️ 云服务器（本项目） | **7×24 小时在线**、远程访问方便、不用折腾本地硬件 | 需要一点部署步骤（本项目帮你解决） |

### 1.3 项目的整体架构

```
┌─────────────────────────────────────────────────────┐
│                   云服务器 (Ubuntu)                   │
│                                                     │
│   ┌──────────┐    ┌──────────┐    ┌──────────────┐  │
│   │  Docker   │───▶│Home Assist│───▶│   HACS 插件   │  │
│   │  容器环境  │    │   ant     │    │ (米家 MIoT)   │  │
│   └──────────┘    └──────────┘    └──────────────┘  │
│         ▲                ▲                          │
│   ┌─────┴──────┐  ┌──────┴─────┐                   │
│   │ VNC 远程桌面 │  │  Web 界面   │                   │
│   │  (端口5901) │  │ (端口8123) │                   │
│   └────────────┘  └────────────┘                   │
│                                                     │
└─────────────────────────────────────────────────────┘
        ▲                              ▲
        │  VNC Viewer 连接             │  浏览器访问
        │  (用于登录米家账号)           │  http://服务器IP:8123
```

## 二、小白问答（先回答你心里的疑问）

<details>
<summary><b>❓ 我完全不懂 Linux，能跟着做吗？</b></summary>
<p>能！本项目把每一步都拆解成了「复制 → 粘贴 → 回车」，全程 99% 是复制命令，只需要按文档执行即可。</p>
</details>

<details>
<summary><b>❓ 为什么要装 VNC 桌面？</b></summary>
<p>因为登录米家账号时，<b>浏览器必须和 Home Assistant 在同一网络环境</b>（米家的二次授权验证机制）。云服务器上是没有显示器的，所以需要 VNC 把服务器的桌面「搬到」你电脑上，然后在桌面里用浏览器登录米家。</p>
</details>

<details>
<summary><b>❓ 需要花钱买什么？</b></summary>
<p>只需要一台<b>轻量级云服务器</b>（阿里云 / 腾讯云 / 华为云都有，选 2 核 2G 以上的就行，新用户通常有几十块的优惠活动）。其他所有软件都是免费的。</p>
</details>

<details>
<summary><b>❓ 搭建要多久？</b></summary>
<p>按文档一步步来，大概 <b>1～2 小时</b> 能全部搞定。</p>
</details>

## 三、需要准备什么？

| 项目 | 说明 |
|------|------|
| ☁️ 轻量级云服务器 | 阿里云 / 腾讯云 / 华为云等，建议 2核2G 以上 |
| 🐧 Ubuntu 20.04 系统 | 在云服务器控制台选择这个镜像 |
| 📱 米家账号 | 已经绑定智能设备的小米 / 米家账号 |
| 💻 VNC Viewer | 本地电脑安装，用于远程连接云服务器桌面 |
| 😤 耐心 | 步骤有点多，但按文档来一定能完成 |

## 四、项目结构

```
HOME-Asiistant/
├── README.md                  ← 就是这个文件，从这开始读
├── docs/                      ← 📖 图文教程（小白按顺序阅读）
│   ├── 01-准备阶段.md           ← 准备什么？端口是什么？
│   ├── 02-Ubuntu与VNC配置.md    ← 装系统 + 桌面 + VNC
│   ├── 03-Docker安装.md         ← 安装容器环境
│   ├── 04-HomeAssistant部署.md  ← 部署 HA 主程序
│   └── 05-HACS与米家接入.md      ← 装插件 + 绑定米家设备
├── scripts/                   ← ⚙️ 一键部署脚本
│   ├── setup-vnc.sh            ← 安装桌面 + VNC
│   ├── install-docker.sh       ← 安装 Docker
│   ├── deploy-ha.sh            ← 部署 Home Assistant
│   └── install-hacs.sh         ← 安装 HACS 插件
├── docker/                    ← 🐳 Docker 配置文件
│   ├── docker-compose.yml      ← 容器编排文件
│   └── .env.example            ← 环境变量模板
└── config/                    ← 📄 HA 配置
    └── configuration.yaml.example
```

## 五、快速开始（只需 5 步）

> 完整图文步骤请看 [docs 目录](./docs/)，这里是电梯版。

| 步骤 | 做什么 | 命令 / 操作 |
|------|--------|------------|
| 1️⃣ | 登录云服务器 | `ssh root@你的公网IP` |
| 2️⃣ | 安装桌面 + VNC | `sudo bash scripts/setup-vnc.sh` |
| 3️⃣ | 安装 Docker | `sudo bash scripts/install-docker.sh` |
| 4️⃣ | 部署 Home Assistant | `sudo bash scripts/deploy-ha.sh` |
| 5️⃣ | 安装 HACS + 接入米家 | `sudo bash scripts/install-hacs.sh`，然后在 VNC 桌面浏览器登录米家 |

## 六、端口速查

| 端口 | 用途 | 需要在防火墙放行吗？ |
|------|------|-------------------|
| 5901 | VNC 远程桌面 | ✅ 需要 |
| 8123 | Home Assistant Web 界面 | ✅ 需要 |
| 22 | SSH 远程命令行 | ✅ 默认放行（建议限制来源 IP） |

## 七、成果预览

搭建完成后，你将拥有：

- 🌐 **Home Assistant 网页控制台**（`http://服务器IP:8123`）
- 🏠 **全屋米家设备统一管理**（灯光、插座、传感器、空调……）
- ⚡ **自动化场景**（回家自动开灯、定时开关、环境联动）
- 🧩 **HACS 社区商店**（上千款免费插件随意装）

## 八、常见问题（避坑）

1. **HACS 装完搜不到？** → HACS 版本要和 Home Assistant 版本匹配，本项目脚本已锁定兼容版本
2. **米家登录失败？** → 一定要在 **VNC 桌面内** 的浏览器登录，不要在本地浏览器登
3. **访问不了 8123 端口？** → 检查云厂商防火墙是否放行，以及 HA 是否成功启动（`docker logs homeassistant`）
4. **更多问题？** → 先搜 GitHub Issues，再谷歌（百度很多答案搜不到）

## 九、技术栈与许可

- **Home Assistant**: [home-assistant.io](https://www.home-assistant.io/)
- **HACS**: [hacs/integration](https://github.com/hacs/integration)
- **Xiaomi MIoT Auto**: [al-one/hass-xiaomi-miot](https://github.com/al-one/hass-xiaomi-miot)
- **Docker**: [docker.com](https://www.docker.com/)
- 本项目遵循 [MIT License](./LICENSE)

---

> ⭐ 如果这个项目帮到了你，欢迎 Star！有疑问可以提 [Issue](https://github.com/hbjinpeng-maker/HOME-Asiistant/issues)。
