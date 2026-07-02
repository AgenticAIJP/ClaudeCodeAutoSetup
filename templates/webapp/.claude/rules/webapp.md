# Webアプリ型ルール

- frontend から DB へ直接アクセスしない。必ず backend の API 経由
- API の境界(リクエスト/レスポンス型)を変える場合は、frontend と backend を同じ変更で更新する
- frontend の状態管理に API レスポンスをそのまま入れない。表示用の型に変換する
- backend のビジネスロジックはルーティング層に書かない。service 層に置く
- 環境変数は frontend / backend で明確に分離する(frontend に秘密情報を渡さない)
