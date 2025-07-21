## Conversation Guidelines

- 常に日本語で会話する
- 不明点があれば実装する前に質問する

## Coding Guidelines

- 余計な自明なコードコメントは残さない

## Editorconfig

- insert_final_newline = true
- trim_trailing_whitespace = true

## Git Commit

- コミットメッセージの下に利用したプロンプトを `prompt: ` から始めて書いてください

## Development Philosophy

### Test-Driven Development (TDD)

- 原則としてテスト駆動開発（TDD）で進める
- 期待される入出力に基づき、まずテストを作成する
- 実装コードは書かず、テストのみを用意する
- テストを実行し、失敗を確認する
- テストが正しいことを確認できた段階でコミットする
- その後、テストをパスさせる実装を進める
- 実装中はテストを変更せず、コードを修正し続ける
- すべてのテストが通過するまで繰り返す
