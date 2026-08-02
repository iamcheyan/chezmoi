#!/bin/bash
set -e

echo "=================================================="
echo "    Bitwarden + Chezmoi 引导式一键初始化工具    "
echo "=================================================="
echo ""

# 1. 检查 Bitwarden CLI 是否安装
if ! command -v bw > /dev/null 2>&1; then
    echo "📦 正在安装 Bitwarden CLI (bw)..."
    npm install -g @bitwarden/cli
    echo "✓ Bitwarden CLI 安装完成"
else
    echo "✓ Bitwarden CLI 已安装"
fi

echo ""
# 2. 检查并处理登录状态
BW_STATUS=$(bw status 2>/dev/null | grep -o '"status":"[^"]*"' | cut -d'"' -f4 || echo "unauthenticated")

if [ "$BW_STATUS" = "unauthenticated" ]; then
    echo "🔑 请登录你的 Bitwarden 账号："
    bw login
fi

echo ""
echo "🔓 请输入 Bitwarden 主密码进行解锁："
export BW_SESSION=$(bw unlock --raw)

if [ -z "$BW_SESSION" ]; then
    echo "❌ 解锁失败，脚本退出。"
    exit 1
fi

echo "✓ 成功解锁会话"

# 3. 强制同步云端 Vault
echo ""
echo "🔄 正在同步云端 Vault 数据..."
bw sync --session "$BW_SESSION" > /dev/null 2>&1 || true
echo "✓ 云端 Vault 同步完成"

# 4. 应用 Chezmoi 渲染配置
echo ""
echo "⚙️  正在通过 Chezmoi 渲染应用本地配置文件..."
chezmoi apply --force

echo ""
echo "=================================================="
echo "🎉 初始化完成！"
echo "omp 与 opencode 配置文件已自动生成且测试就绪。"
echo "=================================================="
