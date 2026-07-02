# ClaudeCodeAutoSetup

[English](README.md) | **日本語**

> Claude Code プロジェクトを、コマンド一発で正しく始める。
> 迷わない。シンプル。クリーン。

Claude Code に最適なディレクトリ構造・設定ファイル一式を自動生成するツールです。
すべての設定ファイルの**隣に人間向けの解説(`*.ja.sample.md` / `*.en.sample.md`)** が付くので、
「このファイルは何のためにあるのか」を探し回る必要がありません。

🌐 学習サイト: [code.jp.ai](https://code.jp.ai)(準備中)
📦 完全オープンソース・非営利・MIT License・日本語 / English

## 使い方

### 一番かんたんな方法(クローン不要)

```bash
curl -fsSL https://raw.githubusercontent.com/AgenticAIJP/ClaudeCodeAutoSetup/main/setup.sh | bash
```

質問は3つだけ:

1. 言語 — 日本語 / English
2. プロジェクトのタイプ(1〜6 の番号)
3. プロジェクト名

### クローンして使う

```bash
git clone https://github.com/AgenticAIJP/ClaudeCodeAutoSetup.git
cd ClaudeCodeAutoSetup
./setup.sh
```

### 非対話モード(スクリプト・CI 用)

```bash
./setup.sh 3 my-api-project ja   # タイプ3(API)・日本語でプロジェクト生成
./setup.sh 5 my-agent en        # タイプ5(AI Agent)・英語でプロジェクト生成
```

## 6つのプロジェクトタイプ

| # | タイプ | 向いているもの | 特徴的な構造 |
|---|--------|--------------|-------------|
| 1 | 汎用ベース | まず迷ったらこれ | `src/ tests/ docs/ tasks/` |
| 2 | Webアプリ型 | 前後端分離のWebアプリ | `frontend/ backend/` |
| 3 | APIサービス型 | バックエンド・マイクロサービス | `routes/ services/ models/` + API仕様書 |
| 4 | CLIツール型 | コマンドラインツール | `commands/ handlers/` |
| 5 | AI Agent型 | MCP・自動化プロジェクト | `agents/ skills/ tools/` + MCP設定例 |
| 6 | ドキュメント型 | 学習サイト・技術ブログ | `docs/ examples/ templates/` + 記事雛形 |

## 生成されるもの(汎用ベースの例)

```
my-project/
├── CLAUDE.md                        # Claude への「プロジェクト説明書」(最重要)
├── .claude/
│   ├── settings.json                # 権限・フック設定(解説: settings.ja.sample.md)
│   ├── rules/                       # アーキテクチャ・コーディング規約
│   │   ├── architecture.md          #   ← Claude が読む
│   │   ├── architecture.ja.sample.md#   ← あなたが読む(なぜ・使い方・効果)
│   │   └── architecture.en.sample.md#   ← 英語話者のチームメイトが読む
│   ├── commands/                    # /refactor /review カスタムコマンド
│   ├── hooks/                       # 危険コマンドのブロック・自動フォーマット
│   ├── prompts/                     # コピペ用プロンプトテンプレート
│   └── memory.md                    # セッションをまたぐ動的コンテキスト
├── .mcp.sample.json                 # MCP サーバー設定例(GitHub / DB など)
├── docs/  src/  tests/  scripts/
└── tasks/                           # todo.md(計画) / lessons.md(失敗の記録)
```

## 二言語対応のしくみ

- **Claude が読むファイル**(CLAUDE.md・rules・commands など)は、セットアップ時に
  選んだ**1言語だけ**で生成されます。Claude のコンテキストを単一言語でクリーンに保つためです。
- **人間が読むファイル**(`*.sample.*`)は**日英両方が並んで**配置されます。
  英語話者も日本語話者も、困ったその場所で自分の言語の解説を見つけられます:

```
.claude/rules/architecture.md              ← Claude が読む(ルール本体)
.claude/rules/architecture.ja.sample.md    ← 日本語の解説
.claude/rules/architecture.en.sample.md    ← English guide
```

sample ファイルは `permissions.deny` の `Read(./**/*.sample.*)` で除外済みなので、
Claude のコンテキストを一切消費しません。

## よくある質問

**Q. 公式の `/init` と何が違う?**
`/init` は既存コードから CLAUDE.md を1枚生成します。本ツールは rules / hooks /
commands / タスク管理まで含む「開発体制ごと」の骨格を、解説付きで生成します。
併用がおすすめ: 本ツールで骨格を作り、`/init` で CLAUDE.md を育てる。

**Q. 生成後にタイプを変えたくなったら?**
`.claude/rules/` に他タイプのルールを足すだけです。構造は自由に育ててください。

**Q. Windows では使える?**
Git Bash または WSL 上で動作します。

## コントリビュート

Issue / PR 歓迎です。このプロジェクトは完全非営利で、寄付も受け付けていません。
Claude Code のエコシステムが強くなるほど、みんなが得をする——それだけです。

## License

[MIT](LICENSE)
