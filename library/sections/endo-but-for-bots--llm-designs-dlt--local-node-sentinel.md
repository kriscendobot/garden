---
title: LOCAL_NODE sentinel — agent-independent internal storage
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
kind: index
section_count: 4
---

Each `EndoAgent` (host, guest) on a daemon has its own Ed25519
keypair. When an agent emits a locator, it stamps the locator with
its *own* public key as the peer. But internally, formula storage uses
a single sentinel — **`LOCAL_NODE`** — in place of any local agent's
key. This is the daemon-wide pattern that makes per-agent identities
externally visible without duplicating internal state.

```js
const LOCAL_NODE = '0'.repeat(64);  // never a valid Ed25519 public key
```

Three properties fall out:

1. **One copy per formula.** Regardless of which agent created or
   views a formula, the internal identifier uses the same `LOCAL_NODE`
   peer-key suffix. The pet stores and the formula graph see one
   entry per local formula, never N entries (one per agent).
2. **Agent-independent storage.** Agents can be created and destroyed
   without rewriting any internal formula identifiers — `LOCAL_NODE`
   does not change.
3. **Per-agent externalization.** Each agent stamps outgoing locators
   with its *own* public key so the recipient knows which peer to
   contact (and so different agents on the same daemon present
   different locators for the same value — visible identity, hidden
   shared storage).

Sections:

- [The `localKeys` set](endo-but-for-bots--llm-designs-dlt--local-node-sentinel--the-localkeys-set.md)
- [Internalize / externalize](endo-but-for-bots--llm-designs-dlt--local-node-sentinel--internalize-externalize.md)
- [Database repair](endo-but-for-bots--llm-designs-dlt--local-node-sentinel--database-repair.md)
- [See also](endo-but-for-bots--llm-designs-dlt--local-node-sentinel--see-also.md)
