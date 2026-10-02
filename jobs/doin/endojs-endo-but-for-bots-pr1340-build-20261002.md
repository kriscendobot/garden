---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-02T16:41:11Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Implement the confined-application-makers design (endojs/endo-but-for-bots#1340)

kriskowal approved design PR https://github.com/endojs/endo-but-for-bots/pull/1340
("docs(designs): agent makers for confined applications",
`designs/agent-confined-application-makers.md`) and asked to "conduct and
build." This job is the build half — a separate conductor job merges the
design PR itself; build the implementation it specifies on the normal
implementation base, per `skills/pr-creation-flow/SKILL.md` § Designs versus
implementations (don't combine design and implementation in one PR).

Read the merged `designs/agent-confined-application-makers.md` (and its
refs, #1339/#1336) for the landed decisions: makers from a bundle, an
archive, or a tree/mount, with or without `node_modules` in situ or a
pre-generated `compartment-map.json`; every source reaches the worker as
compartment-mapper archive bytes via the existing `makeArchive`; the
archive/bundle/tree-read-powers mechanics the design spells out in detail.
Implement exactly what the design landed, not a reinterpretation of the
summary above — read the full design doc in the repo, it has more detail
than fits here.

**Successor note (2026-10-02):** predecessor `endojs-endo-but-for-bots-pr1340-build-20261001` was promoted while design PR #1340 was still OPEN/unmerged (conduct job not yet in tada/) and with too small a session budget for the implementation; it handed off to this job, gated on the conductor. Start only after #1340 has merged into llm; read the merged design from llm.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T16:50:42Z
