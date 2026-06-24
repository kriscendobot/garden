---
title: "Formula numbers: 256-bit random"
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
// daemon-node-powers.js
const randomHex256 = () =>
  new Promise((resolve, reject) =>
    crypto.randomBytes(32, (err, bytes) => {
      if (err) {
        reject(err);
      } else {
        resolve(bytes.toString('hex'));
      }
    }),
  );
```

Used everywhere a formula number is generated for a non-content-
addressed formula (the formula graph's per-formula nonces).
