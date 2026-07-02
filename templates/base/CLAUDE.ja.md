# {{PROJECT_NAME}}

> このファイルは Claude Code が最初に読む「プロジェクト説明書」です。
> プロジェクトの全体像・技術スタック・守るべきルールをここに書きます。
> `<!-- TODO -->` の箇所を自分のプロジェクトに合わせて埋めてください。

## プロジェクト概要

<!-- TODO: 1〜3行で「何を作るプロジェクトか」を書く -->
{{PROJECT_NAME}} は 〇〇 のためのプロジェクトです。

## 技術スタック

<!-- TODO: 使う言語・フレームワーク・DB を書く（例: TypeScript / Next.js / Supabase） -->

- 言語:
- フレームワーク:
- データベース:

## ディレクトリ構造

```
{{PROJECT_NAME}}/
├── .claude/    # Claude Code 設定（ルール・コマンド・フック）
├── docs/       # 設計ドキュメント（Claude が全体像を理解するため）
├── src/        # ソースコード
├── tests/      # テスト
├── scripts/    # 自動化スクリプト
└── tasks/      # タスク管理（todo.md / lessons.md）
```

{{TYPE_SECTION}}

## ルール

以下のルールファイルを常に守ってください:

@.claude/rules/architecture.md
@.claude/rules/style.md

## ワークフロー

1. 作業を始める前に `tasks/todo.md` に計画を書き、確認を取る
2. 実装 → テスト実行 → 動作確認、の順で進める(検証なしで「完了」としない)
3. ミスや手戻りが起きたら、原因を `tasks/lessons.md` に記録する

## 現在の状態

@.claude/memory.md
