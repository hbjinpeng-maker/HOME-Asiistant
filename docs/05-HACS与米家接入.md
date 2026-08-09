# 05 - HACS 与米家设备接入

> 目标：安装 HACS 社区插件商店，并接入你的米家智能设备。这是「让 HA 真正用起来」的关键一步。

## 一、安装 HACS（Home Assistant Community Store）

HACS 是 HA 的「应用商店」，里面有上千款免费插件。

### 方式 A：一键脚本（推荐）

```bash
sudo bash scripts/install-hacs.sh
```

### 方式 B：手动安装

```bash
# 1. 进入 HA 配置目录创建插件目录
mkdir -p /data/homeassistant/custom_components/hacs

# 2. 下载 HACS（版本需与 HA 匹配）
wget -O /tmp/hacs.zip \
  https://github.com/hacs/integration/releases/download/1.34.0/hacs.zip

# 3. 解压到插件目录
unzip -oq /tmp/hacs.zip -d /data/homeassistant/custom_components/hacs

# 4. 重启 HA 让插件生效
docker restart homeassistant
```

## 二、配置 HACS

1. 浏览器打开 **HA 网页** → 设置（左下角齿轮）→ **设备与服务** → 右下角 **添加集成**
2. 搜索 **HACS** 并点击
3. 按提示授权（需要 GitHub 账号，免费注册一个）
4. 完成后左侧栏会出现 **HACS** 图标

## 三、安装米家插件（Xiaomi MIoT Auto）

在 HACS 中搜索并安装 **Xiaomi MIoT Auto**（仓库: [al-one/hass-xiaomi-miot](https://github.com/al-one/hass-xiaomi-miot)），这是目前兼容米家设备最全的社区集成。

安装后重启 HA，然后：

1. 打开 HA → 设置 → 设备与服务 → **添加集成**
2. 搜索 **Xiaomi MIoT Auto**
3. 选择登录方式：**账号密码登录**（推荐）或 **集成 token**
4. 输入你的**米家账号密码** → 授权

## ⚠️ 四、关键步骤：在 VNC 桌面里登录米家（必看！）

**这是整个教程最容易踩坑的地方：**

> 🚨 **米家登录时，浏览器必须和 Home Assistant 在同一网络环境**（云服务器）。因为小米的二次授权验证要求浏览器与服务器同网络，直接在你自己电脑上登录会失败。

**正确操作：**

1. 本地打开 **VNC Viewer**，连接云服务器桌面（`公网IP:1`）
2. 在 VNC 桌面的 **Ubuntu 浏览器**（Firefox / Chromium）中打开 **`http://localhost:8123`** ← 注意是 localhost，不是公网 IP
3. 在桌面浏览器里登录 HA 并完成米家授权
4. 授权通过后，HA 会自动拉取你账号下的所有米家设备

## 五、验证设备接入

- [ ] HACS 显示已安装且能打开商店
- [ ] 米家集成添加成功
- [ ] HA 概览页能看到你的智能设备（插座、灯、传感器等）
- [ ] 尝试开关一个设备，状态实时更新

## 六、常见问题

| 问题 | 解决 |
|------|------|
| 搜不到 HACS | HACS 版本与 HA 不匹配，用脚本安装的版本最稳 |
| 米家授权失败 | 确认在 VNC 桌面浏览器操作；清缓存重试 |
| 部分设备显示离线 | 米家网关需与设备在同一局域网；云服务器场景下部分 Zigbee 设备受限 |
| HACS 商店加载慢 | 国内网络访问 GitHub 较慢，可稍等或配置 GitHub 加速 |

---

🎉 **恭喜！到这里你的云服务器智能家居中枢已经搭建完成！** 接下来可以：
- 创建自动化场景（设置 → 自动化）
- 安装更多 HACS 插件（如巴法云、小爱同学 TTS 等）
- 配置手机 App（Home Assistant Companion）
