In the garden's own job board (`journal2`, `jobs/todo/`), drop the two now-no-op sibling self-heal jobs from the chrome-native-function-caller-arguments-repro dead-upstream-404 incident: `...-comment-watcher-...-upstream-404` and `...-dependabot-watcher-...-armed-fork-upstream-404-no-disarm`. Confirm each is genuinely a no-op (the `watch-optout` tombstone already stopped the flap) before removing it, and record the removal in the journal.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-28T12:21:19Z
