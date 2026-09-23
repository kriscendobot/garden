---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §wire-protocol-coordination-window
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

> *The exo tag `'EndoDaemonFacetForWorker'` appears in CapTP
> traffic between manager and worker. Since both endpoints ship
> in the same package and the same release, there is no
> protocol-version skew.*

The §coordinated-rename-because-coordinated-deployment
discipline: the rename touches a *wire-visible identifier* —
which would normally require a deprecation window — but because
both endpoints *ship together*, the rename is *atomic at the
release boundary*. §atomic-rename-when-deployment-is-atomic.

The §protocol-version-skew distinction matters elsewhere in the
@endo project where producers and consumers ship in *different*
packages or different release cadences. Here, *they don't*, so
the constraint relaxes.
