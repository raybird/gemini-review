#!/bin/bash
# Gemini Tools 安裝腳本 (gemini-review & gemini-commit)

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

# 安裝單個腳本的函數
install_script() {
    local script_name="$1"
    local bin_dir="$2"
    local github_repo="$3"
    local github_branch="$4"
    local script_path="$bin_dir/$script_name"
    
    info "安裝 $script_name..."
    
    # 判斷腳本來源
    # 優先順序：1. 本地檔案 2. GitHub URL（通過參數或環境變數）
    if [ -f "./$script_name" ]; then
        info "從本地複製 $script_name..."
        cp "./$script_name" "$script_path"
    elif [ -n "$github_repo" ]; then
        # 使用指定的 GitHub 倉庫
        local github_url="https://raw.githubusercontent.com/$github_repo/$github_branch/$script_name"
        
        info "從 GitHub 下載 $script_name: $github_url"
        if ! curl -fsSL "$github_url" -o "$script_path"; then
            error "無法從 GitHub 下載 $script_name"
            error "請確認 GitHub 倉庫 URL 是否正確"
            return 1
        fi
    else
        # 如果找不到本地檔案且沒有指定 GitHub 倉庫，返回錯誤
        # 這個錯誤會在 main 函數中統一處理
        return 1
    fi
    
    # 給予執行權限
    chmod +x "$script_path"
    info "✓ $script_name 安裝完成"
    
    return 0
}

# 主安裝函數
main() {
    # 解析參數
    GITHUB_REPO="${1:-$GITHUB_REPO}"
    GITHUB_BRANCH="${2:-${GITHUB_BRANCH:-main}}"
    
    info "開始安裝 Gemini Tools (gemini-review & gemini-commit)..."
    
    # 設定變數
    BIN_DIR="$HOME/.local/bin"
    
    # 建立 bin 目錄
    info "建立目錄: $BIN_DIR"
    mkdir -p "$BIN_DIR"
    
    # 檢查是否有本地檔案或 GitHub 倉庫
    HAS_LOCAL_REVIEW=false
    HAS_LOCAL_COMMIT=false
    if [ -f "./gemini-review" ]; then
        HAS_LOCAL_REVIEW=true
    fi
    if [ -f "./gemini-commit" ]; then
        HAS_LOCAL_COMMIT=true
    fi
    
    # 如果沒有本地檔案且沒有指定 GitHub 倉庫，給出明確錯誤訊息
    if [ "$HAS_LOCAL_REVIEW" = false ] && [ "$HAS_LOCAL_COMMIT" = false ] && [ -z "$GITHUB_REPO" ]; then
        error "找不到本地腳本檔案，且未指定 GitHub 倉庫"
        error ""
        error "請使用以下方式之一："
        error "1. 在包含 gemini-review 和 gemini-commit 腳本的目錄中執行此安裝腳本"
        error "2. 通過參數指定 GitHub 倉庫："
        error "   bash install.sh YOUR_USERNAME/gemini-review [分支名稱]"
        error "3. 或設定環境變數："
        error "   export GITHUB_REPO='YOUR_USERNAME/gemini-review'"
        error "   bash install.sh"
        exit 1
    fi
    
    # 安裝 gemini-review
    if ! install_script "gemini-review" "$BIN_DIR" "$GITHUB_REPO" "$GITHUB_BRANCH"; then
        if [ "$HAS_LOCAL_REVIEW" = false ] && [ -z "$GITHUB_REPO" ]; then
            error "找不到 gemini-review 檔案"
            error "請確認檔案存在或指定 GitHub 倉庫"
        else
            error "gemini-review 安裝失敗"
        fi
        exit 1
    fi
    
    echo ""
    
    # 安裝 gemini-commit
    if ! install_script "gemini-commit" "$BIN_DIR" "$GITHUB_REPO" "$GITHUB_BRANCH"; then
        if [ "$HAS_LOCAL_COMMIT" = false ] && [ -z "$GITHUB_REPO" ]; then
            error "找不到 gemini-commit 檔案"
            error "請確認檔案存在或指定 GitHub 倉庫"
        else
            error "gemini-commit 安裝失敗"
        fi
        exit 1
    fi
    
    echo ""
    
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
                echo '# Gemini Tools' >> "$SHELL_RC"
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
    echo ""
    info "驗證安裝..."
    export PATH="$HOME/.local/bin:$PATH"
    
    local all_installed=true
    local failed_scripts=()
    
    # 驗證 gemini-review
    if command -v "gemini-review" &> /dev/null; then
        info "✓ gemini-review 安裝成功"
    else
        error "✗ gemini-review 安裝驗證失敗"
        all_installed=false
        failed_scripts+=("gemini-review")
    fi
    
    # 驗證 gemini-commit
    if command -v "gemini-commit" &> /dev/null; then
        info "✓ gemini-commit 安裝成功"
    else
        error "✗ gemini-commit 安裝驗證失敗"
        all_installed=false
        failed_scripts+=("gemini-commit")
    fi
    
    echo ""
    
    if [ "$all_installed" = true ]; then
        info "✓ 所有工具安裝成功！"
        echo ""
        info "執行以下命令來使用："
        echo "  gemini-review --help"
        echo "  gemini-commit --help"
        echo ""
        if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
            warn "請重新載入 shell 設定檔或重新開啟終端機："
            echo "  source $SHELL_RC"
        fi
    else
        error "部分工具安裝失敗：${failed_scripts[*]}"
        exit 1
    fi
}

# 執行安裝
main "$@"

