---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §What-stays section — naming the negative space
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

The §What-stays subsection lists what is *not* renamed:

- `EndoWorker`, `WorkerFormula`, `WorkerInterface`,
  `provideWorker`, `mainWorker`, `nodeWorker`,
  `WorkerDeferredTaskParams` — already correct.
- Package directory `packages/daemon/` and npm name
  `@endo/daemon` — see Open Questions (the package-level still
  scoped to the daemon as a whole).
- The `endo` and `endod` CLI binaries and the literal word
  "daemon" in user-facing prose ("the Endo daemon") *where it
  does mean the long-running process* — out of scope.

The §scope-boundary-explicit discipline: the design names *what
it doesn't touch* as carefully as *what it does*. Avoids
scope-creep at review time.

The §user-facing-prose-untouched observation: prose-level
"daemon" stays. The rename targets *JS identifiers*, not the
*concept of the daemon as a long-running process* (which exists
and is real).
