**Completion report: improve-worker-worktree-no-ref-diagnostic**

I fixed `worker_ensure_worktree` so it says why it failed when no ref resolves. A host with a broken checkout is now treated as a host fault, so the job requeues instead of losing attempts. Pushed to main2 as `db962f13979`.

**Changes to `scripts/jobs/handlers/worker-common.sh`:**
- **Up-front checkout check:** before trying any ref, it runs `git -C "$GARDEN_ROOT" rev-parse --is-inside-work-tree`. If that fails, it exits through `die_environmental "GARDEN_ROOT=... is not a git checkout (<git's error>); ..."`. That exits with code 75, which `gardener.sh` treats as transient (`is_environmental_rc`), so the reaper requeues the job without charging an attempt.
- **Reason for each ref:** a new helper, `worker_ref_failure_reason`, records why each candidate ref did not resolve. The possible reasons are:
  - no origin remote configured
  - the tracking ref `refs/remotes/origin/main2` is missing
  - no local branch `refs/heads/main2`
  - `HEAD is unborn (points at …)`
  - otherwise, git's own rev-parse error

  Refs are now checked with `^{commit}`, so a ref that exists but doesn't point at a commit also counts as a failure.
- **One fetch and retry:** if no ref resolves, it runs `git -C "$GARDEN_ROOT" fetch -q origin <main-branch>` once (through the fleet git wrapper, which handles the locking) and tries the refs again.
- **Final failure:** if nothing resolves even after the fetch, it calls `die_environmental` with the reasons for every ref plus the fetch error, if there was one. That is again a host fault and the job requeues. If a ref did resolve but `worktree add` itself failed, the old behaviour is kept: plain `die` with git's error, and no fetch, since fetching can't fix that.

**Tests:** `scripts/jobs/test/worker-ensure-worktree-test.sh` has three new cases: a root that isn't a git repo, an unborn repo whose fetch fails (checks each reason appears in the message), and a never-fetched tracking ref that the fetch repairs. All 14 tests pass, as do `hermit-capability-probe-test` (22/22) and `codex-completion-nudge-test` (21/21). My first version made the hermit probe test fail because git's warnings were mixed into the checkout-check output; I fixed that before committing.

**Follow-ups:**
- **Broken host keeps claiming:** a host with a bad checkout still claims jobs and requeues each one quickly. Adding the same "is `$GARDEN_ROOT` a git work tree" check to the pre-claim worker health gate in `common.sh` would stop that host from claiming at all. I didn't post a job for this.
- **Existing test failures:** `scripts/jobs/test/gardener-worktree-test.sh` fails 46 tests (16 pass) on unmodified main2 too, so it isn't caused by this change. It probably needs its own job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-worker-worktree-no-ref-diagnostic.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1240697 cached reads)
- Output: 12010 tokens
- Cost: $1.1242514
- Wall-clock: 185s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
