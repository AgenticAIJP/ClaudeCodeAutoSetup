# hooks とは何か(人間向け解説)

> hooks は「Claude のツール実行の前後に、自動でスクリプトを走らせる」仕組みです。
> **スクリプトを置くだけでは動きません。** `.claude/settings.json` への登録が必須です。

## このテンプレートで登録済みのフック

| ファイル | イベント | 対象 | 動作 |
|---------|---------|------|------|
| `pre-bash.sh` | PreToolUse | Bash | 危険コマンド(`rm -rf /` 等)をブロック |
| `post-edit.sh` | PostToolUse | Edit / Write | 編集後に Prettier で自動フォーマット |

## 登録方法(settings.json)

```json
"hooks": {
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [{ "type": "command", "command": "bash .claude/hooks/pre-bash.sh" }]
    }
  ]
}
```

## 主なイベント

| イベント | タイミング | 典型的な用途 |
|---------|-----------|-------------|
| `PreToolUse` | ツール実行の直前 | 危険操作のブロック・監査ログ |
| `PostToolUse` | ツール実行の直後 | 自動フォーマット・lint・テスト |
| `Stop` | Claude の応答完了時 | 通知音・ビルド実行 |
| `SessionStart` | セッション開始時 | 環境チェック・コンテキスト注入 |

## 仕組みの要点

- フックは **stdin から JSON** を受け取る(ツール名・引数など)
- `PreToolUse` で **exit 2** すると、そのツール実行はブロックされる
  (stderr に書いた内容が Claude に理由として渡る)
- exit 0 は「問題なし、続行」

## Before / After

✅ pre-bash.sh がある → `git push --force` を打とうとしても直前で止まる
❌ ない → 「お願いだから force push しないで」と祈るしかない

ルール(CLAUDE.md)は「お願い」、hooks は「強制」。確実に守らせたいものは hooks へ。
