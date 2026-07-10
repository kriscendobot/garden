---
ts: 2026-07-10T02:38:17Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - jobs/doin/design-endo-but-for-bots-module-loading-stack-registry-mvs-snapshot-import-sequencing
---

Accepted and sequenced the M3 daemon-worker importLocation four-layer stack.
Draft PR endojs/endo-but-for-bots#659 (branch design/module-loading-stack-sequencing,
base llm, commit bf28f79b97) flips registry-capability, mvs-resolver,
snapshot-mapper, and daemon-worker-import-from-mount from Proposed to Not
Started together and makes daemon-worker-import-from-mount § Phased
Implementation the canonical dependency-ordered build plan (phases 1-4 serial
critical path: registry+MVS, mapper+worker dispatch, host method+CLI,
live-mount snapshot lifetime; phase 5 Rust drop-in and phase 6 XS are
parallel-lane follow-ups; EndoMount.snapshot(), makeFromTree, and CAS verbs
already landed, so no external gates). Reconciliation deltas closed:
workspace-root discovery assigned to the mapper layer, workspace-member
RegistryResolution entry shape pinned, mapSnapshot single-resolve contract
made explicit, Phase 2 readable-tree fixture stance disambiguated from
Phase 4. designs/README.md synced with a totals recount (145 -> 147).
Un-draft is the maintainer's call.

Self-improvement: nothing this time.
