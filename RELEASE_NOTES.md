<img src="https://raw.githubusercontent.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab/main/assets/release-header-v1.1.0.svg" alt="v1.1.0 Release"/>

# v1.1.0 - TUI Modernization & Repository Sync Enhancement / TUIモダン化とリポジトリ同期機能強化

**リリース日 / Release Date:** 2026-01-29

---

## 日本語 / Japanese

### 概要

本リリースでは、リポジトリ同期ツールの大幅な機能強化とモダナイゼーションを実施しました。最大の変更点は、blessedベースの旧TUIから **ReactとInk**を使用したモダンなアーキテクチャへの移行です。また、PRオープン時に自動的にコメントを投稿するGitHub Actionsワークフローも追加しました。

### 📊 変更統計

| 項目 | 数値 |
|:-----|:-----|
| 追加ファイル | 45個 |
| 追加コード | +5,224行 |
| 削除コード | -256行 |
| マージ済みPR | 5件 (#19, #21, #23, #25, #27) |

---

## ✨ 新機能詳細

### 1. sync-repo-tuiパッケージ (#25, #27)

**TypeScript製TUIリポジトリ同期ツール**

ReactとInkを使用したモダンなTUIツールキットとして完全に書き直されました。

#### パッケージ情報

```json
{
  "name": "@sunwood-ai-labs/sync-repo-tui",
  "version": "1.0.0",
  "type": "module",
  "bin": {
    "sync-repo-tui": "./bin/sync-repo-tui"
  }
}
```

#### アーキテクチャ

**ステートベースのTUI設計 (#27)**

`src/tui/index.tsx` に実装されたメインコントローラーは、Reactのステート管理を使用したモダンな設計になっています：

```typescript
// ステートタイプ
type AppState =
  | { type: 'loading' }
  | { type: 'envCheck'; hasEnv: boolean }
  | { type: 'githubCheck' }
  | { type: 'modeSelect' }
  | { type: 'repoConfirm'; mode: 'single' | 'org'; config: Config }
  | { type: 'repoInput'; mode: 'single' | 'org'; config: Config }
  | { type: 'orgRepoList'; config: Config; repos: string[] }
  | { type: 'syncOptions'; config: Config; repos: string[] }
  | { type: 'finalConfirm'; config: Config; repos: string[] }
  | { type: 'syncing'; config: Config; repos: string[] }
  | { type: 'done'; summary: any }
  | { type: 'error'; message: string };
```

#### モジュール構成

| モジュール | ファイル | 説明 |
|:----------|:--------|:-----|
| **CLI** | `cli.ts` | コマンドラインエントリーポイント |
| **Config** | `config/` | 設定管理（env.ts, constants.ts, index.ts） |
| **GitHub** | `github/` | GitHub API ラッパー（repo-list.ts） |
| **Sync** | `sync/` | 同期ロジック（agents.ts, git.ts, workflows.ts） |
| **TUI** | `tui/` | Ink+React製TUI画面（index.tsx, main-menu.ts, repo-selector.ts等） |
| **Utils** | `utils/` | ユーティリティ（logger.ts, error.ts, file.ts） |

#### 追加されたTUIコンポーネント (#27)

- `tui/index.tsx` - メインコントローラー（ステート管理）
- `tui/main-menu.tsx` - メインメニュー画面
- `tui/repo-selector.tsx` - リポジトリ選択画面
- `tui/sync-options.tsx` - 同期オプション設定画面
- `tui/confirmation.tsx` - 確認画面
- `tui/progress.tsx` - 進捗表示画面

---

### 2. PR自動コメントワークフロー (#19)

**PRオープン時の自動応答システム**

PRが作成されると自動的にコメントを投稿するGitHub Actionsワークフローを追加しました。

#### 実装内容

`.github/workflows/pr-auto-comment.yml`:

```yaml
on:
  pull_request:
    types: [opened]

permissions:
  contents: read
  pull-requests: write

env:
  ENABLE_PR_AUTO_COMMENT: ${{ vars.ENABLE_PR_AUTO_COMMENT || 'true' }}
  TEMPLATE_SOURCE: ${{ vars.TEMPLATE_SOURCE || 'remote' }}
  TEMPLATE_URL: ${{ vars.TEMPLATE_URL || '...' }}
```

#### 機能

- **自動トリガー**: PRオープン時に自動実行
- **スイッチ機能**: `ENABLE_PR_AUTO_COMMENT` 変数でオン/オフ制御
- **テンプレート選択**: リモートURLまたはローカルファイルからテンプレートを読み込み
- **権限設定**: 必要最小限の権限のみ付与

---

### 3. エージェント同期スクリプト (#23, #21)

**Claude Codeエージェント設定の自動同期**

#### 追加されたスクリプト

| スクリプト | 説明 |
|:----------|:-----|
| `scripts/sync-agents.sh` | エージェント設定（.claude/agents/）を複数リポジトリに同期 |
| `scripts/sync-repo-tui.sh` | sync-repo-tuiバイナリのラッパー |
| `scripts/install-sync-repo-tui.sh` | sync-repo-tuiのインストーラー |
| `scripts/sync-repo.sh` | 既存スクリプトの機能拡張（バグ修正含む） |

#### 追加されたエージェント定義 (#21)

`.claude/agents/` ディレクトリに3つのエージェント設定を追加：

- `implementer.md` - 実装担当エージェント（美咲先輩）
- `reviewer.md` - レビュー担当エージェント（玲子姐さん）
- `doc-translator.md` - ドキュメント翻訳担当エージェント（琴音）

---

## ♻️ リファクタリング詳細

### TUIをInk+Reactに移行 (#27)

**移行前（blessed）→ 移行後（Ink+React）**

#### 変更点

1. **すべてのモジュールをES Modulesに移行**
   - `config/` モジュール
   - `github/` モジュール
   - `sync/` モジュール

2. **TypeScript設定の更新**
   ```json
   {
     "compilerOptions": {
       "module": "ES2022",
       "moduleResolution": "bundler",
       "jsx": "react",
       "jsxFactory": "React.createElement"
     }
   }
   ```

3. **実行方法の変更**
   - **移行前**: Node.jsでコンパイル済みJSを実行
   - **移行後**: `tsx` でTSXを直接実行

#### メリット

- **コンポーネントベース**: ReactコンポーネントとしてUIを構築可能
- **型安全性**: TypeScript + Reactで型安全なUI開発
- **テスト容易性**: React Testing Library等のテストツールが活用可能
- **エコシステム**: npmのReactエコシステムを活用可能

---

## 🔧 バグ修正

### sync-repo.shのバグ修正 (#23)

- 重複コードの削除
- case文の論理エラーを修正

### sync-repo-tuiのバグ修正 (#25, #27)

- 変数名の重複を修正
- 論理エラーを修正
- 不要な型定義ファイルを削除

---

## 🧹 クリーンアップ (#21)

### 削除されたファイル

| ファイル | 理由 |
|:--------|:-----|
| `.github/scripts/create-pr.py` | 使用されていないPR作成スクリプト |
| `.github/workflows/disabled/MINIMAL.yml` | 無効化されたワークフロー |

### 更新されたファイル

| ファイル | 変更内容 |
|:--------|:---------|
| `.gitignore` | SourceSageアセットを追加 |
| `.SourceSageignore` | sandboxとnode_modulesを追加 |
| `.claude/rules/implementer.md` | nameフィールドを簡素化 |
| `.claude/rules/reviewer.md` | 記述を修正・整理 |

---

## 📝 ドキュメント更新

### README更新 (#27)

Ink+React移行に合わせてREADMEを更新。

### sync-repo-tuiドキュメント作成 (#25)

日本語と英語の両言語でREADMEを作成：
- `packages/sync-repo-tui/README.md`
- `packages/sync-repo-tui/README_JA.md`

---

## English

### Overview

This release includes significant enhancements and modernization of the repository synchronization tools. The major change is the migration from the blessed-based TUI to a modern architecture using **React and Ink**. We also added a GitHub Actions workflow that automatically posts comments when PRs are created.

### 📊 Change Statistics

| Item | Count |
|:-----|:------|
| Files Added | 45 |
| Lines Added | +5,224 |
| Lines Removed | -256 |
| Merged PRs | 5 (#19, #21, #23, #25, #27) |

---

## ✨ What's New Details

### 1. sync-repo-tui Package (#25, #27)

**TypeScript-based TUI Repository Synchronization Tool**

Completely rewritten as a modern TUI toolkit built with React and Ink.

#### Package Information

```json
{
  "name": "@sunwood-ai-labs/sync-repo-tui",
  "version": "1.0.0",
  "type": "module",
  "bin": {
    "sync-repo-tui": "./bin/sync-repo-tui"
  }
}
```

#### Architecture

**State-based TUI Design (#27)**

The main controller implemented in `src/tui/index.tsx` uses modern React state management:

```typescript
// State types
type AppState =
  | { type: 'loading' }
  | { type: 'envCheck'; hasEnv: boolean }
  | { type: 'githubCheck' }
  | { type: 'modeSelect' }
  | { type: 'repoConfirm'; mode: 'single' | 'org'; config: Config }
  | { type: 'repoInput'; mode: 'single' | 'org'; config: Config }
  | { type: 'orgRepoList'; config: Config; repos: string[] }
  | { type: 'syncOptions'; config: Config; repos: string[] }
  | { type: 'finalConfirm'; config: Config; repos: string[] }
  | { type: 'syncing'; config: Config; repos: string[] }
  | { type: 'done'; summary: any }
  | { type: 'error'; message: string };
```

#### Module Structure

| Module | Files | Description |
|:-------|:------|:------------|
| **CLI** | `cli.ts` | Command-line entry point |
| **Config** | `config/` | Configuration management |
| **GitHub** | `github/` | GitHub API wrapper |
| **Sync** | `sync/` | Sync logic (agents, git, workflows) |
| **TUI** | `tui/` | Ink+React TUI screens |
| **Utils** | `utils/` | Utilities (logger, error, file) |

#### Added TUI Components (#27)

- `tui/index.tsx` - Main controller (state management)
- `tui/main-menu.tsx` - Main menu screen
- `tui/repo-selector.tsx` - Repository selection screen
- `tui/sync-options.tsx` - Sync options configuration screen
- `tui/confirmation.tsx` - Confirmation screen
- `tui/progress.tsx` - Progress display screen

---

### 2. PR Auto-Comment Workflow (#19)

**Automatic Response System for PRs**

Added a GitHub Actions workflow that automatically posts comments when PRs are created.

#### Implementation

`.github/workflows/pr-auto-comment.yml`:

```yaml
on:
  pull_request:
    types: [opened]

permissions:
  contents: read
  pull-requests: write

env:
  ENABLE_PR_AUTO_COMMENT: ${{ vars.ENABLE_PR_AUTO_COMMENT || 'true' }}
  TEMPLATE_SOURCE: ${{ vars.TEMPLATE_SOURCE || 'remote' }}
  TEMPLATE_URL: ${{ vars.TEMPLATE_URL || '...' }}
```

#### Features

- **Auto Trigger**: Automatically runs on PR open
- **Switch Feature**: On/off control via `ENABLE_PR_AUTO_COMMENT` variable
- **Template Selection**: Load templates from remote URL or local file
- **Permission Settings**: Minimal required permissions only

---

### 3. Agent Sync Scripts (#23, #21)

**Automated Claude Code Agent Configuration Synchronization**

#### Added Scripts

| Script | Description |
|:-------|:------------|
| `scripts/sync-agents.sh` | Sync agent configs (.claude/agents/) to multiple repos |
| `scripts/sync-repo-tui.sh` | sync-repo-tui binary wrapper |
| `scripts/install-sync-repo-tui.sh` | sync-repo-tui installer |
| `scripts/sync-repo.sh` | Enhanced existing script (includes bug fixes) |

#### Added Agent Definitions (#21)

Added 3 agent configurations in `.claude/agents/`:

- `implementer.md` - Implementation agent (Misaki-senpai)
- `reviewer.md` - Review agent (Reiko-nee-san)
- `doc-translator.md` - Documentation translation agent (Kotone)

---

## ♻️ Refactoring Details

### TUI Migration to Ink+React (#27)

**Before (blessed) → After (Ink+React)**

#### Changes

1. **Migrated all modules to ES Modules**
   - `config/` module
   - `github/` module
   - `sync/` module

2. **Updated TypeScript configuration**
   ```json
   {
     "compilerOptions": {
       "module": "ES2022",
       "moduleResolution": "bundler",
       "jsx": "react",
       "jsxFactory": "React.createElement"
     }
   }
   ```

3. **Changed execution method**
   - **Before**: Run compiled JS with Node.js
   - **After**: Run TSX directly with `tsx`

#### Benefits

- **Component-based**: Build UI as React components
- **Type Safety**: Type-safe UI development with TypeScript + React
- **Testability**: Can use React Testing Library and other testing tools
- **Ecosystem**: Leverage npm's React ecosystem

---

## 🔧 Bug Fixes

### sync-repo.sh Bug Fixes (#23)

- Removed duplicate code
- Fixed case statement logic errors

### sync-repo-tui Bug Fixes (#25, #27)

- Fixed duplicate variable names
- Fixed logic errors
- Removed unnecessary type definition files

---

## 🧹 Cleanup (#21)

### Removed Files

| File | Reason |
|:-----|:-------|
| `.github/scripts/create-pr.py` | Unused PR creation script |
| `.github/workflows/disabled/MINIMAL.yml` | Disabled workflow |

### Updated Files

| File | Changes |
|:-----|:--------|
| `.gitignore` | Added SourceSage assets |
| `.SourceSageignore` | Added sandbox and node_modules |
| `.claude/rules/implementer.md` | Simplified name field |
| `.claude/rules/reviewer.md` | Fixed and organized descriptions |

---

## 📝 Documentation Updates

### README Update (#27)

Updated README for Ink+React migration.

### sync-repo-tui Documentation (#25)

Created bilingual README (Japanese and English):
- `packages/sync-repo-tui/README.md`
- `packages/sync-repo-tui/README_JA.md`

---

## 📦 Pull Requests Merged

| PR | Title | Description |
|:---|:------|:------------|
| #27 | ♻️ refactor(sync-repo-tui): TUIをInk+Reactに移行 | Migrated TUI from blessed to Ink+React with state-based design |
| #25 | ✨ feat(packages): sync-repo-tui パッケージ追加 | Added TypeScript TUI sync tool package with full module structure |
| #23 | ✨ feat(scripts): TUI化とエージェント同期機能追加 | Added TUI wrapper, agent sync scripts, and enhanced sync-repo.sh |
| #21 | 🔧 chore: 使用していないスクリプトを削除 | Added agent definitions, removed unused scripts and workflows |
| #19 | ✨ feat(workflow): PR自動応答トリガー追加 | Added PR auto-comment workflow with template support |

---

## 🔗 Links

- **Repository**: [claude-glm-actions-lab](https://github.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab)
- **Issues**: [GitHub Issues](https://github.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab/issues)
- **Previous Release**: [v1.0.0](https://github.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab/releases/tag/v1.0.0)

---

**Full Changelog**: https://github.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab/compare/v1.0.0...v1.1.0
