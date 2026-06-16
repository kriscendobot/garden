---
section: three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline
source: endo-but-for-bots--llm-designs-app-sharing-milestone
topics: [daemon, agent-conventions, chat-ui]
status: current
title: The §four-phase plan with §explicit-exit-criteria
parent: endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline
---

The Phased Plan section gives **four phases** with
*per-phase exit criteria*:

| Phase | Pillar | Exit |
|-------|--------|------|
| **P0** | 1 (installer) | non-developer downloads/installs/launches a signed/notarized Familiar on macOS arm64 without Gatekeeper warnings |
| **P1** | 2 (deep-link) | clicking `endo://invite/…` in another app opens Familiar, shows who is being added, asks for pet name, binds the peer |
| **P2** | 3a + 3b (app handle + sandboxed UI) | user runs an endo-fs/`make-from-tree` app, opens its partially-sandboxed UI in a Chat pane, and shares a remote reference to a peer who opens the same UI |
| **P3** | 3c (clone & share) | peer receiving a cloneable app chooses "Make my own copy", gets an independent local instance under their own powers, that keeps working after the author disconnects |

The §exit-criterion-per-phase discipline: each phase is *done
when the user can do the exit action*, not when some
engineering metric is satisfied. The §user-flow-as-completion-
gate.

The §P3-honors-cloneable-policy detail: *no per-blob hashing;
integrity is the transport's job*. The §transport-handles-
integrity discipline keeps clone simple — the OCapN-Noise
transport (cycle 41-49's earlier ocapn-noise-network design)
already provides cryptographic integrity at the wire layer;
the clone-protocol doesn't reinvent it.
