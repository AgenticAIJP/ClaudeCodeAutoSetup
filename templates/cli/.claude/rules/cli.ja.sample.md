# cli.md の使い方(人間向け解説)

CLI ツール開発で Claude が起こしがちな事故を防ぐルールです。

## なぜ stdout / stderr の分離が重要か

CLI ツールは他のコマンドとパイプでつながれます。

```bash
mytool list | grep foo   # stdout にログが混ざると grep が壊れる
```

Claude は「とりあえず console.log」で書きがちなので、明示的にルール化します。

## Before / After

✅ ルールあり → `mytool list | jq .` が動く。終了コードで CI に組み込める
❌ ルールなし → 進捗メッセージが stdout に混ざり、パイプ処理が壊れる

## カスタマイズ例

```markdown
- 引数パースは commander を使う。自前パース禁止
- カラー出力は --no-color で無効化できるようにする
- 設定ファイルは ~/.config/mytool/config.json 固定
```
