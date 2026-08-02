# 个人 Dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理个人配置文件（dotfiles）。

> 本仓库**仅存放非敏感配置文件**，不含密码、API Key、Token 等敏感信息。
> 敏感配置文件托管在其他专用仓库或密码管理器中。

## 仓库结构

```
~/chezmoi/                    ← 源目录（git 管理）
├── dot_config/               ← ~/.config/ 下的配置
├── dot_local/bin/            ← ~/.local/bin/ 下的可执行文件
├── dot_omp/private_agent/  ← ~/.omp/agent/ 下的配置（0700 安全目录）
├── .chezmoi.toml.tmpl        ← chezmoi 配置模板
├── .chezmoiignore            ← 不部署的文件列表
├── ANENTS.md                 ← 智能体指南
└── init.sh                   ← 新机器初始化脚本
```

## omp 模型配置（models.yml）

`~/.omp/agent/models.yml`（chezmoi 托管，`dot_omp/private_agent/private_models.yml`，0600）导入 opencode 的全部自定义 provider：

- `deepseek`（DeepSeek 直连）、`evomap`（EvoMap 网关，含 vision 模型 `evomap-kimi-k2.6`）、`opencode-go`、`ollama`（Ollama Cloud）
- `apiKey` 一律写**环境变量名**（如 `EVOMAP_API_KEY`），实际值放在 `~/.omp/agent/.env`（0600，**不**进 chezmoi，已在 `.chezmoiignore` 排除）
- omp 启动时自动加载 `~/.omp/agent/.env`；已存在的 shell 环境变量优先于 .env

新机器配置步骤：

```bash
chezmoi init && chezmoi apply
# 然后手动设置密钥（不在仓库中）
omp auth login                # openai-codex OAuth
# 在 shell profile 或 ~/.omp/agent/.env 中设置：
#   OLLAMA_CLOUD_API_KEY=...   （ollama-cloud 模型）
#   EVOMAP_API_KEY=...         （evomap 网关）
#   DEEPSEEK_API_KEY=... OPENCODE_GO_API_KEY=... OLLAMA_API_KEY=...
```

## 快速开始

```bash
# 新机器安装
bash <(curl -fsSL https://raw.githubusercontent.com/iamcheyan/chezmoi/main/init.sh)

# 日常使用
cd ~/chezmoi
chezmoi add ~/.config/kitty/kitty.conf    # 添加新文件
chezmoi edit ~/.config/kitty/kitty.conf   # 编辑已有文件
chezmoi diff                               # 查看更改
chezmoi apply                              # 应用配置
```

## 命名映射

| 前缀 | 效果 | 示例 |
|---|---|---|
| `dot_` | → `.` | `dot_zshrc` → `~/.zshrc` |
| `executable_` | 0755 权限 | `executable_my.sh` → `~/my.sh` |
| `literal_` | 原样保留 | `literal_dot_foo` → `~/dot_foo` |

本仓库禁止使用 `private_` 和 `encrypted_` 前缀。

详见 [ANENTS.md](./ANENTS.md)（智能体指南，包含完整用法和规则）。
