# 个人 Dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理个人配置文件（dotfiles）。

> 本仓库**仅存放非敏感配置文件**，不含密码、API Key、Token 等敏感信息。
> 敏感配置文件托管在其他专用仓库或密码管理器中。

## 仓库结构

```
~/chezmoi/                    ← 源目录（git 管理）
├── dot_config/               ← ~/.config/ 下的配置
├── dot_local/bin/            ← ~/.local/bin/ 下的可执行文件
├── dot_omp/agent/            ← ~/.omp/agent/ 下的配置
├── .chezmoi.toml.tmpl        ← chezmoi 配置模板
├── .chezmoiignore            ← 不部署的文件列表
├── ANENTS.md                 ← 智能体指南
└── init.sh                   ← 新机器初始化脚本
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
