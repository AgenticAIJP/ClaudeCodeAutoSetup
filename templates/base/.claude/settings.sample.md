# settings.json とは何か(人間向け解説)

> 隣の `settings.json` は Claude Code の「プロジェクト設定」です。
> このファイル(*.sample.md)は人間向けの解説で、Claude には読ませません
> (`permissions.deny` の `Read(./**/*.sample.md)` で除外済み)。

## 各フィールドの意味

### `$schema`

エディタ(VS Code など)で自動補完と検証が効くようになります。書いておくだけで得。

### `permissions.allow` — 確認なしで許可する操作

```json
"allow": ["Bash(npm run *)", "Bash(git diff *)"]
```

毎回「実行していいですか?」と聞かれたくない安全なコマンドを登録します。

### `permissions.deny` — 禁止する操作

```json
"deny": ["Read(./.env)", "Bash(rm -rf *)"]
```

- `Read(./.env)` → Claude は .env を**読めなくなる**(秘密情報の保護)
- `Read(./**/*.sample.md)` → 解説ファイルを読ませない = **コンテキスト節約**
- `Bash(rm -rf *)` → 破壊的コマンドの禁止

> ⚠️ 古い記事にある `ignorePatterns` は**廃止されました**。
> 「Claude に読ませない」は現在 `permissions.deny` の `Read(...)` ルールで行います。
>
> ⚠️ `.gitignore` は Git 用であり、Claude の読み取り制御には**効きません**。

### `hooks` — ツール実行の前後に自動でスクリプトを走らせる

このテンプレートでは2つ登録済み:

| フック | タイミング | やること |
|--------|-----------|---------|
| `pre-bash.sh` | Bash 実行の直前 | 危険なコマンドをブロック |
| `post-edit.sh` | ファイル編集の直後 | 自動フォーマット |

詳しくは `.claude/hooks/hooks.sample.md` を参照。

## MCP サーバーはどこに書く?

プロジェクト共有の MCP サーバーは settings.json ではなく、
**プロジェクトルートの `.mcp.json`** に書きます(例はルートの `.mcp.sample.json`)。

## 書いた場合 / 書かない場合

✅ settings.json がある → .env を読まれない・危険コマンドが止まる・毎回の許可確認が減る
❌ ない → 全操作が都度確認になり遅い。秘密ファイルも Claude の目に入りうる
