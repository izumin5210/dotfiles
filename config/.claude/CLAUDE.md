## Conversation Guidelines

- 常に日本語で会話する
- 不明点があれば実装する前に質問する
- わからない時に一時的な解決策で凌ぐのは絶対にやめてください

## Coding Guidelines

- 余計な自明なコードコメントは残さない

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

## Documentation

- Use `z/` directory for temporary markdown documents (git-ignored)
- Follow handbook-first approach with SDS (Summary-Details-Summary) structure
- Use CTRT topic types: Concept, Task, Reference, Troubleshooting