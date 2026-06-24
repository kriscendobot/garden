---
title: Formula changes
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets
---

```typescript
// GuestFormula gains a networks field:
interface GuestFormula {
  type: 'guest';
  // ... existing fields ...
  networks: FormulaIdentifier;  // NEW: per-guest networks directory
}

// HostFormula already has networks — no change needed.
```

(See [[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] for
the existing `HostFormula` / `GuestFormula` shapes; this design adds
one field to `GuestFormula`.)
