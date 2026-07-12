# typescript-native-lsp

TypeScript 7 の native 言語サーバ (tsgo) を Claude Code の LSP として使うためのプラグイン。

`command` は PATH 上の `tsc`（dotfiles の `node_modules/.bin`、devDependencies の `typescript@7`）を解決し、`tsc --lsp --stdio` で起動する。TS7 は古典的な `tsserver` を廃止したため `typescript-language-server` / `vtsls` では駆動できず、native LSP を直接起動している。

## メモリ・継続負荷チューニング (`env`)

tsgo は Go 製で、既定では `GOMAXPROCS`（全論理コア）ぶんの並列で型解析を行い、その中間結果を保持するため巨大プロジェクトで RSS と継続 CPU 負荷が大きくなりやすい。レイテンシより「消費メモリの小ささ・継続的なマシン負荷の小ささ」を優先するため、この LSP プロセスにだけ以下の Go ランタイム環境変数を渡している（グローバルに設定すると gopls / go build 等すべての Go ツールを縛るため、`lspServers.env` でスコープする）。

| 変数 | 値 | 意図 |
| --- | --- | --- |
| `GOMAXPROCS` | `2` | 並列型チェックのコア数を制限し、並列チェッカーのメモリと継続 CPU を削減 |
| `GOMEMLIMIT` | `6GiB` | RSS の soft 上限。超過時に GC を積極化してメモリを解放（低すぎると GC 過多で CPU が増えるため余裕を持たせた値） |

`GOGC` の引き下げはメモリを減らせるが GC 頻度が上がり継続 CPU 負荷が増える（方針に反する）ため採用していない。

`tsgo` は 7.1 系で並列チェッカー数を直接指定する `--checkers` / `--singleThreaded` フラグを追加予定だが、7.0.2 の LSP は未対応（`-pipe -pprofDir -socket -stdio` のみ）。そちらが安定したら env ではなくフラグ指定へ移行できる。
