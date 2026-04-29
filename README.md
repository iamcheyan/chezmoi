# 加密 Dotfiles

本仓库使用 [chezmoi](https://www.chezmoi.io/) + [age](https://github.com/FiloSottile/age) 管理敏感配置文件，所有加密文件在 GitHub 上均以密文存储。

---

## 依赖

- [chezmoi](https://www.chezmoi.io/install/)
- [age](https://github.com/FiloSottile/age#installation)

## 新机器初始化

```bash
# 1. 安装依赖后，clone 并应用配置
chezmoi init --apply https://github.com/iamcheyan/chezmoi.git

# 2. 将 age 私钥放到 ~/.config/chezmoi/age.key
#    （私钥需从密码管理器或其他安全备份中恢复）
```

## 日常使用

```bash
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

## 加密机制

- 加密算法：**age**（现代、简洁的文件加密工具）
- 配置文件：`~/.config/chezmoi/chezmoi.toml`
- 私钥路径：`~/.config/chezmoi/age.key`

加密后的文件在仓库中以 `.age` 后缀存储，例如：

```
private_dot_ssh/
└── encrypted_private_config.age
```

## 安全提醒

**`~/.config/chezmoi/age.key` 是唯一能解密本仓库的私钥，务必妥善备份。**

建议备份到：
- 密码管理器（1Password、Bitwarden 等）
- 加密 U 盘
- 离线存储

**丢失此密钥将导致仓库内所有加密文件永久无法恢复。**

---

> 本仓库仅存放敏感/加密配置。常规 dotfiles（zshrc、vimrc、aliases 等）在另一个公开仓库中维护。
