In `scripts/jobs/triager.sh`, guard the ref-resolution block (lines ~124–130) so an **empty / unborn-HEAD bare clone** skips the tick gracefully instead of `die`-ing with exit 1 (which fails the systemd unit and triggers self-heal churn on every tick until the fork gets its first commit).

Failure signature: `FATAL: cannot resolve ref 'main' in <slug>` — reproduced when `worktrees/<slug>.git` has zero refs (`git --git-dir=$BARE for-each-ref` empty) because the upstream fork was freshly created and had no commits at triage time. `fetch --all --prune` at line 117 succeeds (nothing to fetch), so the `die "cannot resolve ref '$ref'"` at line 130 is the only symptom. This is the own-fork auto-provisioning path (fork-watch-provisioner) racing a not-yet-populated fork; it self-heals once a commit exists but exits 1 every tick until then.

Fix: after the fetch and before/around the rev-parse `die`, detect the empty-repo case and `exit 0` with a `log` line (treat as "no content to triage yet"), rather than `die`. Suggested shape: when `new_sha` resolution fails, check whether the clone has any refs at all — e.g. `if [ -z "$(git --git-dir="$BARE" for-each-ref --count=1 2>/dev/null)" ]; then log "…$slug is empty (unborn HEAD, no commits yet) — skipping this tick"; exit 0; fi` — and only `die` for the genuine unresolvable-ref-with-refs-present case (the existing agoric-sdk scenario the current fallback targets). Keep the escalation/`die` path for a clone that has refs but still can't resolve the watched ref, so a real misconfiguration is not masked. Mirror the existing "skip this tick, exit 0" convention already used for the missing-clone branches above (lines 84–85, 104, 113). Add a triager-test case (`scripts/jobs/test/triager-test.sh`) covering a bare clone with zero refs / unborn HEAD asserting exit 0, not 1.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  worker_kind: gardener
  claimed_at: 2026-07-17T05:57:40Z
