#!/bin/bash
# sync-repo-tui インストールスクリプト
# GitHub Releases から最新のバイナリをダウンロードしてインストールします

set -e

# 色の定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                              ║${NC}"
echo -e "${CYAN}║   sync-repo-tui インストーラ                                ║${NC}"
echo -e "${CYAN}║                                                              ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# アーキテクチャを検出
ARCH=$(uname -m)
OS=$(uname -s)

case "$ARCH" in
    x86_64)
        ARCH_SUFFIX="amd64"
        ;;
    aarch64|arm64)
        ARCH_SUFFIX="arm64"
        ;;
    i686|i386)
        ARCH_SUFFIX="386"
        ;;
    *)
        echo -e "${YELLOW}警告: サポートされていないアーキテクチャ: $ARCH${NC}"
        echo "amd64 または arm64 を使用してください"
        exit 1
        ;;
esac

case "$OS" in
    Linux)
        OS_SUFFIX="linux"
        ;;
    Darwin)
        OS_SUFFIX="macos"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        OS_SUFFIX="windows"
        ;;
    *)
        echo -e "${YELLOW}警告: サポートされていないOS: $OS${NC}"
        exit 1
        ;;
esac

# ファイル名を決定
if [ "$OS_SUFFIX" = "windows" ]; then
    FILENAME="sync-repo-tui-${OS_SUFFIX}-${ARCH_SUFFIX}.exe"
else
    FILENAME="sync-repo-tui-${OS_SUFFIX}-${ARCH_SUFFIX}"
fi

echo -e "${CYAN}検出された環境:${NC}"
echo "  OS: $OS"
echo "  アーキテクチャ: $ARCH"
echo "  ダウンロードファイル: $FILENAME"
echo ""

# インストール先を決定
if [ "$OS_SUFFIX" = "windows" ]; then
    INSTALL_DIR="$USERPROFILE/bin"
else
    INSTALL_DIR="$HOME/.local/bin"
fi

# インストールディレクトリの確認
mkdir -p "$INSTALL_DIR"

echo -e "${CYAN}インストール先: $INSTALL_DIR${NC}"
echo ""

# 最新バージョンを取得
echo -e "${CYAN}最新バージョンを確認中...${NC}"
LATEST_URL="https://github.com/Sunwood-ai-labs/claude-glm-actions-lab-sandbox/releases/latest"

# タグ名を取得
TAG_NAME=$(curl -sL -o /dev/null -w '%{url_effective}' "$LATEST_URL" | xargs basename)

if [ -z "$TAG_NAME" ]; then
    echo -e "${YELLOW}警告: 最新バージョンの取得に失敗しました${NC}"
    TAG_NAME="latest"
fi

echo "バージョン: $TAG_NAME"
echo ""

# ダウンロードURL
DOWNLOAD_URL="https://github.com/Sunwood-ai-labs/claude-glm-actions-lab-sandbox/releases/download/${TAG_NAME}/${FILENAME}.tar.gz"

echo -e "${CYAN}ダウンロード中: $DOWNLOAD_URL${NC}"

# 一時ディレクトリを作成
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# ダウンロード
if ! curl -fsSL "$DOWNLOAD_URL" -o "$TMP_DIR/sync-repo-tui.tar.gz"; then
    echo -e "${YELLOW}警告: ダウンロードに失敗しました${NC}"
    echo ""
    echo "手動でダウンロードしてください:"
    echo "  $DOWNLOAD_URL"
    exit 1
fi

# 展開
echo -e "${CYAN}展開中...${NC}"
cd "$TMP_DIR"
tar -xzf sync-repo-tui.tar.gz

# インストール
echo -e "${CYAN}インストール中...${NC}"
if [ "$OS_SUFFIX" = "windows" ]; then
    BINARY_NAME="sync-repo-tui.exe"
else
    BINARY_NAME="sync-repo-tui"
fi

chmod +x "$BINARY_NAME"
mv "$BINARY_NAME" "$INSTALL_DIR/sync-repo-tui"

# Windows の場合は拡張子を付けたファイルも作成
if [ "$OS_SUFFIX" = "windows" ]; then
    cp "$INSTALL_DIR/sync-repo-tui" "$INSTALL_DIR/sync-repo-tui.exe"
fi

echo ""
echo -e "${GREEN}✓ インストールが完了しました！${NC}"
echo ""
echo "実行するには:"
echo ""
if [ "$OS_SUFFIX" = "windows" ]; then
    echo "  $INSTALL_DIR\\sync-repo-tui.exe"
    echo ""
    echo "またはパスを通してから:"
    echo "  sync-repo-tui"
else
    echo "  $INSTALL_DIR/sync-repo-tui"
    echo ""
    echo "またはパスを通してから:"
    echo "  sync-repo-tui"
    echo ""
    echo "パスを通すには、~/.bashrc または ~/.zshrc に以下を追加してください:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
echo ""
echo -e "${CYAN}Happy syncing! 🚀${NC}"
