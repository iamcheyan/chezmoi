#!/bin/bash

# ===== 加载 .env =====
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ 当前目录没有 .env 文件"
  exit 1
fi

# ===== 读取参数 =====
REMOTE="${1:-origin}"
TARGET_BRANCH="${2:-}"

# ===== 读取对应 remote 的 PAT =====
case "$REMOTE" in
  origin) PAT="$ORIGIN" ;;
  local) PAT="$LOCAL" ;;
  *)     echo "❌ 未知 remote: $REMOTE"; exit 1 ;;
esac

REPO_URL=$(git config --get remote.$REMOTE.url)

# ===== 校验 =====
if [ -z "$PAT" ]; then
  echo "❌ .env 中未设置 $REMOTE 对应的 PAT"
  exit 1
fi

if [ -z "$REPO_URL" ]; then
  echo "❌ 当前目录不是 git 仓库"
  exit 1
fi

# ===== SSH → HTTPS =====
if [[ "$REPO_URL" == git@* ]]; then
  REPO_URL=$(echo "$REPO_URL" | sed -E 's/git@(.*):(.*)/https:\/\/\1\/\2/')
fi

# ===== 注入 PAT =====
if [[ "$PAT" == *:* ]]; then
  AUTH_CRED="$PAT"
else
  AUTH_CRED="x-access-token:$PAT"
fi
AUTH_URL=$(echo "$REPO_URL" | sed -E "s#https://#https://$AUTH_CRED@#")

# ===== 获取当前分支 =====
BRANCH=$(git branch --show-current)

# detached HEAD 时必须显式指定目标分支
if [ -z "$BRANCH" ]; then
  if [ -z "$TARGET_BRANCH" ]; then
    echo "❌ 当前是 detached HEAD，请指定目标分支，例如: pat $REMOTE main"
    exit 1
  fi
  REFSPEC="HEAD:$TARGET_BRANCH"
else
  REFSPEC="${TARGET_BRANCH:-$BRANCH}"
fi

# ===== 执行 push =====
git push "$AUTH_URL" "$REFSPEC"
