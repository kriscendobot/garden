The worktree is removed and the fix is live on `main2`. No inbox messages arrived.

---

## Completion report — `improve-gardener-honor-offline-rc-on-claim`

**Outcome:** Done. Pushed as `f26a5e7a1` to `main2` (rebased cleanly onto the concurrently-advanced `5fc801e85`).

**What the job asked for, and what I actually found.** The job asked me to add a branch in `gardener.sh`'s claim loop so a `claim-job.sh` exit of `GARDEN_OFFLINE_RC` (75) is treated like the empty-board case instead of crashing the worker. I added that — **but tracing the real path revealed the job's premise was wrong**: a transient outage never reaches `gardener.sh` as rc 75. Under `set -e`, the process was dying with the raw fetch rc (**128**) *before* `sync_clone`'s offline classification (`exit "$GARDEN_OFFLINE_RC"`) could ever run. That whole offline path was **dead code for every bare caller** (claim and complete). So I fixed the root cause too.

**Two `set -e` trip points, both in `common.sh`:**
1. `journal_fetch`: `GARDEN_FETCH_STDERR="$(…failing-fetch…)"; rc=$?` — a failing command substitution in a bare assignment is a `set -e` exit, killing the process at the assignment.
2. `sync_clone`: `journal_fetch "$dir"; rc=$?` — a function *returning* non-zero in a bare statement is itself a `set -e` exit.

Both are now captured through an `if` (`if cmd; then rc=0; else rc=$?; fi`), which suspends `set -e` for the call so the rc is read and `sync_clone` does the classifying. The existing `fetch-timeout-test` SUBTEST 3 had masked this because it invoked `sync_clone` as `( … ) || rc=$?`, a `set -e`-suspended context the real callers never use.

**Changes:**
- `scripts/jobs/common.sh` — fixed the two `set -e` short-circuits in `journal_fetch` + `sync_clone`.
- `scripts/jobs/gardener.sh` — honor the offline rc in **both** the claim path and the `complete-job.sh` path: log `"offline; skipping claim tick"`, sleep, `continue`; do **not** `die`, and do **not** increment `idle_rounds` (an offline tick is not a drained board for `GARDEN_ONESHOT`).
- `scripts/jobs/test/fetch-timeout-test.sh` — new SUBTEST 5: `sync_clone` from a **bare `set -e`** caller must exit 75 (the precise regression guard the masked SUBTEST 3 missed).
- `scripts/jobs/test/run-test.sh` — new SUBTEST 22: a gardener survives a *persistent* claim outage, logging the skip rather than dying.

**Verification:**
- `fetch-timeout-test`: **7/7 pass** on the rebased tree.
- Direct `claim-job.sh`: returns **75** on a classified outage, **1** on a genuine repo error (not masked), **0** on a healthy claim.
- End-to-end: patched gardener stays **ALIVE** through a persistent outage (4 offline-skips, 0 claim-failures); the unpatched control **dies rc=1**. Confirmed SUBTEST 5 fails against the unpatched `common.sh` (exits 128), so the guard is valid.

**Notes / follow-ups:**
- I did **not** run the full `run-test.sh` because it hardcodes `$TR=/home/kris/.garden-test`, which a concurrently-running gardener's own test invocation could `rm -rf` out from under (env-leak is scrubbed at line 46, but the fixed `$TR` path collision is not). SUBTEST 22's logic was validated standalone in a private temp dir instead. If someone wants the integrated run, do it on a quiet host.
- This fixes the reported fleet-wide simultaneous `garden-gardener@N.service: Failed with result 'exit-code'` noise on shared connectivity blips — those workers were dying at the `set -e` short-circuit, not skipping.
- The bare-temp-dir gotcha worth remembering: the sandbox blocks executing `+x` scripts under `/tmp` (exit 126), so test stubs invoked via `GARDEN_FETCH_CMD` must live under `$HOME` (which is why the existing tests use `/home/kris/.garden-*test`).
