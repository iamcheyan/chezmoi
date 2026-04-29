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
