---
title: Validation patterns
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers
---

```js
// formula-identifier.js
const numberPattern = /^[0-9a-f]{64}$/;
const idPattern = /^(?<number>[0-9a-f]{64}):(?<node>[0-9a-f]{64})$/;
```

64 chars, lowercase hex only. The patterns are the only gate between
"parsed identifier" and "string of plausible-looking hex" — any
upstream layer that constructs identifiers passes through these
regexes.
