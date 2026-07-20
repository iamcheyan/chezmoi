# Chezmoi Dotfiles

本仓库使用 [chezmoi](https://www.chezmoi.io/) 管理个人 dotfiles（配置文件）。

## 核心政策

**本仓库仅存放非敏感的个人配置文件（dotfiles）。绝不存储任何敏感信息。**

| 可存放 | 禁止存放 |
|---|---|
| `.zshrc`、`.gitconfig`、alises、主题配置 | API Key、密码、Token、SSH 密钥 |
| 编辑器/终端/TUI 配置 | `.env`、`credentials`、`*.secret` |
| 脚本、工具配置 | 任何包含密码/密钥的文件 |
| 公开可用的模型/工具配置 | 上述文件的加密版本 |

即使 chezmoi 支持 age 加密，**也禁止使用**。本仓库不托管任何敏感数据，不需要加密功能。敏感文件请托管在其他专用仓库或密码管理器中。

`.gitignore` 已配置拦截常见的敏感文件模式（`.env`、`*.secret`、`age.key` 等）——但不依赖此机制，核心是靠人的意识。

## 目录结构

```
~/chezmoi/                    ← 源目录（git 仓库）
├── ANENTS.md                 ← 本文件：智能体指南
├── README.md                 ← 人类可读的说明
├── .chezmoi.toml.tmpl        ← chezmoi 配置模板
├── .chezmoiignore             ← 不部署到目标目录的文件列表
├── .gitignore                ← git 忽略规则
├── .githooks/                ← git hooks
│   ├── pre-commit            ← 提交前检查
│   └── pre-push              ← 推送前检查
├── dot_config/               ← ~/.config/ 下的配置
│   ├── aliases.conf
│   ├── scripts/
│   ├── dotfiles/             ← ~/.config/dotfiles/（工具指南等文档）
│   ├── foot/
│   │   └── foot.ini
│   ├── kitty/
│   │   ├── kitty.conf
│   │   └── current-theme.conf
│   ├── alacritty/
│   │   └── alacritty.toml
│   ├── ghostty/
│   │   └── config
│   ├── fcitx5/
│   │   ├── config
│   │   ├── profile
│   │   └── conf/
│   ├── nvim/
│   │   └── colors/
│   │       └── oceanblack.vim
│   ├── voice_bindings.txt
│   ├── voice_bindings.txt.save
│   ├── symlink_omd.tmpl      ← OMD repo root symlink
│   └── symlink_quickshell.tmpl
├── init.sh                   ← 新机器初始化脚本
└── config                    ← 占位/空文件
```

## chezmoi 映射规则

chezmoi 通过**源目录中的文件名前缀**自动映射到目标目录（`~`），无需逐个配置路径。

### 常用前缀

| 前缀 | 效果 | 示例 |
|---|---|---|
| `dot_` | 替换为 `.` | `dot_zshrc` → `~/.zshrc` |
| `executable_` | 权限 0755 | `executable_my.sh` → `~/my.sh` |
| `literal_` | 原样保留 | `literal_dot_foo` → `~/dot_foo` |
| `symlink_` | 创建软链接 | `symlink_dot_zshrc` → `~/.zshrc` |
| `create_` | 创建空目录 | `create_dot_cache` → `~/.cache/` |

### 不用（禁用）的前缀

| 前缀 | 原因 |
|---|---|
| `private_` | 权限 0600，但本仓库不存放敏感文件 |
| `encrypted_` | age 加密功能，本仓库禁用 |
| `modify_` | 本仓库不使用 |

### 路径映射示例

```
源目录                           → 目标目录
~/chezmoi/
├── dot_config/
│   └── kitty/
│       └── kitty.conf        → ~/.config/kitty/kitty.conf
├── dot_local/
│   └── bin/
│       └── executable_my.sh  → ~/.local/bin/my.sh（0755）
├── dot_omp/
│   └── agent/
│       └── config.yml        → ~/.omp/agent/config.yml
└── dot_zshrc                 → ~/.zshrc
```

### 特殊文件

| 源路径 | 作用 |
|---|---|
| `.chezmoi.toml.tmpl` | 配置模板，`chezmoi init` 时生成 `~/.config/chezmoi/chezmoi.toml` |
| `.chezmoiignore` | 告诉 chezmoi 哪些源文件不部署到目标目录 |
| `.chezmoiroot` | 定义子模块根目录（本仓库未使用） |

## 日常工作流

### 1. 添加新文件到 chezmoi 管理

```bash
# 已有文件（在 ~/ 下）：
chezmoi add ~/.config/kitty/kitty.conf

# 从零创建：
chezmoi edit ~/.config/kitty/kitty.conf
```

chezmoi 会自动复制到源目录并加上正确前缀。

### 2. 编辑已有文件

```bash
# 方式一：chezmoi edit（推荐）
chezmoi edit ~/.config/kitty/kitty.conf

# 方式二：直接在源目录编辑
vim ~/chezmoi/dot_config/kitty/kitty.conf
chezmoi apply     # 别忘了同步
```

### 3. 查看待应用的更改

```bash
chezmoi diff
```

### 4. 应用配置到目标目录

```bash
chezmoi apply
```

### 5. 提交到 git

```bash
cd ~/chezmoi
git add .
git commit -m "描述更改内容"
git push
```

## 安装到新机器

```bash
# 方式一：一键脚本
bash <(curl -fsSL https://raw.githubusercontent.com/iamcheyan/chezmoi/main/init.sh)

# 方式二：手动
chezmoi init --apply https://github.com/iamcheyan/chezmoi.git
```

## oh-my-desktop (OMD) symlinks

OMD 的部分路径是你的**个人环境数据**（指向本地 OMD 克隆位置），通过 chezmoi 管理。

| chezmoi 源文件 | 部署到目标 |
|---|---|
| `dot_config/symlink_omd.tmpl` | `~/.config/omd` → `~/development/OMD`（symlink） |
| `dot_config/symlink_quickshell.tmpl` | `~/.config/quickshell` → `~/development/OMD/quickshell`（symlink） |
| `dot_config/foot/foot.ini` | `~/.config/foot/foot.ini` |
| `dot_config/kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `dot_config/kitty/current-theme.conf` | `~/.config/kitty/current-theme.conf` |
| `dot_config/alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `dot_config/fcitx5/config` | `~/.config/fcitx5/config` |
| `dot_config/fcitx5/profile` | `~/.config/fcitx5/profile` |
| `dot_config/fcitx5/conf/*` | `~/.config/fcitx5/conf/*` |
| `dot_config/nvim/colors/oceanblack.vim` | `~/.config/nvim/colors/oceanblack.vim` |
| `dot_config/voice_bindings.txt` | `~/.config/voice_bindings.txt` |
| `dot_config/voice_bindings.txt.save` | `~/.config/voice_bindings.txt.save` |

终端配置（foot/kitty/alacritty/ghostty）、输入法（fcitx5）、Neovim 配色（oceanblack）、语音输入快捷键（voice_bindings.txt）都是**个人偏好文件**（非 symlink），不属于 OMD 公开项目。主题颜色仍由 OMD 的 `~/.config/omd/current/theme/` 注入。

### 跨机器移植

symlink targets 使用 chezmoi 模板变量 `{{ .chezmoi.homeDir }}`，在新机器上自动适配正确的 home 路径。
如果你把 OMD clone 到不同路径（非 `~/development/OMD`），需要更新：

```bash
chezmoi edit ~/.config/omd    # 自动打开源文件
# 修改路径后保存
chezmoi apply
```

### 注意事项

- OMD 的 `Init.sh` 也会创建 `~/.config/{omd,quickshell}` 的 symlink，chezmoi 和 Init.sh 是兼容的——两者都指向同一目标，不会冲突。
- 不要直接删除这些文件——通过 `chezmoi remove` 来取消管理。



- **NEVER 直接编辑 `~/.config/` 下的文件**——那些是 chezmoi 管理的输出文件。
- **ALWAYS 编辑源目录中的源文件**（如 `~/chezmoi/dot_config/aliases.conf`）。
- 编辑后**必须运行 `chezmoi apply`** 同步到目标目录。
- 本仓库仅存放 dotfiles，**绝不添加任何包含密码/Key/Token 的文件**。
- **绝不使用 `--encrypt`** 或任何带加密的 chezmoi 命令。
- 新的 dotfiles 如果路径包含 `.`（如 `.config`）——在 `chezmoi add` 时会自动添加 `dot_` 前缀，无需手动处理。
- 添加可执行脚本到 `dot_local/bin/`，chezmoi 会自动加上 `executable_` 前缀。
- 提交到 git 前建议运行 `chezmoi diff` 确认变更符合预期。
