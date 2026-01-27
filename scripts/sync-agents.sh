#!/bin/bash
# GitHub Agents 同期スクリプト
# このリポジトリのエージェントファイルをターゲットリポジトリに同期

set -e

# 色の定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 一時ディレクトリ
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# スクリプトのディレクトリ
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# .env ファイルを読み込む（存在する場合）
if [ -f "$PROJECT_ROOT/.env" ]; then
    set -a
    source "$PROJECT_ROOT/.env"
    set +a
fi

# ターゲットリポジトリのチェック
TARGET_REPO="${TARGET_REPO:-Sunwood-ai-labs/claude-glm-actions-lab-sandbox}"
AGENTS_SOURCE="$PROJECT_ROOT/.claude/agents"

echo -e "${GREEN}=== GitHub Agents 同期 ===${NC}"
echo "ターゲットリポジトリ: $TARGET_REPO"
echo "ソースディレクトリ: $AGENTS_SOURCE"
echo ""

# ソースディレクトリのチェック
if [ ! -d "$AGENTS_SOURCE" ]; then
    echo -e "${RED}エラー: エージェントソースディレクトリが見つかりません: $AGENTS_SOURCE${NC}"
    exit 1
fi

# エージェントファイルの確認
AGENT_FILES=$(find "$AGENTS_SOURCE" -type f \( -name "*.md" -o -name "*.json" -o -name "*.yml" -o -name "*.yaml" \) 2>/dev/null || true)
if [ -z "$AGENT_FILES" ]; then
    echo -e "${YELLOW}警告: エージェントファイルが見つかりません${NC}"
    exit 0
fi

echo "同期するエージェントファイル:"
echo "$AGENT_FILES" | while read -r file; do
    rel_path="${file#$AGENTS_SOURCE/}"
    echo "  - $rel_path"
done
echo ""

# gh コマンドのチェック
if ! command -v gh &> /dev/null; then
    echo -e "${RED}エラー: gh コマンドがインストールされていません${NC}"
    echo "https://cli.github.com/ からインストールしてください"
    exit 1
fi

# 認証チェック
echo "GitHub 認証チェック..."
if ! gh auth status &> /dev/null; then
    echo -e "${RED}エラー: GitHub にログインしていません${NC}"
    echo "gh auth login でログインしてください"
    exit 1
fi

# ターゲットリポジトリをクローン
echo ""
echo "ターゲットリポジトリをクローン中..."
TARGET_DIR="$TEMP_DIR/target"
gh repo clone "$TARGET_REPO" "$TARGET_DIR" 2>/dev/null

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}エラー: リポジトリのクローンに失敗しました${NC}"
    exit 1
fi

# ターゲットのエージェントディレクトリを作成
TARGET_AGENTS_DIR="$TARGET_DIR/.claude/agents"
mkdir -p "$TARGET_AGENTS_DIR"

# エージェントファイルをコピー（追加・上書きのみ、ディレクトリ構造を維持）
echo ""
echo "エージェントファイルをコピー中..."

echo "$AGENT_FILES" | while read -r file; do
    rel_path="${file#$AGENTS_SOURCE/}"
    target_file="$TARGET_AGENTS_DIR/$rel_path"
    target_dir="$(dirname "$target_file")"
    mkdir -p "$target_dir"
    echo -e "${YELLOW}コピー:${NC} $rel_path"
    cp "$file" "$target_file"
done

# ターゲットリポジトリでコミット
cd "$TARGET_DIR"
echo ""
echo "変更をコミット中..."

if [ -n "$(git status --porcelain)" ]; then
    git config user.name "Claude Code"
    git config user.email "noreply@anthropic.com"

    git add .claude/agents/
    git commit -m "🤖 chore(agents): sync agents from claude-glm-actions-lab

Co-Authored-By: Claude <noreply@anthropic.com>"

    echo ""
    echo "変更をプッシュ中..."
    git push origin main 2>/dev/null || git push origin HEAD

    echo -e "${GREEN}✓ エージェントを同期しました${NC}"
else
    echo -e "${YELLOW}同期する変更はありませんでした${NC}"
fi
