---
title: Agent formula updates
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, persistence, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-d256--per-agent-keypairs
---

Both `HostFormula` and `GuestFormula` gain a required `keypair` field:

```typescript
type HostFormula = {
  type: 'host';
  handle: FormulaIdentifier;
  hostHandle: FormulaIdentifier;
  keypair: FormulaIdentifier;
  worker: FormulaIdentifier;
  inspector: FormulaIdentifier;
  petStore: FormulaIdentifier;
  mailboxStore: FormulaIdentifier;
  mailHub: FormulaIdentifier;
  endo: FormulaIdentifier;
  networks: FormulaIdentifier;
  pins: FormulaIdentifier;
};

type GuestFormula = {
  type: 'guest';
  handle: FormulaIdentifier;
  keypair: FormulaIdentifier;
  hostHandle: FormulaIdentifier;
  hostAgent: FormulaIdentifier;
  petStore: FormulaIdentifier;
  mailboxStore: FormulaIdentifier;
  mailHub: FormulaIdentifier;
  worker: FormulaIdentifier;
};
```

The `keypair` field is a formula identifier (not the key material
itself) — the formula graph's normal indirection keeps the host /
guest formula JSON small and ensures keypair lifecycle is independent
of (and visible to) the agent's other dependencies.
