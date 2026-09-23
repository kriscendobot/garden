---
title: The null local-node sentinel — origin and rationale
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node
---

With multiple agent public keys on one daemon, there is no single
canonical `localNodeNumber` to embed in locally-stored formula keys.
Using any specific agent's public key would create an artificial
dependency between formula storage and agent identity. This is the
problem that the **LOCAL_NODE sentinel** solves.

> *Use 64 characters of `'0'` (`'0'.repeat(64)`) as a sentinel local
> node value in locally-stored formula keys. This is analogous to how
> `0.0.0.0` works in networking — a "this host" placeholder that is
> never a valid Ed25519 public key (since the all-zeros point is not
> on the curve).*

The `0.0.0.0`-as-this-host analogy is the framing this design
*introduces* for the sentinel discipline. It is the same idea later
landed by [[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]],
but the analogy itself — and the supporting argument that
`'0'.repeat(64)` *cannot* be a valid Ed25519 key because the
all-zeros point is not on the curve — appears here first.

```js
const LOCAL_NODE = /** @type {NodeNumber} */ ('0'.repeat(64));
```
