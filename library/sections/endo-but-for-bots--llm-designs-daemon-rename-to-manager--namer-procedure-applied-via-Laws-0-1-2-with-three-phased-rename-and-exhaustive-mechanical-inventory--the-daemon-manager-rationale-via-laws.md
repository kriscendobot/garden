---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §Daemon → Manager rationale via Laws
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

Walking through the Daemon → Manager verdict:

- **Law 0**: *The orchestration layer manages formulas,
  controllers, hosts, guests, workers, and the mail hub.
  "Manager" describes that role without claiming OS-process
  semantics.*
- **Law 1**: *Grep across `packages/` for `\bManager\b` finds
  two unrelated hits: a comment header `// Manager / Entry
  Point` in `packages/lal/agent.js` and prose in `packages/fae/
  NANOBOT-ARCHITECTURE.md`. Neither is a class or interface.*
- **Law 2**: *"Manager" is a single word, no abbreviation
  needed.*
- **Antonym/dual**: *"Manager" pairs naturally with "Worker"
  ... The pair was previously fractured: `Daemon` was managing
  `Worker`s. After the rename the pair `Manager` / `Worker` is
  symmetric.*
- **Precedent**: *The Rust supervisor already uses the same word
  for the same role*.

The §antonym-dual-as-naming-criterion observation: the namer
procedure includes a *pair coherence check*. `Daemon`/`Worker`
was *fractured* (different metaphor families); `Manager`/
`Worker` is symmetric. The §pair-coherence-matters discipline.
