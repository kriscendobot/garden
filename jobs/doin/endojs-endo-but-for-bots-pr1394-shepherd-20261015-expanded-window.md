---
tier: mentor
handler-timeout: 7200
split-indivisible-reason: 'single PR head-branch CI loop: each fix/re-run must wait on the ~20min test-thixotrope-ironhorse leg serially on one branch; no independent parts to parallelize'
split-lineage-root: endojs-endo-but-for-bots-pr1394-shepherd-20261015
split-lineage-parent: endojs-endo-but-for-bots-pr1394-shepherd-20261015-split
split-lineage-depth: 1
split-lineage-max-depth: 1
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-15T18:13:28Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear the shepherd role. Drive CI green on https://github.com/endojs/endo-but-for-bots/pull/1394 (head build/sturdyref-captp-wire, base build/sturdyref-marshal-representation-6976bb0). Do not rebase or change the base.

State at split time (2026-10-15T18:1xZ, head 6f3185b487c9ac92974533e9f50054d544db0f26): 24 checks pass, 10 skipping, and exactly ONE fails — `test-thixotrope-ironhorse` (20m17s, https://github.com/endojs/endo-but-for-bots/actions/runs/38766969048/job/116533087683). The earlier red legs (viable-release smoke publish, test, cover, matrix.check, format-ironhorse, test-async-hooks) are now green or skipped; the predecessor's TS6307 / *.types.d.ts uniformity fixes landed. Triage that one leg first: read its log, decide PR-attributable vs pre-existing flake (compare against the base branch / llm runs of the same job); if a flake, re-run the failed job; if attributable, fix minimally on the head and push. Re-check the head SHA first in case it moved. Wait for CI in a bounded foreground poll.

Provenance: split from `endojs-endo-but-for-bots-pr1394-shepherd-20261015` after one 2400s handler overrun (indivisible: single-PR CI loop).

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-15T19:34:06Z
