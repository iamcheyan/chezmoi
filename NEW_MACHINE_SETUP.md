# Chezmoi + Bitwarden 多机器配置指南

这份指南说明如何在**换新机器**或**重装系统**后，利用你现在的 Bitwarden + Chezmoi 架构，在 **1 分钟内完成全套 AI 密钥与工具配置恢复**。

---

## 1. 核心架构原理

* **Git 仓库**：只保存 Chezmoi 模板文件（如 `private_models.yml.tmpl` 和 `private_opencode.json.tmpl`），仓库中**绝不含任何密钥**。
* **Bitwarden 云端**：保存你的 4 个加密密钥条目（`API_DEEPSEEK`, `API_EVOMAP`, `API_OPENCODE_GO`, `API_OLLAMA`）。
* **本地应用**：Chezmoi 在运行 `chezmoi apply` 时，自动调用 `bw` 从云端解密抓取 Key，在本地生成 `~/.omp/agent/models.yml` 和 `~/.config/opencode/opencode.json`。

---

## 2. 换新机器后的 3 步恢复流程

在新的 Linux 机器上，只需要在终端中按顺序执行以下 3 步：

### 第一步：安装工具并拉取配置

```bash
# 1. 安装 Bitwarden CLI (若未安装)
npm install -g @bitwarden/cli

# 2. 拉取并初始化你的 Dotfiles 仓库
chezmoi init iamcheyan
```

---

### 第二步：登录并解锁 Bitwarden

运行以下命令完成登录并导出会话变量：

```bash
# 1. 登录 Bitwarden
bw login

# 2. 解锁并导出 Session 变量（输入你的主密码）
export BW_SESSION=$(bw unlock --raw)

# 3. 强制同步一次云端数据
bw sync --session "$BW_SESSION"
```

---

### 第三步：全自动应用配置

直接运行 chezmoi 填充渲染本地配置文件：

```bash
chezmoi apply
```

🎉 **配置完成！** `omp` 和 `opencode` 现已自动注入最新 Key，可直接使用。

---

## 3. 日常维护说明

### A. 如果你在其他设备更新了 Key：
直接在手机/网页版 Bitwarden 中更新对应的密码条目，然后在终端运行：
```bash
export BW_SESSION=$(bw unlock --raw)
bw sync --session "$BW_SESSION"
chezmoi apply
```

### B. 安全保证：
* 不管你在 GitHub 提交什么，所有的密钥数据都在你的 Bitwarden 云端受主密码保护。
* 任何机器拉取你的 Dotfiles 仓库，没有你的 Bitwarden 密码都无法解密或生成任何包含 Key 的配置文件。
