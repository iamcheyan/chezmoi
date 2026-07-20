#!/bin/bash

# 新机器初始化脚本：安装 chezmoi，然后从仓库拉取 dotfiles
# 用法: bash <(curl -fsSL https://raw.githubusercontent.com/iamcheyan/chezmoi/main/init.sh)
#       或下载后执行: ./init.sh

set -euo pipefail

REPO_URL="https://github.com/iamcheyan/chezmoi.git"

echo "=========================================="
echo "  Chezmoi Dotfiles 安装与初始化"
echo "=========================================="
echo ""

# 1. 检测并安装 chezmoi
install_deps() {
  echo "[1/2] 检测并安装依赖..."

  if command -v chezmoi >/dev/null 2>&1; then
    echo "  chezmoi 已安装，跳过"
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

  # 尝试包管理器安装
  if [ -n "$pkg_manager" ]; then
    echo "  使用 $pkg_manager 安装..."
    case "$pkg_manager" in
      dnf)
        sudo dnf install -y chezmoi 2>/dev/null || true
        ;;
      apt)
        sudo apt-get update && sudo apt-get install -y chezmoi 2>/dev/null || true
        ;;
      pacman)
        sudo pacman -S --noconfirm chezmoi 2>/dev/null || true
        ;;
      apk)
        sudo apk add chezmoi 2>/dev/null || true
        ;;
      brew)
        brew install chezmoi 2>/dev/null || true
        ;;
    esac
  fi

  # 如果包管理器没有，通过官方脚本安装
  if ! command -v chezmoi >/dev/null 2>&1; then
    local install_dir="$HOME/.local/bin"
    mkdir -p "$install_dir"
    echo "  包管理器未提供 chezmoi，通过官方脚本安装..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$install_dir"
    chmod +x "$install_dir/chezmoi"

    # 确保 ~/.local/bin 在 PATH 中
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
      export PATH="$HOME/.local/bin:$PATH"
    fi
  fi

  if command -v chezmoi >/dev/null 2>&1; then
    echo "  安装完成"
  else
    echo "  错误: 安装失败，请手动安装 chezmoi"
    echo "  https://www.chezmoi.io/install/"
    exit 1
  fi
}

# 2. 初始化 chezmoi
init_chezmoi() {
  echo ""
  echo "[2/2] 从仓库初始化 chezmoi..."
  chezmoi init --source="$HOME/chezmoi" "$REPO_URL"
  echo "  仓库已克隆到 ~/chezmoi"
}

# 主流程
install_deps
init_chezmoi

# 配置 git hooks
if [ -d "$HOME/chezmoi/.githooks" ]; then
  git -C "$HOME/chezmoi" config core.hooksPath .githooks
  echo "  git hooksPath 已设置为 .githooks"
fi

echo ""
echo "=========================================="
echo "  初始化完成！"
echo "=========================================="
echo ""
echo "  运行 'cd ~/chezmoi && chezmoi apply' 应用配置。"
echo "  本仓库仅包含非敏感 dotfiles，无需 age 私钥。"
