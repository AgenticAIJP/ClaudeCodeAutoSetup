# Claude Code 日本語学習サイト & GitHub公益テンプレート
## プロジェクト構想メモ

> 作成日: 2026-04-17  
> 発端: iQi と Claude の対話から生まれたアイデア

---

## プロジェクト概要

**2つの柱で構成される1つのプロジェクト：**

1. **学習サイト** `code.jp.ai`
   - Claude Code の日本語公式学習チュートリアル
   - 初心者〜エンジニアまでを段階的にカバー
   - 学習リソースのURLを一覧化し、学習開始時に迷わない設計

2. **GitHub 公益テンプレート**
   - 一键で自分のプロジェクトに最適な Claude Code ディレクトリ構造を生成
   - 各ファイル・ディレクトリの役割を明文化
   - サンプルと「使うとどうなるか」の効果まで記載

---

## なぜ作るのか（動機）

**このプロジェクトの性質：**
- 完全オープンソース・非営利・寄付も受け付けない
- 作者自身が Claude Code を深く学ぶための「情報整理」が出発点
- それが誰かの役に立てば、それだけでいい

**なぜ今必要か：**
- Claude Code は毎日アップデートされているのに、入門できる人が少ない
- 公式ドキュメントは「説明書」であり、「学習サイト」ではない。体系的に学べない
- 各ファイル・ディレクトリが**何のために存在するのか**、誰も教えてくれない
- Cowork のようなツールは助けになるが、**まず構造を理解していないと使いこなせない**
- ネット上の知識はすべて**断片的**。必要なときに検索して、継ぎはぎするしかない状態
- 「どうパッチを当てるか」さえわからない人が多い。なぜなら全体像を知らないから

**このプロジェクトが解決すること：**

最初から**完全なプロジェクト構造**と**各 .md のサンプル**が手元にあれば——

- 理解できなくても AI に聞ける
- 実戦しながら、自然に全体が見えてくる
- 「なんとなくわかる」と「構造を理解した上で実戦する」は、まったく別の次元

骨格があれば、断片的な知識も正しい場所に収まる。  
このサイトが提供するのは**知識そのもの**ではなく、**知識を置く棚**だ。

**このサイトが目指すもの：**
> 迷わない。シンプル。クリーン。  
> Claude Code の「組織構造」を一目で理解できる、唯一の日本語リソース。

競合は敵ではない。Claude Code のエコシステムが強くなるほど、みんなが得をする。  
もし自分がやっていることを、誰かがもっとうまくやってくれたなら、それが一番いい。

---

## コアデザイン哲学

### `*.sample.md` 命名規則

最も重要な設計原則：

```
.claude/rules/architecture.md          ← Claude が読む。シンプルなルールのみ
.claude/rules/architecture.sample.md   ← 人間が読む。なぜ・どう使うか・効果の例
```

**メリット：**
- 困惑した場所の隣に答えがある（空間的局所性）
- README を探し回る必要がない → 「零時間」で疑問解消
- ファイルが隣にあるので、更新漏れが起きにくい
- `.claude/settings.json` の `ignorePatterns` で除外すれば、Claude のコンテキストを軽量に保てる

```json
// .claude/settings.json（実際に使う最小構成）
{
  "ignorePatterns": ["**/*.sample.md"]
}
```

> ⚠️ 注意：`.gitignore` は Git 用であり、Claude のコンテキスト制御には**無効**。  
> Claude にファイルを読ませたくない場合は、必ず `settings.json` の `ignorePatterns` を使うこと。

`settings.json` で設定できる全オプションは `settings.sample.json` を参照：

```json
// .claude/settings.sample.json（全オプション解説用）
{
  "ignorePatterns": ["**/*.sample.md", "**/node_modules/**"],

  "permissions": {
    "allow": ["Bash(git *)", "Bash(npm run *)", "Bash(npx *)"],
    "deny":  ["Bash(rm -rf *)", "Bash(curl *)", "Bash(wget *)"]
  },

  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": ".claude/hooks/pre-bash.sh" }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": ".claude/hooks/post-edit.sh" }]
      }
    ],
    "Stop": [
      {
        "hooks": [{ "type": "command", "command": ".claude/hooks/on-stop.sh" }]
      }
    ]
  },

  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "your-token-here" }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/dir"]
    }
  }
}
```

**設計原則として一言で：**
> 「ルールファイル」と「説明ファイル」は常にペアで、常に同ディレクトリ、常に同名。

---

## ディレクトリ構造案（汎用ベース）

