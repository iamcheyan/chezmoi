#!/bin/bash
set -euo pipefail

CHEZMOI_CONFIG="${HOME}/.config/chezmoi/chezmoi.toml"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 从 chezmoi 配置读取 age 公钥
load_recipient() {
    if [[ ! -f "$CHEZMOI_CONFIG" ]]; then
        echo -e "${RED}错误: chezmoi 配置文件不存在: $CHEZMOI_CONFIG${NC}" >&2
        exit 1
    fi
    AGE_RECIPIENT=$(grep -E '^\s*recipient\s*=' "$CHEZMOI_CONFIG" | sed 's/.*=\s*"\(.*\)"/\1/' | tr -d '[:space:]')
    if [[ -z "$AGE_RECIPIENT" ]]; then
        echo -e "${RED}错误: 未在 $CHEZMOI_CONFIG 中找到 age recipient${NC}" >&2
        exit 1
    fi
}

load_recipient

usage() {
    echo "用法: encrypt.sh <文件> [文件2] [文件3] ..."
    echo ""
    echo "将文件用 age 加密，生成 <文件名>.age"
    echo "公钥来源: $CHEZMOI_CONFIG"
    echo ""
    echo "示例:"
    echo "  encrypt.sh ~/.env"
    echo "  encrypt.sh secret.txt config.yaml"
    exit 1
}

if [[ $# -eq 0 ]]; then
    usage
fi

for file in "$@"; do
    # 展开 ~ 和相对路径
    file="$(eval echo "$file")"

    if [[ ! -f "$file" ]]; then
        echo -e "${RED}错误: 文件不存在: $file${NC}" >&2
        continue
    fi

    encrypted="${file}.age"

    if [[ -f "$encrypted" ]]; then
        echo -e "${YELLOW}警告: 加密文件已存在: $encrypted${NC}"
        read -rp "覆盖? (y/N) " confirm
        if [[ "$confirm" != [yY] ]]; then
            echo "跳过: $file"
            continue
        fi
    fi

    age -r "$AGE_RECIPIENT" -o "$encrypted" "$file"
    echo -e "${GREEN}已加密: $encrypted${NC}"

    read -rp "删除原文件 $file ? (y/N) " del
    if [[ "$del" == [yY] ]]; then
        rm "$file"
        echo -e "${GREEN}已删除: $file${NC}"
    else
        echo -e "${YELLOW}保留: $file${NC}"
    fi
    echo ""
done
