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

  if [ -z "$pkg_manager" ]; then
    echo "  错误: 无法识别包管理器，请手动安装 chezmoi 和 age"
    echo "  https://www.chezmoi.io/install/"
    echo "  https://github.com/FiloSottile/age#installation"
    exit 1
  fi

  echo "  使用 $pkg_manager 安装..."
  case "$pkg_manager" in
    dnf)
      sudo dnf install -y chezmoi age
      ;;
    apt)
      sudo apt-get update && sudo apt-get install -y chezmoi age
      ;;
    pacman)
      sudo pacman -S --noconfirm chezmoi age
      ;;
    apk)
      sudo apk add chezmoi age
      ;;
    brew)
      brew install chezmoi age
      ;;
  esac

  echo "  安装完成"
}

# 2. 初始化 chezmoi
init_chezmoi() {
  echo ""
  echo "[2/3] 从仓库初始化 chezmoi..."
  chezmoi init --apply "$REPO_URL"
  echo "  配置已应用到本地"
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
