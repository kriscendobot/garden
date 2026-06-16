---
title: The `name` parameter on the native path
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, testing]
status: current
parent: endo-but-for-bots--llm-designs-b64nf--error-semantics-and-test-strategy
---

`jsDecodeBase64(string, name?)` accepts an optional `name` argument
that appears in error messages. The native intrinsic does not accept
a name. Under option 1, **the argument is silently ignored on the
native path**, matching the current JS path's tolerance of extra
arguments. The function signature remains `(string, name?) →
Uint8Array` so no caller becomes a type error. The design notes
this could become a formal deprecation in a future major version.
