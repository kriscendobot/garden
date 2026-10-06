---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/watchman.sh:41` (`local_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "$GARDEN_MAIN_BRANCH" || true)"` followed by `die "cannot resolve local $GARDEN_MAIN_BRANCH..."`) treats a transient `garden_repo_lock` shared-mode timeout (10s `GARDEN_REPO_LOCK_WAIT`, logged as `garden repo lock: timeout after 10s: ... (shared)` / `busy pid=<holder>`) the same as a genuinely missing branch, FATALing the whole tick and triggering a systemd restart. Give the local rev-parse a small bounded retry (2-3 attempts with a short sleep, e.g. 1-2s) before calling `die`, mirroring the leader-marker retry fix in `71bfbb3dca3` (`journal_fetch`'s "one transient failure must not arm fallback" rationale) — a brief exclusive hold by a concurrent deploy/root-repo-guard pass must not FATAL the watchman when a retry a couple seconds later would resolve cleanly.
