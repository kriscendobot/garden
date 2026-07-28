In kriskowal/garden (`main2`), fix the two pre-existing failures in `tests/checks/run.sh`: `test_maintainer_inbox_information_hiding.sh` (allowlist drift — `roles/prosecutor` and `skills/{orchestration,restore,review-retrospective,schedule}` reference the maintainer inbox off-allowlist; decide per reference whether to allowlist it or remove the reference) and `test_run_all.sh` (2 claude-stub-invocation assertions). Both were confirmed pre-existing and unrelated to the identity-drift-guard change.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T08:10:47Z
