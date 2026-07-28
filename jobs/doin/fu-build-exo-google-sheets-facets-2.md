In the garden repo (kriscendobot/garden), fix `skills/local-verify` so its `test` step no longer stops at the first failing workspace: run every workspace's tests and report all failures together, so an unrelated red package cannot silently leave the rest of the tree uncovered by the gate.

---
claim:
  host: ps23-garden-f65473ae
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-28T17:38:43Z
