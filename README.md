# Gemini Tools

一組使用 Google Gemini AI 的命令列工具集，包含程式碼審查和 commit 訊息生成功能。

## 工具介紹

### 🤖 gemini-review
程式碼審查工具，可以快速檢查 Git 變更中的錯誤、安全性問題和程式碼品質問題。

### 📝 gemini-commit
自動生成符合 Conventional Commits 1.0.0 規範的 commit 訊息工具。

## 支援平台

- ✅ Linux
- ✅ macOS
- ✅ 其他 Unix-like 系統（需要 bash）

## 功能特色

### gemini-review
- 🤖 使用 Gemini AI 進行智慧程式碼審查
- 🔍 支援比較不同 Git 分支的差異
- 📝 支援審查已暫存的變更（staged changes）
- 💾 可將審查結果輸出到檔案
- ⚡ 支援即時輸出（stream-json 格式）
- 🚀 自動處理首次提交情況

### gemini-commit
- 📝 自動生成符合 Conventional Commits 1.0.0 規範的 commit 訊息
- 🇹🇼 使用繁體中文生成訊息
- 📋 以 code block 格式輸出，方便複製
- 🔒 不會自動提交，安全可控
- ⚡ 即時顯示生成進度

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
- 下載或複製 `gemini-review` 和 `gemini-commit` 腳本
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

將 `gemini-review` 和 `gemini-commit` 腳本複製到 `~/.local/bin/` 目錄：

```bash
cp gemini-review ~/.local/bin/gemini-review
cp gemini-commit ~/.local/bin/gemini-commit
```

#### 3. 給予執行權限

```bash
chmod +x ~/.local/bin/gemini-review
chmod +x ~/.local/bin/gemini-commit
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
gemini-commit --help
```

如果看到使用說明，表示安裝成功！

## 使用說明

## gemini-review

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

## gemini-commit

### 基本語法

```bash
gemini-commit [選項]
```

### 選項

- `-h, --help`：顯示使用說明

### 功能說明

1. 自動查看已暫存（staged）的檔案列表
2. 分析所有已暫存檔案的變更內容
3. 生成符合 Conventional Commits 1.0.0 規範的 commit 訊息
4. 以繁體中文輸出到 code block 中，方便複製（不會自動提交）

### 使用範例

#### 生成 commit 訊息

```bash
# 1. 先暫存變更
git add .

# 2. 生成 commit 訊息
gemini-commit

# 3. 複製輸出的 commit 訊息並提交
git commit -m "feat: 新增某功能"
```

#### 完整工作流程

```bash
# 修改檔案後
git add file1.py file2.js

# 生成 commit 訊息
gemini-commit
# 輸出：
# ```
# feat: 新增使用者認證功能
# ```

# 複製訊息並提交
git commit -m "feat: 新增使用者認證功能"
```

## 注意事項

1. **必須在 Git 倉庫中執行**：兩個工具都需要在 Git 倉庫目錄下執行
2. **需要 Gemini CLI**：請確保已安裝並設定好 `gemini` 命令列工具
3. **分支必須存在**（gemini-review）：如果指定分支名稱，該分支必須存在於本地倉庫中
4. **需要有已暫存的變更**（gemini-commit）：使用前請先使用 `git add` 暫存變更
5. **網路連線**：使用 Gemini AI 需要網路連線
6. **可選工具**：建議安裝 `jq` 以獲得更好的即時輸出體驗（stream-json 格式）

## 工作原理

### gemini-review

1. 工具會使用 `git diff` 取得程式碼變更
2. 將變更內容傳送給 Gemini AI 進行分析
3. Gemini AI 會檢查：
   - 程式碼錯誤
   - 安全性問題
   - 程式碼品質問題
4. 回傳具體的改進建議
5. 使用 stream-json 格式實現即時輸出

### gemini-commit

1. 檢查已暫存的檔案列表
2. 使用 `git diff --cached` 取得所有已暫存檔案的變更內容
3. 將變更內容傳送給 Gemini AI 進行分析
4. Gemini AI 根據變更內容生成符合 Conventional Commits 1.0.0 規範的訊息
5. 以 code block 格式輸出，方便複製使用

## 疑難排解

### 錯誤：不在 git 倉庫中

請確保在 Git 倉庫目錄下執行此命令。兩個工具都需要在 Git 倉庫中執行。

### 錯誤：找不到 gemini 指令

請先安裝 [Gemini CLI](https://github.com/google/generative-ai-cli)，並確保已正確設定。

### 錯誤：分支不存在（gemini-review）

請確認指定的分支名稱正確，或使用 `git branch` 查看可用的分支。如果這是第一次提交，請使用 `-s` 選項審查已暫存的變更。

### 錯誤：沒有已暫存的檔案（gemini-commit）

請先使用 `git add` 暫存一些變更後再執行 `gemini-commit`。

### 錯誤：輸出緩衝問題

如果遇到輸出不即時的問題，建議安裝 `jq` 工具以獲得更好的即時輸出體驗：
- Ubuntu/Debian: `sudo apt-get install jq`
- macOS: `brew install jq`
- 其他平台請參考 [jq 官方網站](https://stedolan.github.io/jq/download/)

## 授權

此專案為開源工具，歡迎自由使用與修改。
