---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/worker-common.sh
worker_ensure_worktree() swallows BOTH stdout and stderr on `git -C "$GARDEN_ROOT" worktree add --detach "$worktree" "$ref" >/dev/null 2>&1`, so any failure (most plausibly lock contention from the gardener pool's concurrent same-host worktree adds) surfaces to gardener.sh as a bare rc=1 with no diagnostic text — the "empty/transient-signature output" classification bucket. This is the almost-certain source of the ~730 "transient handler outage" retries seen 08-15..08-19 across every job kind (review/merge/design/misc), all with near-identical 1-9s elapsed, dozens of which further escalate into elapsed-constancy overrun-suspect errors that give an operator nothing to diagnose. Fix: stop redirecting stderr to /dev/null (capture it to a var/tempfile and re-emit on failure, mirroring ensure-project-worktree.sh's `>/dev/null` stdout-only pattern at its own worktree-add call), and add a short retry/backoff on the loop when the captured stderr matches a lock-contention signature (e.g. "index.lock"/"already registered"), so a same-host concurrent worktree-add race self-heals instead of dying with an unclassifiable rc=1. This turns an unattributable per-job retry storm into either a self-healing retry or a properly classified, actionable error.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-19T20:22:48Z
