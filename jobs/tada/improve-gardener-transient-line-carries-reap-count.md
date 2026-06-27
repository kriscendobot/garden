Done. The change is on `origin/main2` (commit `87fc42f3d`); the shared working tree is clean (the local `main2` branch will fast-forward to it via the normal fleet reconcile). Here is my completion report.

---

## Completion report: `improve-gardener-transient-line-carries-reap-count`

**What I did**

Hardened the observability of the gardener's transient-handler-failure branch so a deterministically-killed job (rc=143/130/137 + empty capture) is greppable in the journal *before* the reaper's ~5×TTL poison cycle (~5h), instead of looking identical on its 1st and 5th requeue.

**What changed** (commit `87fc42f3d` on `origin/main2`)

- **`scripts/jobs/common.sh`** — new read-only helper `reap_count <jobfile>`. Extracts the reaper's already-present `<!-- garden-reaped: N -->` marker using the *same* `sed -n 's/^<!-- garden-reaped: \([0-9][0-9]*\) -->$/\1/p' | tail -1` the reaper uses, defaulting to `0` when the marker is absent (first pass) or the file is missing. No new state, no CAS, never writes/advances the marker.
- **`scripts/jobs/gardener.sh`** — the `if [ "$transient" -eq 1 ]` branch now reads `cycle="$(reap_count "$jobfile")"` and folds it into both the `log` line and the `progress` journal note: `... transient handler outage (requeue cycle N) ...`. A comment records that this is read-only and explicitly does **not** re-open the OPEN failed-job-lane design decision.
- **`scripts/jobs/test/empty-output-classifier-test.sh`** — new **SUBTEST 4** (4 cases): absent marker → cycle 0; single marker N=3 surfaces in the formatted transient line; multiple markers → last wins (mirrors the reaper's defensive `tail -1`); missing file → 0, never an error. The test reproduces the gardener's exact line and asserts `requeue cycle N` appears in it.

**Verification**

- Full test suite passes: **14/14** (`RESULTS: 14 passed, 0 failed`), both in the shared tree and re-run on the clean isolated-worktree base before push.
- `bash -n` clean on `gardener.sh` and `common.sh`; shellcheck surfaced only pre-existing warnings (lines 286, 711–713), none in the new code.

**How it landed**

Built in an isolated worktree off `origin/main2` (per the garden-infra-jobs convention), committed with explicit pathspecs, pushed `HEAD:main2` (fast-forward, no rebase needed), then restored the shared `/home/kris` tree to a clean state and pruned the worktree. The local `main2` branch is one commit behind `origin/main2` and will reconcile via the normal fleet mechanism.

**Follow-ups**

None required. The OPEN failed-job-lane decision flagged in the gardener comment remains untouched and still awaits maintainer review — this change deliberately does not touch it.
