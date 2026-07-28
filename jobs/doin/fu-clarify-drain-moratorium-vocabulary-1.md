In the garden's own repo (kriskowal/garden, `main2`), `scripts/checks/maintainer-inbox-information-hiding/check.sh` fires whole-tree with 13 pre-existing leaks in `roles/{COMMON,orchestrator,prosecutor,botanist}` and `skills/{orchestration,restore,review-retrospective,schedule}`. Decide per site whether to scrub the reference or extend the gate's allowlist, land the change, and leave the check green on a clean checkout.

---
claim:
  host: ps23
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T06:59:26Z
