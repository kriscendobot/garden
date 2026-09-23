---
source: designs/daemon-endor-architecture.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endor-architecture.md
source_path: designs/daemon-endor-architecture.md
source_branch: llm
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - hardened-javascript
genre: §endo-but-for-bots-design
cycle: 176
lane: designs
status: current
title: §Pool-of-machine-runner-threads
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

> *The daemon spawns a fixed pool of runner threads at
> startup (`ENDO_MACHINE_THREADS`, default = number of
> CPUs). Each runner thread hosts an event loop that
> drives one or more XS machines cooperatively.*

§XS-Machine-is-!Send-+-!Sync — each machine §pinned-to-a-
single-OS-thread for its lifetime.

§The-daemon-doesn't-create-a-new-thread-per-machine:
§one-runner-thread-can-host-many-machines.

§Cooperative-scheduling: §machines-yield-at-envelope-
boundaries. §JS-execution-within-one-dispatch-+-run-
promise-jobs-cycle-runs-to-completion.

§Risk: §a-CPU-bound-JS-computation-blocks-all-machines-
on-the-same-runner-thread. §Acceptable-trade-off-for-
shared-mode.

§Round-robin-or-least-loaded assignment of new machines
to runner threads.
