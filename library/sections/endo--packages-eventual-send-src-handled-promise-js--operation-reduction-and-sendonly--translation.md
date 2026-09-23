---
title: Translation
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "122-194"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "How dispatchToHandler reduces the six-operation API to a three-method minimum, and why SendOnly is a wrapper around the corresponding non-SendOnly operation"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, captp]
status: current
parent: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly
---

| Shim term | Handler-implementer term |
| --------- | ----------------------- |
| `get` | property access (`E(target).prop` or `E.get(target, prop)`) |
| `applyMethod` | method call (`E(target).method(args)`) |
| `applyFunction` | function call against a callable presence |
| `*SendOnly` | fire-and-forget variant; no answer slot reserved |
| `returnedP` | the promise the *caller* is awaiting; the handler may resolve it directly, or let the shim resolve it from the operation's return value |
| `o` | the resolved (or pending) target the handler is dispatching against |
| `opArgs` | operation-specific argument tuple; for `applyMethod` it is `[prop, args]`, for `applyFunction` it is `[args]`, for `get` it is `[prop]` |

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L122-L194) at commit `ec42cb7b`.
