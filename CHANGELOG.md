# Changelog

このプロジェクトのすべての重要な変更をここに記録します。
形式は [Keep a Changelog](https://keepachangelog.com/ja/1.1.0/) に、
バージョニングは [Semantic Versioning](https://semver.org/lang/ja/) に従います。

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
