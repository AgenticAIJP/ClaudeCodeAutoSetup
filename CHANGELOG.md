# Changelog

このプロジェクトのすべての重要な変更をここに記録します。
形式は [Keep a Changelog](https://keepachangelog.com/ja/1.1.0/) に、
バージョニングは [Semantic Versioning](https://semver.org/lang/ja/) に従います。

## [1.1.0] - 2026-07-03

### Added

- **日英二言語対応 / Full bilingual support (Japanese & English)**
  - setup.sh に言語選択を追加(対話式 + 第3引数 `ja|en`)。UI メッセージも選択言語で表示
  - Claude が読むファイル(CLAUDE.md / rules / commands 等)はテンプレート内で
    `X.ja.md` / `X.en.md` として管理し、生成時に選択言語の1つだけを `X.md` に解決
    (Claude のコンテキストを単一言語に保つ)
  - 人間向け解説は両言語を**並べて**配置: `settings.ja.sample.md` / `settings.en.sample.md`
    (英語話者・日本語話者それぞれが、困った場所の隣で自分の言語の解説を見つけられる)
  - Homepage (docs/index.html) に 日本語/EN 切り替えを追加(ブラウザ言語で自動初期選択)
  - README.md を英語化し、README.ja.md(日本語版)を追加

### Changed

- `permissions.deny` の sample 除外パターンを `*.sample.md` → `*.sample.*` に拡大
  (`.mcp.sample.json` や `*.sample.txt` もカバー)

## [1.0.0] - 2026-07-02

### Added

- `setup.sh` — 対話式プロジェクト生成CLI(curl | bash 対応・非対話モードあり)
- 6種類のプロジェクトテンプレート: 汎用ベース / Webアプリ型 / APIサービス型 / CLIツール型 / AI Agent型 / ドキュメント型
- `*.sample.md` 命名規則 — 全設定ファイルの隣に人間向け解説をペア配置
- `.claude/` 一式: settings.json(最新の permissions 形式) / rules / commands / hooks / prompts / memory.md
- hooks 実装例: pre-bash.sh(危険コマンドブロック) / post-edit.sh(自動フォーマット)
- `.mcp.sample.json` — MCP サーバー設定例(GitHub / filesystem / postgres)
- `docs/index.html` — 学習サイト(code.jp.ai 用・GitHub Pages 対応)

### Notes

- 旧 `ignorePatterns` は使用していません(廃止済み)。Claude に読ませないファイルは
  `permissions.deny` の `Read(...)` ルールで制御しています。
- プロジェクト共有の MCP 設定は settings.json ではなく `.mcp.json`(ルート)に置く方式です。
