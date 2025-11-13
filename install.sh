#!/bin/bash
# Gemini Review 安裝腳本

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 顯示訊息
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# 檢查命令是否存在
check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

# 主安裝函數
main() {
    # 解析參數
    GITHUB_REPO="${1:-$GITHUB_REPO}"
    GITHUB_BRANCH="${2:-${GITHUB_BRANCH:-main}}"
    
    info "開始安裝 Gemini Review..."
    
    # 設定變數
    BIN_DIR="$HOME/.local/bin"
    SCRIPT_NAME="gemini-review"
    SCRIPT_PATH="$BIN_DIR/$SCRIPT_NAME"
    
    # 建立 bin 目錄
    info "建立目錄: $BIN_DIR"
    mkdir -p "$BIN_DIR"
    
    # 判斷腳本來源
    # 優先順序：1. 本地檔案 2. GitHub URL（通過參數或環境變數）
    if [ -f "./gemini-review" ]; then
        info "從本地複製腳本..."
        cp "./gemini-review" "$SCRIPT_PATH"
    elif [ -n "$GITHUB_REPO" ]; then
        # 使用指定的 GitHub 倉庫
        GITHUB_URL="https://raw.githubusercontent.com/$GITHUB_REPO/$GITHUB_BRANCH/gemini-review"
        
        info "從 GitHub 下載腳本: $GITHUB_URL"
        if ! curl -fsSL "$GITHUB_URL" -o "$SCRIPT_PATH"; then
            error "無法從 GitHub 下載腳本"
            error "請確認 GitHub 倉庫 URL 是否正確"
            exit 1
        fi
    else
        # 嘗試從預設位置下載（需要使用者設定）
        error "找不到本地腳本檔案，且未指定 GitHub 倉庫"
        error ""
        error "請使用以下方式之一："
        error "1. 在包含 gemini-review 腳本的目錄中執行此安裝腳本"
        error "2. 通過參數指定 GitHub 倉庫："
        error "   bash install.sh YOUR_USERNAME/gemini-review [分支名稱]"
        error "3. 或設定環境變數："
        error "   export GITHUB_REPO='YOUR_USERNAME/gemini-review'"
        error "   bash install.sh"
        exit 1
    fi
    
    # 給予執行權限
    info "設定執行權限..."
    chmod +x "$SCRIPT_PATH"
    
    # 檢查 PATH
    info "檢查 PATH 設定..."
    SHELL_RC=""
    # 檢測 shell 類型（macOS 預設使用 zsh）
    if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_RC="$HOME/.bash_profile"
    else
        SHELL_RC="$HOME/.profile"
    fi
    
    # 檢查是否已在 PATH 中
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        warn "PATH 中未包含 $BIN_DIR"
        info "正在更新 $SHELL_RC..."
        
        if [ -f "$SHELL_RC" ]; then
            if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$SHELL_RC"; then
                echo '' >> "$SHELL_RC"
                echo '# Gemini Review' >> "$SHELL_RC"
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
                info "已將 PATH 設定加入 $SHELL_RC"
            else
                info "PATH 設定已存在於 $SHELL_RC"
            fi
        else
            warn "找不到 $SHELL_RC，請手動將以下內容加入您的 shell 設定檔："
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
        fi
    else
        info "PATH 已包含 $BIN_DIR"
    fi
    
    # 驗證安裝
    info "驗證安裝..."
    export PATH="$HOME/.local/bin:$PATH"
    if command -v "$SCRIPT_NAME" &> /dev/null; then
        info "✓ 安裝成功！"
        echo ""
        info "執行以下命令來使用："
        echo "  $SCRIPT_NAME --help"
        echo ""
        if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
            warn "請重新載入 shell 設定檔或重新開啟終端機："
            echo "  source $SHELL_RC"
        fi
    else
        error "安裝驗證失敗"
        exit 1
    fi
}

# 執行安裝
main "$@"

