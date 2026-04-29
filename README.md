# 加密 Dotfiles

本仓库使用 [chezmoi](https://www.chezmoi.io/) + [age](https://github.com/FiloSottile/age) 管理敏感配置文件，所有加密文件在 GitHub 上均以密文存储。

> 本仓库仅存放敏感/加密配置。常规 dotfiles（zshrc、vimrc、aliases 等）在另一个公开仓库中维护。

---

## 仓库结构

```
~/chezmoi/                    ← 源目录（git 管理）
├── .chezmoi.toml.tmpl        ← chezmoi 配置模板
├── .gitignore                ← 排除 age.key
├── age.key                   ← age 私钥（本地，不提交）
├── init.sh                   ← 新机器一键初始化脚本
├── dot_config/
│   └── dotfiles/
│       └── aliases/
│           └── private.conf  ← 敏感 alias（加密）
└── private_dot_ssh/
    └── encrypted_private_config.age
```

---

## 新机器恢复流程

### 方式一：一键脚本（推荐）

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/iamcheyan/chezmoi/main/init.sh)
```

脚本会自动：
1. 检测系统并安装 `chezmoi` + `age`
2. `chezmoi init --apply` 从仓库拉取配置
3. 提示恢复 `age.key` 私钥

然后手动执行：
```bash
# 把备份的 age.key 放到源目录
cp /path/to/your/age.key ~/chezmoi/age.key

# 解密并部署所有加密文件
chezmoi apply
```

### 方式二：手动

```bash
# 1. 安装依赖
dnf install -y chezmoi age      # Fedora
apt install -y chezmoi age      # Debian/Ubuntu
brew install chezmoi age        # macOS

# 2. 初始化并应用配置
chezmoi init --apply https://github.com/iamcheyan/chezmoi.git

# 3. 恢复 age 私钥
cp /path/to/your/age.key ~/chezmoi/age.key

# 4. 解密部署
chezmoi apply
```

---

## 日常使用

```bash
# 进入源目录
cd ~/chezmoi

# 添加新的敏感文件（自动加密）
chezmoi add --encrypt ~/.ssh/config

# 编辑已管理的文件
chezmoi edit ~/.ssh/config

# 查看改动
chezmoi diff

# 应用配置
chezmoi apply

# 推送到远程
chezmoi cd && git add . && git commit -m "update" && git push
```

---

## chezmoi 命名规则

chezmoi 通过**源目录中的文件名前缀**自动映射到目标目录（`~`），无需逐个配置路径。

### 属性前缀

| 前缀 | 效果 | 可用位置 | 示例 |
|---|---|---|---|
| `dot_` | 替换为 `.` | 文件名、目录名 | `dot_zshrc` → `~/.zshrc` |
| `private_` | 权限 0600 | 文件名 | `private_dot_env` → `~/.env`（仅自己可读写） |
| `executable_` | 权限 0755 | 文件名 | `executable_script.sh` → `~/script.sh`（可执行） |
| `encrypted_` | 加密存储 | 文件名 | `encrypted_private_config` → 密文存储，部署时自动解密 |
| `literal_` | 原样保留，不处理前缀 | 文件名 | `literal_dot_bashrc` → `~/dot_bashrc`（真的叫 dot_bashrc） |
| `symlink_` | 创建符号链接 | 文件名 | `symlink_dot_zshrc` → `~/.zshrc`（链接到源文件） |

前缀可以**任意组合**，顺序无关：

```
private_executable_dot_env    → ~/.env（权限 0700）
encrypted_private_config      → 加密 + 权限 0600
```

### 路径映射示例

```
源目录                          → 目标目录
~/chezmoi/
├── dot_config/
│   └── kitty/
│       └── kitty.conf       → ~/.config/kitty/kitty.conf
├── dot_ssh/
│   └── private_dot_config   → ~/.ssh/config（权限 0600）
├── dot_local/
│   └── bin/
│       └── executable_my.sh → ~/.local/bin/my.sh（权限 0755）
└── dot_zshrc                → ~/.zshrc
```

### 特殊文件（不部署到 `~`）

| 文件 | 作用 |
|---|---|
| `.chezmoi.toml.tmpl` | 配置模板，`chezmoi init` 时生成 `~/.config/chezmoi/chezmoi.toml` |
| `.chezmoiignore` | 告诉 chezmoi 哪些源文件不部署到目标目录 |
| `.chezmoiroot` | 定义子模块根目录 |

---

## 加密机制

- 加密算法：**age**（现代、简洁的文件加密工具）
- 配置模板：`~/chezmoi/.chezmoi.toml.tmpl`
- 生成的配置：`~/.config/chezmoi/chezmoi.toml`
- 私钥路径：`~/chezmoi/age.key`

加密后的文件在仓库中以 `.age` 后缀存储，例如：

```
private_dot_ssh/
└── encrypted_private_config.age
```

---

## 安全提醒

**`~/chezmoi/age.key` 是唯一能解密本仓库的私钥，务必妥善备份。**

建议备份到：
- 密码管理器（1Password、Bitwarden 等）
- 加密 U 盘
- 离线存储

**丢失此密钥将导致仓库内所有加密文件永久无法恢复。**
