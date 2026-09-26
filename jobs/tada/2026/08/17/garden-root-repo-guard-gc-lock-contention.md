Done. Committed as `29712dfa20` and pushed to `main2`.

## Completion report

**Defect fixed:** `root-repo-guard.sh` conflated a `git gc` **lock collision** with a **damaged object store**, then escalated to a ~173MB `fetch --refetch` and paged the maintainer with a hand-repair recipe that had no missing object to act on. Worked evidence (endolin-garden2-5bcdff64, 2026-08-17) showed the notice self-refuting — "0 object(s) reachable from refs are missing locally" with an empty example list — and the store repacking 52→4 packs on its own within ~24m. It was never damaged.

**What changed (`scripts/jobs/root-repo-guard.sh`):** rewrote the gc-failure classification in `guard_object_store` to classify *before* escalating:
1. **Lock contention** (`fatal: gc is already running … pid <n>`) → back off to the next tick, **no `--refetch`, no alert**. New `gc_error_is_lock_contention`/`gc_error_lock_pid` helpers; the holder's liveness is logged via the existing `gc_lock_holder_alive` seam so a live concurrent gc reads differently from a stale lock.
2. **Zero missing objects** (gc fails for any other reason but every referenced object is present) → likewise back off quietly. The `UNMAINTAINABLE` verdict and its ref-dropping recipe now **require a non-zero missing count**, so the inapplicable guidance is never emitted with an empty missing list.
3. **Non-zero missing count** → the existing `--refetch` + once-per-window alert path, unchanged, plus a re-scan after `--refetch` so a refetch that restored everything backs off instead of alerting.

**Contention source understood (not papered over):** the concurrent gc is git's own `git gc --auto`, which any journal sync or per-job worktree op can fire on the *shared* `$GARDEN_ROOT/.git` object store. Two different pids 23s apart is racing auto-gc serializing on the `gc.pid` lock — expected and benign; backing off is exactly what git itself does.

**`scripts/jobs/root-maintenance.sh`:** maps the two new escalation outcomes (`gc-contended`, `gc-intact`) to honest sysop `maintain` acks (no longer claiming "a human alert was raised" when none was).

**Regression tests (`scripts/jobs/test/root-repo-guard-test.sh`):** CASE 16 (real gc lock via a live `gc.pid` → contention backoff, no refetch, no alert), CASE 17 (zero-missing gc failure → intact backoff), and CASE 9 rewritten to genuine unrepairable damage (a local-only blob `--refetch` cannot restore → the existing escalation still fires). **52/52 assertions pass**; `bash -n` and shellcheck clean (only pre-existing warnings).

**Possible follow-up (not done, larger decision):** setting `gc.auto=0` on the shared root repo would make the guard the sole gc mechanism and eliminate the contention source entirely, but that's a separate design change beyond this contained classification fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-root-repo-guard-gc-lock-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2931230 cached reads)
- Output: 46504 tokens
- Cost: $3.6985710000000003
- Wall-clock: 602s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