```
Project Root/
├── .claude/                         # Claude Code の設定・境界定義
│   ├── CLAUDE.md                    # このディレクトリ専用の追加ルール（任意）
│   ├── settings.json                # プロジェクト設定（ignorePatterns・権限など）
│   ├── commands/                    # カスタムスラッシュコマンド（/refactor など）
│   │   ├── refactor.md              # /refactor コマンドの定義
│   │   └── review.md                # /review コマンドの定義
│   ├── hooks/                       # Pre/PostToolUse フック（settings.json で登録必須）
│   │   ├── pre-bash.sh              # Bash実行前に実行（settings.json で PreToolUse に登録）
│   │   ├── post-edit.sh             # ファイル編集後に実行（settings.json で PostToolUse に登録）
│   │   └── hooks.sample.md          # 登録方法・イベント種類・使用例の解説
│   ├── rules/
│   │   ├── architecture.md          # アーキテクチャ制約（Claude読み取り用）
│   │   ├── architecture.sample.md   # 説明・使い方・効果の例
│   │   ├── style.md                 # コーディング規約
│   │   └── style.sample.md
│   ├── prompts/                     # 再利用可能なプロンプトテンプレート
│   │   ├── refactor.txt
│   │   ├── refactor.sample.txt
│   │   ├── generate_test.txt
│   │   └── generate_test.sample.txt
│   └── memory.md                    # 動的コンテキスト（何が完成、次は何か）
├── docs/                            # システム設計書（Claude が全体像を理解するため）
│   ├── API_SPEC.md
│   └── DATABASE.md
├── src/                             # ソースコード
│   ├── core/                        # ビジネスロジック
│   ├── utils/                       # 共通ユーティリティ
│   └── main.ts
├── tests/                           # テスト（AI TDD に重要）
│   └── unit/
├── scripts/                         # 自動化スクリプト
│   └── setup.sh
├── tasks/                           # プロジェクト管理（人間用）
│   ├── todo.md
│   └── lessons.md                   # 失敗から学んだこと
├── .gitignore
├── CLAUDE.md                        # Claude へのプロジェクト全体説明（最重要）
└── README.md
```

---

## プロジェクト分類（テンプレートのバリエーション）

| 分類 | 対象 | 特徴 |
|------|------|------|
| 汎用ベース | 全プロジェクト共通 | 最小骨格。これが土台 |
| Web アプリ型 | 前後端分離 | frontend/ backend/ 構造 |
| API サービス型 | 純粋なバックエンド・マイクロサービス | routes/ services/ models/ |
| CLI ツール型 | コマンドラインツール | commands/ handlers/ |
| AI Agent 型 | MCP・自動化プロジェクト | agents/ skills/ tools/ |
| ドキュメント型 | 学習サイト・技術ブログ | docs/ examples/ templates/ |

---

## CLAUDE.md の三層階層システム

Claude Code は CLAUDE.md を3つのレベルで読み込む。この仕組みを知っているかどうかで、設計の自由度が大きく変わる。

```
~/.claude/CLAUDE.md              ← ① グローバル層（全プロジェクト共通）
project/CLAUDE.md                ← ② プロジェクト層（このプロジェクト専用）
project/src/payment/CLAUDE.md    ← ③ サブディレクトリ層（特定ディレクトリ専用）
```

**各層の使い分け：**

| 層 | 書くべき内容 | 例 |
|----|------------|-----|
| グローバル | 自分のスタイル・言語設定 | 「日本語で返答して」「常に tests を書いて」 |
| プロジェクト | 技術スタック・アーキテクチャ概要 | 「Next.js + TypeScript / DB は Supabase」 |
| サブディレクトリ | そのモジュール固有の制約 | 「payment/ は直接編集禁止。service 層経由のみ」 |

> 💡 Claude はカレントディレクトリから上位へ順に CLAUDE.md を読み上げる。  
> 細かいルールはサブディレクトリ層に閉じ込めることで、プロジェクト全体の CLAUDE.md を軽量に保てる。

---

## MCP（Model Context Protocol）

Claude Code を外部ツールと接続する仕組み。これを使うかどうかで Claude の「できること」が根本的に変わる。

**MCP でできること：**

| MCP サーバー | 何ができるか |
|------------|------------|
| `@modelcontextprotocol/server-github` | PR の作成・レビュー・Issue 管理 |
| `@modelcontextprotocol/server-filesystem` | 指定ディレクトリへの安全なファイルアクセス |
| `@modelcontextprotocol/server-postgres` | DB への直接クエリ |
| `@modelcontextprotocol/server-slack` | Slack メッセージの送受信 |
| カスタム MCP | 自社 API・社内ツールとの連携（自作可能） |

**設定場所：** `.claude/settings.json` の `mcpServers` フィールド（前述の `settings.sample.json` 参照）

