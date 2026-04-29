#!/bin/bash

# 新机器初始化脚本：安装 chezmoi + age，然后从仓库拉取加密配置
# 用法: bash <(curl -fsSL https://raw.githubusercontent.com/iamcheyan/chezmoi/main/init.sh)
#       或下载后执行: ./init.sh

set -euo pipefail

REPO_URL="https://github.com/iamcheyan/chezmoi.git"

echo "=========================================="
echo "  Chezmoi + Age 安装与初始化"
echo "=========================================="
echo ""

# 1. 检测并安装依赖
install_deps() {
  echo "[1/3] 检测并安装依赖..."

  if command -v chezmoi >/dev/null 2>&1 && command -v age >/dev/null 2>&1; then
    echo "  chezmoi 和 age 已安装，跳过"
    return
  fi

  local pkg_manager=""

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v dnf >/dev/null 2>&1; then
      pkg_manager="dnf"
    elif command -v apt >/dev/null 2>&1; then
      pkg_manager="apt"
    elif command -v pacman >/dev/null 2>&1; then
      pkg_manager="pacman"
    elif command -v apk >/dev/null 2>&1; then
      pkg_manager="apk"
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew >/dev/null 2>&1; then
      pkg_manager="brew"
    else
      echo "  错误: macOS 需要 Homebrew，请先安装: https://brew.sh"
      exit 1
    fi
  fi

  # 尝试包管理器安装（支持 chezmoi 和 age 的发行版）
  if [ -n "$pkg_manager" ]; then
    echo "  使用 $pkg_manager 安装..."
    case "$pkg_manager" in
      dnf)
        sudo dnf install -y chezmoi age 2>/dev/null || true
        ;;
      apt)
        sudo apt-get update && sudo apt-get install -y chezmoi age 2>/dev/null || true
        ;;
      pacman)
        sudo pacman -S --noconfirm chezmoi age 2>/dev/null || true
        ;;
      apk)
        sudo apk add chezmoi age 2>/dev/null || true
        ;;
      brew)
        brew install chezmoi age 2>/dev/null || true
        ;;
    esac
  fi

  # 如果包管理器没有，通过官方脚本/二进制安装
  # 优先安装到 ~/.local/bin（无需 sudo），否则回退到 /usr/local/bin
  local install_dir="$HOME/.local/bin"
  mkdir -p "$install_dir"

  if ! command -v chezmoi >/dev/null 2>&1; then
    echo "  包管理器未提供 chezmoi，通过官方脚本安装..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$install_dir"
    chmod +x "$install_dir/chezmoi"
  fi

  if ! command -v age >/dev/null 2>&1; then
    echo "  包管理器未提供 age，通过 GitHub Release 安装..."
    local arch="amd64"
    case "$(uname -m)" in
      aarch64|arm64) arch="arm64" ;;
      armv7l) arch="arm" ;;
    esac
    local age_tar="age-v1.2.1-linux-${arch}.tar.gz"
    local tmpdir="$(mktemp -d)"
    curl -fsSL "https://github.com/FiloSottile/age/releases/download/v1.2.1/${age_tar}" -o "${tmpdir}/${age_tar}"
    tar -xzf "${tmpdir}/${age_tar}" -C "$tmpdir"
    mv "${tmpdir}/age/age" "$install_dir/age"
    mv "${tmpdir}/age/age-keygen" "$install_dir/age-keygen"
    chmod +x "$install_dir/age" "$install_dir/age-keygen"
    rm -rf "$tmpdir"
  fi

  # 确保 ~/.local/bin 在 PATH 中
  if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
  fi

  if command -v chezmoi >/dev/null 2>&1 && command -v age >/dev/null 2>&1; then
    echo "  安装完成"
  else
    echo "  错误: 安装失败，请手动安装 chezmoi 和 age"
    echo "  https://www.chezmoi.io/install/"
    echo "  https://github.com/FiloSottile/age#installation"
    exit 1
  fi
}

# 2. 初始化 chezmoi
init_chezmoi() {
  echo ""
  echo "[2/3] 从仓库初始化 chezmoi..."
  chezmoi init --source="$HOME/chezmoi" "$REPO_URL"
  echo "  仓库已克隆到 ~/chezmoi"
}

# 3. 提示恢复 age 私钥
prompt_key() {
  echo ""
  echo "[3/3] 恢复 age 私钥"
  echo ""
  local key_path="${HOME}/chezmoi/age.key"

  if [ -f "$key_path" ]; then
    echo "  age 私钥已存在，解密配置..."
    chezmoi apply
    echo "  完成！"
  else
    echo "  ⚠️  age 私钥未找到: $key_path"
    echo ""
    echo "  请从密码管理器或安全备份中恢复私钥，然后执行:"
    echo "    chezmoi apply"
    echo ""
    echo "  没有私钥的话，仓库中的加密文件将无法解密。"
  fi
}

# 主流程
install_deps
init_chezmoi
prompt_key

echo ""
echo "=========================================="
echo "  初始化流程结束"
echo "=========================================="
