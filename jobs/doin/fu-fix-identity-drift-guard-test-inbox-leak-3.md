In kriskowal/garden (`main2`), add the two identity drift-guard tests to the CI shellcheck list. Their shared `unset $(compgen -v …)` idiom trips SC2046, so either suppress it narrowly with a justifying comment or rewrite the idiom to be shellcheck-clean.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: gardener
  claimed_at: 2026-07-28T12:14:54Z
