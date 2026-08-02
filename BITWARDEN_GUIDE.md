# Bitwarden + Chezmoi 密钥管理指南

本文档介绍如何使用免费的 **Bitwarden CLI (`bw`)** 配合 **Chezmoi** 管理 API Key，实现本地零明文存储和多设备无缝同步。

---

## 1. 准备工作（注册与初始化）

### 第一步：注册 Bitwarden 账号
如果你还没有 Bitwarden 账号：
1. 访问 [https://bitwarden.com](https://bitwarden.com) 注册免费账号（或下载手机/桌面 App）。
2. 在 Bitwarden 中创建一个名为 `api-keys` 的 Secure Note（安全笔记），并在其中添加你的 API Key。

例如创建以下名称的 Secure Note 或条目：
- `API_DEEPSEEK`
- `API_EVOMAP`
- `API_OPENCODE_GO`
- `API_OLLAMA`

---

## 2. 命令行登录 Bitwarden

CLI 工具 `bw` 已经安装完成（通过 `npm` 全局安装）。在终端中执行以下步骤登录：

```bash
# 1. 登录 Bitwarden 账号
bw login

# 2. 解锁 Vault (按提示输入主密码)
bw unlock
```

解锁后终端会输出类似于下面的环境变量（Session Key）：
```bash
export BW_SESSION="xxxxxxx..."
```
把这条 `export BW_SESSION="..."` 复制在当前终端中运行即可。

---

## 3. Chezmoi 模板切换方法

当你在 Bitwarden 中创建好密钥条目后，可以将 Chezmoi 模板修改为直接从 Bitwarden 提取密钥。

### 模板写法语义（示例）：
在 Chezmoi 模板中，将从文件读取改为调用 `bitwarden` 函数：

```yaml
# 在 ~/chezmoi/dot_omp/private_agent/private_models.yml.tmpl 中
providers:
  deepseek:
    apiKey: {{ (bitwarden "item" "API_DEEPSEEK").notes }}
  evomap:
    apiKey: {{ (bitwarden "item" "API_EVOMAP").notes }}
  opencode-go:
    apiKey: {{ (bitwarden "item" "API_OPENCODE_GO").notes }}
  ollama:
    apiKey: {{ (bitwarden "item" "API_OLLAMA").notes }}
```

### 渲染生成配置：
只要在登录解锁了 `bw` 的终端中运行：
```bash
chezmoi apply
```
Chezmoi 就会自动调取 Bitwarden 云端的密钥，在本地生成 `models.yml` 和 `opencode.json`。

---

## 4. 方案对比与当前状态

* **当前状态**：目前系统采用 **`~/.env` + Chezmoi 模板**，已实现本地平稳运行，密钥不会提交进 Git。
* **无缝升级**：随时可以按照本指南注册 Bitwarden 并登录，随后将 Chezmoi 模板切换为 `bitwarden` 提取方式，实现彻底脱离本地 `.env` 文件的最高安全体验。
