# Gemini Code Review

一個使用 Google Gemini AI 進行程式碼審查的命令列工具，可以快速檢查 Git 變更中的錯誤、安全性問題和程式碼品質問題。

## 支援平台

- ✅ Linux
- ✅ macOS
- ✅ 其他 Unix-like 系統（需要 bash）

## 功能特色

- 🤖 使用 Gemini AI 進行智慧程式碼審查
- 🔍 支援比較不同 Git 分支的差異
- 📝 支援審查已暫存的變更（staged changes）
- 💾 可將審查結果輸出到檔案
- ⚡ 簡單易用的命令列介面

## 系統需求

- **作業系統**：Linux、macOS 或其他 Unix-like 系統
- **Shell**：Bash 或 Zsh（macOS 預設使用 Zsh）
- **Git**：已安裝並初始化倉庫
- **Gemini CLI**：[Gemini CLI](https://github.com/google/generative-ai-cli)（需先安裝並設定）
- **curl**：用於一鍵安裝（通常已預裝）

## 安裝步驟

### 方式一：一鍵安裝（推薦）

如果專案已上傳到 GitHub，可以使用以下命令一鍵安裝：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/raybird/gemini-review/main/install.sh)" -- raybird/gemini-review
```

> **注意**：請將 `raybird` 替換為您的 GitHub 使用者名稱，或根據實際的倉庫路徑調整 URL。

**或者**，如果已經下載了專案到本地，可以直接執行：

```bash
cd gemini-review
bash install.sh
```

**或者**，從 GitHub 下載安裝腳本後，指定倉庫位置：

```bash
curl -fsSL https://raw.githubusercontent.com/raybird/gemini-review/main/install.sh | bash -s -- raybird/gemini-review
```

安裝腳本會自動：
- 下載或複製 `gemini-review` 腳本
- 安裝到 `~/.local/bin/` 目錄
- 設定執行權限
- 更新 PATH 環境變數
- 驗證安裝結果

### 方式二：手動安裝

#### 1. 建立本地 bin 目錄（如果還沒有）

```bash
mkdir -p ~/.local/bin
```

#### 2. 複製腳本檔案

將 `gemini-review` 腳本複製到 `~/.local/bin/` 目錄：

```bash
cp gemini-review ~/.local/bin/gemini-review
```

#### 3. 給予執行權限

```bash
chmod +x ~/.local/bin/gemini-review
```

#### 4. 確保 ~/.local/bin 在 PATH 中

根據您使用的 shell，在對應的設定檔中加入 PATH：

**macOS（預設使用 Zsh）：**
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Linux（Bash）：**
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**或使用 bash_profile（某些 macOS 設定）：**
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
```

#### 5. 重新載入 shell 設定檔

執行對應的 `source` 命令（見上方），或重新開啟終端機。

#### 6. 驗證安裝

```bash
gemini-review --help
```

如果看到使用說明，表示安裝成功！

## 使用說明

### 基本語法

```bash
gemini-review [選項] [基礎分支]
```

### 選項

- `-h, --help`：顯示使用說明
- `-o, --output <檔案>`：將審查結果輸出到指定檔案
- `-s, --staged`：只審查已暫存的變更（staged changes）

### 使用範例

#### 與預設分支（dev）比較

```bash
gemini-review
```

#### 與指定分支比較

```bash
gemini-review main
gemini-review develop
```

#### 審查已暫存的變更

```bash
gemini-review -s
```

#### 將審查結果輸出到檔案

```bash
gemini-review -o review.txt main
```

#### 組合使用

```bash
gemini-review -s -o staged-review.txt
```

## 注意事項

1. **必須在 Git 倉庫中執行**：此工具需要在 Git 倉庫目錄下執行
2. **需要 Gemini CLI**：請確保已安裝並設定好 `gemini` 命令列工具
3. **分支必須存在**：如果指定分支名稱，該分支必須存在於本地倉庫中
4. **網路連線**：使用 Gemini AI 需要網路連線

## 工作原理

1. 工具會使用 `git diff` 取得程式碼變更
2. 將變更內容傳送給 Gemini AI 進行分析
3. Gemini AI 會檢查：
   - 程式碼錯誤
   - 安全性問題
   - 程式碼品質問題
4. 回傳具體的改進建議

## 疑難排解

### 錯誤：不在 git 倉庫中

請確保在 Git 倉庫目錄下執行此命令。

### 錯誤：找不到 gemini 指令

請先安裝 [Gemini CLI](https://github.com/google/generative-ai-cli)，並確保已正確設定。

### 錯誤：分支不存在

請確認指定的分支名稱正確，或使用 `git branch` 查看可用的分支。

## 授權

此專案為開源工具，歡迎自由使用與修改。