**MCP の重要な設計原則：**
- MCP サーバーはプロジェクト単位（`settings.json`）にも、グローバル（`~/.claude/settings.json`）にも設定できる
- `permissions` の `allow/deny` リストと組み合わせて、Claude が触れる範囲を明示的に制御する
- 公益テンプレートでは「よく使う MCP の設定スニペット」を `settings.sample.json` に収録する

---

## 各ファイルの説明方針

単なる「何を書くか」だけでなく、**「書いた場合と書かない場合の Claude の反応の違い」** を示す。

例：
```markdown
## architecture.md に書いた場合

✅ Claude は deployer.js を直接修正せず、service 層を経由する
✅ Claude は「捷径」を選ばず、アーキテクチャを守る

## architecture.md がない場合

❌ Claude は最短経路でコードを書く（アーキテクチャ崩壊のリスク）
```

この「Before / After」形式が最も理解しやすい。

---

## 学習サイト（code.jp.ai）技術スタック

**設計思想：シンプル・イズ・ベスト**

| 項目 | 内容 |
|------|------|
| 形式 | 純粋な静的サイト（HTML + JSON） |
| 生成 | ShowPage.ai により自動生成・自由編集可能 |
| 更新 | ゼロ秒デプロイ（サーバーレス・ビルドなし） |
| 目的 | 学習ガイドページ。「何から始めるか」を迷わせない設計 |
| 機能 | 学習リソース一覧 + 一键プロジェクト作成（GitHub テンプレート連携） |

> 複雑なフレームワークは不要。ページ数も最小限に保ち、ユーザーが「読んだその日から Claude Code を使い始められる」ことだけに集中する。

---

## バージョン管理・CHANGELOG 方針

- **学習サイト（code.jp.ai）**: コンテンツは最小限に固定。変更は HTML を直接更新。
- **GitHub テンプレート**: バージョン管理の主戦場はここ。
  - `CHANGELOG.md` をリポジトリに配置
  - Semantic Versioning（`v1.0.0` 形式）でタグ管理
  - Claude Code のアップデートに合わせて随時リビジョンアップ
  - サイト側には「最新バージョン番号」だけ表示し、詳細は GitHub へ誘導

> サイトはシンプルに。変化の記録は GitHub に。役割を明確に分ける。

---

## 学習ロードマップ（code.jp.ai の構成案）

ユーザーが「自分はどのレベルか」を即座に判断できる3層構造。

### Level 1 — 概念理解（読むだけ・30分）
> 「Claude Code って何？どう違うの？」を解消する

- Claude Code とは何か / 通常の Claude との違い
- CLAUDE.md の役割と書き方の基本
- プロジェクト構造がなぜ重要か（Before / After 形式）
- `/init` コマンドで CLAUDE.md を自動生成する方法

### Level 2 — 実戦設定（手を動かす・1〜2時間）
> 「自分のプロジェクトで動かせる」状態にする

- `settings.json` の設定（ignorePatterns / permissions）
- カスタムスラッシュコマンドの作り方（`.claude/commands/`）
- Hooks の設定方法（`PreToolUse` / `PostToolUse` / `Stop`）
- CLAUDE.md の三層階層を使いこなす

### Level 3 — 高度な活用（本番レベル）
> 「チームで使える / 外部ツールと連携できる」状態にする

- MCP サーバーの接続（GitHub / DB / Slack など）
- Multi-agent 協調（Claude が Claude を呼び出す）
- 大規模プロジェクトでのコンテキスト管理戦略
- カスタム MCP サーバーの自作

### 公式学習リソース

| リソース | 内容 | URL |
|---------|------|-----|
| Anthropic 公式コース | Claude Code の体系的な学習 | https://anthropic.skilljar.com/ |
| 公式ドキュメント | コマンド・設定リファレンス | https://docs.anthropic.com/ja/docs/claude-code |
| GitHub テンプレート | 本プロジェクトのテンプレート | （公開後に追記） |

> サイトの役割はシンプルに：**「どこから学ぶか迷わせない」**。  
> 上記の3層を見せ、自分のレベルを選んで、一键でプロジェクトを始められる。それだけでいい。

---

## ターゲットユーザー

- **フェーズ1**: エンジニア向け（技術的な深さ重視）
- **フェーズ2**: 初心者にも使えるよう段階的に拡充
- **最終目標**: 「Claude Code を始めるなら、まずここ」と言われる場所

---

## 次のステップ

1. Claude Code 公式ドキュメントを読み込む（進行中）
2. 汎用ベーステンプレートの詳細設計
3. `*.sample.md` の内容を埋める（ShowPage での実経験を活かす）
4. GitHub リポジトリ公開
5. `code.jp.ai` にチュートリアル URL を整理・掲載

---

*「自分が必要だから作る。作ったものがみんなの役に立つ。」*
