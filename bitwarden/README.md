# Bitwarden + Chezmoi 密钥管理全套文档与引导说明

本目录汇总了基于 Bitwarden CLI (`bw`) 与 Chezmoi 的配置管理说明及自动化引导脚本。

---

## 文件结构说明

| 文件名 | 类型 | 说明 |
| :--- | :--- | :--- |
| `init.sh` | ⚙️ 引导脚本 | **在新机器上一键运行的引导脚本**，自动检测 CLI、登录解锁并应用配置 |
| `NEW_MACHINE_SETUP.md` | 📄 说明文档 | 换新机器 / 重装系统后的快速恢复与操作指南 |
| `BITWARDEN_GUIDE.md` | 📄 说明文档 | Bitwarden 集成原理、字段映射及架构设计说明 |

---

## ⚡ 新机器一键初始化命令

在任何新机器拉取 Chezmoi 仓库后，直接运行该引导脚本：

```bash
bash ~/chezmoi/bitwarden/init.sh
```

**运行效果**：
1. 自动检测并安装 `bw` CLI。
2. 引导输入账号密码完成登录与会话解锁。
3. 强制从 Bitwarden 动态拉取密钥缓存。
4. 调用 Chezmoi 一键填充 `~/.omp/agent/models.yml` 和 `~/.config/opencode/opencode.json`。

全过程零明文密钥暴露，无泄漏风险。
