---
title: "Migration discipline: no backward compatibility"
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-d256--formula-types-and-security
---

The migration **breaks** on-disk state. Three explicit notes:

- **No backward compatibility.** The migration does not maintain
  compatibility with the original 512-bit identifiers.
  > *All test users must purge their daemon state
  > (`rm -rf ~/.local/state/endo/`).*
- **Clean slate.** Fresh daemon state is assumed.
- **Future versioned identifiers.** *"Future work may introduce
  versioned formula identifiers if backward compatibility becomes
  necessary"* — explicitly deferred, not solved.

The acceptance of "purge and restart" as a migration mechanism is
itself an instance of Formula Persistence's *destruction by cohort,
reconstruction on demand* pattern at the daemon's own lifecycle
boundary: rather than write a state-conversion tool, the design
relies on the system's ability to *reconstruct from formulas* (in
this case, from no formulas — a fresh start). The OCapN-Noise
alignment removes the need to maintain two separate peer-ID schemes,
so the cost of the clean-slate migration is paid once, against a
permanent simplification.
