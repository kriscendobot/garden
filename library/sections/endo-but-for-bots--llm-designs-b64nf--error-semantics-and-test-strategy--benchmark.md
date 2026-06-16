---
title: Benchmark
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

`test/_bench-main.js` already compares `encodeBase64` (dispatched)
against `jsEncodeBase64` (direct). On a runtime with the native
intrinsic, the dispatched function exercises the native code path,
and the benchmark measures native-vs-JS throughput directly. The
NEWS entry uses those numbers to justify the change.
