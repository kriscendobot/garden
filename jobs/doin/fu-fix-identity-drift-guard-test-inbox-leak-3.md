In kriskowal/garden (`main2`), add the two identity drift-guard tests to the CI shellcheck list. Their shared `unset $(compgen -v …)` idiom trips SC2046, so either suppress it narrowly with a justifying comment or rewrite the idiom to be shellcheck-clean.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T08:12:08Z
