<img src="https://raw.githubusercontent.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab/main/assets/release-header-v1.1.0.svg" alt="v1.1.0 Release"/>

# v1.1.0 - TUI Modernization & Repository Sync Enhancement / TUIモダン化とリポジトリ同期機能強化

**リリース日 / Release Date:** 2026-01-29

---

## 日本語 / Japanese

### 概要
本リリースでは、リポジトリ同期ツールの大幅な機能強化とモダナイゼーションを実施しました。最大の変更点は、blessedベースの旧TUIからReactとInkを使用したモダンなアーキテクチャへの移行です。また、GitHub Actionsワークフローの自動応答機能も追加しました。

### 📊 変更統計
- **追加ファイル**: 45個
- **追加コード**: +5,224行
- **削除コード**: -256行
- **マージ済みPR**: 5件 (#19, #21, #23, #25, #27)

---

### ✨ 主な新機能

#### 1. sync-repo-tuiパッケージの追加 (#25)
**TypeScript製TUIリポジトリ同期ツール**

ReactとInkを使用したモダンなTUIツールキットを新規追加しました。

**パッケージ構成:**
```
@sunwood-ai-labs/sync-repo-tui@1.0.0
├── src/
│   ├── cli.ts           # CLIエントリーポイント
│   ├── config/          # 設定管理 (env.ts, constants.ts)
│   ├── github/          # GitHub APIラッパー
│   ├── sync/            # 同期ロジック (agents.ts, git.ts, workflows.ts)
│   ├── tui/             # Ink+React製TUI画面
│   └── utils/           # ユーティリティ (logger.ts, error.ts, file.ts)
├── bin/sync-repo-tui    # 実行可能バイナリ
└── 約870行のTypeScriptコード
```

**機能:**
- 複数リポジトリのワークフロー同期
- エージェント設定の同期
- インタラクティブなターミナルUI
- GitHub API認証対応

#### 2. PR自動コメントワークフロー (#19)
**PRオープン時の自動応答システム**

GitHub Actionsワークフローを追加し、PR作成時に自動的にコメントを投稿する機能を実装しました。

**追加ファイル:**
- `.github/workflows/pr-auto-comment.yml`

**機能:**
- PRオープン時の自動応答トリガー
- スイッチ機能によるオン/オフ制御
- 権限設定の改善

#### 3. エージェント同期スクリプト (#23)
**エージェント設定の自動同期**

Claude Codeのエージェント設定を複数リポジトリ間で同期するスクリプトを追加しました。

**追加ファイル:**
- `scripts/sync-agents.sh`
- `scripts/sync-repo-tui.sh`
- `scripts/install-sync-repo-tui.sh`

---

### ♻️ リファクタリング

#### TUIをInk+Reactに移行 (#27)
**モダンなUIアーキテクチャへの刷新**

- **移行前**: blessed（Node.js用TUIライブラリ）
- **移行後**: Ink + React（ReactコンポーネントでTUIを構築）

**変更されたモジュール:**
- `config/` - ES Modules対応
- `github/` - ES Modules対応
- `sync/` - ES Modules対応
- `tui/` - Reactコンポーネント化

**メリット:**
- コンポーネントベースの再利用可能なUI
- Reactエコシステムの活用
- 型安全性の向上
- テスト容易性の向上

---

### 🔧 バグ修正

- **sync-repo.sh**: 重複コードとcase文のバグを修正 (#23)
- **sync-repo-tui**: 変数名の重複と論理エラーを修正 (#25)
- **依存関係**: 不要な型定義ファイルを削除 (#27)

---

### 🧹 クリーンアップ (#21)

**削除されたファイル:**
- `.github/scripts/create-pr.py` - 使用されていないPR作成スクリプト
- `.github/workflows/disabled/MINIMAL.yml` - 無効化されたワークフロー

**更新されたファイル:**
- `.gitignore` - SourceSageアセットを追加
- `.SourceSageignore` - sandboxとnode_modulesを追加

---

### 📝 ドキュメント更新

- **README**: Ink+React移行に合わせて更新 (#27)
- **sync-repo-tui/README.md**: 日本語・英語の両言語でドキュメント作成 (#25)

---

## English

### Overview
This release includes significant enhancements and modernization of the repository synchronization tools. The major change is the migration from the blessed-based TUI to a modern architecture using React and Ink. We also added an automatic response feature for GitHub Actions workflows.

### 📊 Change Statistics
- **Files Added**: 45
- **Lines Added**: +5,224
- **Lines Removed**: -256
- **Merged PRs**: 5 (#19, #21, #23, #25, #27)

---

### ✨ What's New

#### 1. sync-repo-tui Package (#25)
**TypeScript-based TUI Repository Synchronization Tool**

Added a modern TUI toolkit built with React and Ink.

**Package Structure:**
```
@sunwood-ai-labs/sync-repo-tui@1.0.0
├── src/
│   ├── cli.ts           # CLI entry point
│   ├── config/          # Configuration management
│   ├── github/          # GitHub API wrapper
│   ├── sync/            # Sync logic (agents, git, workflows)
│   ├── tui/             # Ink+React TUI screens
│   └── utils/           # Utilities (logger, error, file)
├── bin/sync-repo-tui    # Executable binary
└── ~870 lines of TypeScript
```

**Features:**
- Multi-repository workflow synchronization
- Agent configuration synchronization
- Interactive terminal UI
- GitHub API authentication support

#### 2. PR Auto-Comment Workflow (#19)
**Automatic Response System for PRs**

Added a GitHub Actions workflow that automatically posts comments when PRs are created.

**Added Files:**
- `.github/workflows/pr-auto-comment.yml`

**Features:**
- Automatic response trigger on PR open
- On/off control via switch feature
- Improved permission settings

#### 3. Agent Sync Scripts (#23)
**Automated Agent Configuration Synchronization**

Added scripts to synchronize Claude Code agent configurations across multiple repositories.

**Added Files:**
- `scripts/sync-agents.sh`
- `scripts/sync-repo-tui.sh`
- `scripts/install-sync-repo-tui.sh`

---

### ♻️ Refactoring

#### TUI Migration to Ink+React (#27)
**Modern UI Architecture Refresh**

- **Before**: blessed (Node.js TUI library)
- **After**: Ink + React (Building TUI with React components)

**Migrated Modules:**
- `config/` - ES Modules support
- `github/` - ES Modules support
- `sync/` - ES Modules support
- `tui/` - React componentization

**Benefits:**
- Component-based reusable UI
- React ecosystem utilization
- Improved type safety
- Better testability

---

### 🔧 Bug Fixes

- **sync-repo.sh**: Fixed duplicate code and case statement bugs (#23)
- **sync-repo-tui**: Fixed duplicate variable names and logic errors (#25)
- **Dependencies**: Removed unnecessary type definition files (#27)

---

### 🧹 Cleanup (#21)

**Removed Files:**
- `.github/scripts/create-pr.py` - Unused PR creation script
- `.github/workflows/disabled/MINIMAL.yml` - Disabled workflow

**Updated Files:**
- `.gitignore` - Added SourceSage assets
- `.SourceSageignore` - Added sandbox and node_modules

---

### 📝 Documentation Updates

- **README**: Updated for Ink+React migration (#27)
- **sync-repo-tui/README.md**: Created bilingual documentation (Japanese/English) (#25)

---

## 📦 Pull Requests Merged

| PR | Title | Description |
|:---|:------|:------------|
| #27 | ♻️ refactor(sync-repo-tui): TUIをInk+Reactに移行 | Migrated TUI from blessed to Ink+React |
| #25 | ✨ feat(packages): sync-repo-tui パッケージ追加 | Added TypeScript TUI sync tool package |
| #23 | ✨ feat(scripts): TUI化とエージェント同期機能追加 | Added TUI wrapper and agent sync scripts |
| #21 | 🔧 chore: 使用していないスクリプトを削除 | Removed unused scripts and workflows |
| #19 | ✨ feat(workflow): PR自動応答トリガー追加 | Added PR auto-comment workflow |

---

## 🔗 Links

- **Repository**: [claude-glm-actions-lab](https://github.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab)
- **Issues**: [GitHub Issues](https://github.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab/issues)
- **Previous Release**: [v1.0.0](https://github.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab/releases/tag/v1.0.0)

---

**Full Changelog**: https://github.com/Sunwood-AI-OSS-Hub/claude-glm-actions-lab/compare/v1.0.0...v1.1.0
