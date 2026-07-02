# ClaudeCodeAutoSetup — v1.0 実装計画

> 目標: ①一键生成CLI ②Homepage (GitHub Pages) ③GitHub公開
> 方針: コードは英語 / 表示・ドキュメントは日本語

## 最終構成

```
repo root (ClaudeCodeAutoSetup)/
├── setup.sh                  # 対話式CLI（bash・依存ゼロ）
├── templates/
│   ├── base/                 # 汎用ベース（全タイプの土台）
│   ├── webapp/               # Webアプリ型 overlay
│   ├── api/                  # APIサービス型 overlay
│   ├── cli/                  # CLIツール型 overlay
│   ├── agent/                # AI Agent型 overlay
│   └── docs-site/            # ドキュメント型 overlay
├── docs/                     # Homepage (GitHub Pages → code.jp.ai)
│   └── index.html
├── tasks/                    # このリポジトリ自身の管理
├── README.md                 # 日本語・使い方
├── CHANGELOG.md              # v1.0.0
├── CLAUDE.md / LICENSE       # 既存維持
```

## Todo

- [x] 1. templates/base/ — 汎用ベーステンプレート一式
      - CLAUDE.md（プレースホルダ付き雛形）
      - .claude/settings.json + settings.sample.json
      - .claude/rules/{architecture,style}.md + .sample.md（Before/After形式）
      - .claude/commands/{refactor,review}.md
      - .claude/hooks/{pre-bash.sh,post-edit.sh} + hooks.sample.md
      - .claude/prompts/{refactor,generate_test}.txt + .sample.txt
      - .claude/memory.md
      - docs/ src/ tests/ scripts/ tasks/{todo,lessons}.md .gitignore README.md
- [x] 2. templates/{webapp,api,cli,agent,docs-site}/ — 各タイプoverlay
      （追加ディレクトリ + タイプ固有 rules/CLAUDE.md 追記分）
- [x] 3. setup.sh — 対話式CLI
      - タイプ選択(1-6) → プロジェクト名入力 → base+overlayコピー → 次の一歩を表示
      - ローカル実行 と curl|bash（GitHubからtarball取得）両対応
- [x] 4. docs/index.html — Homepage（日本語・静的1ページ）
      - コンセプト / 一行インストールコマンド / 6タイプ紹介 / 学習ロードマップ3層 / GitHubリンク
- [x] 5. README.md 書き直し + CHANGELOG.md v1.0.0
- [x] 6. 検証 — sandbox で setup.sh を全6タイプ実行、生成結果を確認
- [x] 7. git commit & push → GitHub Pages 有効化の手順案内

## Review

**2026-07-02 完了 (v1.0.0)**

- setup.sh: 対話式 + 非対話式(`./setup.sh <1-6> <name>`) + curl|bash 対応。
  全6タイプで生成テスト済み(プレースホルダ置換・メタファイル除去・
  hooks 実行権限・settings.json 妥当性・不正名/重複名の拒否を確認)
- hooks 動作テスト済み: pre-bash.sh が `git push --force` を exit 2 でブロック
- 公式ドキュメント照合による設計修正2点:
  1. `ignorePatterns` は廃止 → `permissions.deny` の `Read(...)` ルールを採用
  2. プロジェクト共有 MCP は settings.json ではなく `.mcp.json`(ルート)に配置
- 残タスク: GitHub Pages 有効化(Settings → Pages → main /docs)、
  code.jp.ai ドメインの割り当て
