Pushed cleanly to `main2` on the first attempt. The rebase was a fast-forward (no conflicting upstream changes), and the test suite passed at 100/100 before commit.

## Completion report

**Job:** `improve-rolling-deploy-rejected-candidate-backoff` — stop `rolling-deploy.sh` from retrying a candidate-gate-rejected leader self-deploy every tick.

**Problem:** At both leader self-deploy sites (the leader-only degenerate fleet, formerly `:596`, and the last-wave path after all canaries pass, formerly `:761`), a non-zero `leader_deploy` only logged a WARN. Since the `upgrade-ready` marker persisted with the same available SHA, every subsequent tick re-invoked `deploy-garden.sh` — re-running the gate, re-paging the maintainer inbox with the identical `kind:error`, and re-WARNing (the repeated warnings after the 2026-09-27T10:23:51Z rejection).

**What changed** (`scripts/jobs/rolling-deploy.sh`):
- Added a **target-keyed rejected-candidate marker** (`$GARDEN_STATE/rolling-deploy/rejected/<short-sha>`, keyed via the existing `sd()` short-sha helper, host-local like the settle floor) with `rejected_marker`/`rejected_is_marked`/`rejected_mark` helpers. The marker records target, timestamp, deploy rc, and a note that `deploy-garden.sh` already reported the error.
- Both self-deploy sites now check the marker first and **skip quietly** (one plain log line, no re-deploy, no re-WARN, no re-page) when the current target is marked; otherwise they capture the deploy rc and write the marker on a non-zero result.
- The backoff lifts **automatically when the available SHA changes** (a new target has no marker) and via an **explicit operator override** `GARDEN_ROLL_CLEAR_REJECTED=<sha>|all|1` (or simply deleting the file).
- The **original deploy error report is retained**: `deploy-garden.sh` still emits its `kind:error` inbox + journal report on the rejecting tick, and the conductor still WARNs once on that first tick.

**Tests** (`scripts/jobs/test/rolling-deploy-test.sh`): added a "REJECTED-CANDIDATE BACKOFF" section (8 cases) — attempted once, marker persisted, first WARN retained, same SHA not retried, quiet-skip note, no re-WARN, override resumes retry, new SHA unblocked. Suite now **100/100 PASS** (was 92). `bash -n` clean; shellcheck shows only pre-existing info notes.

**Docs:** added an operator note under "Candidate validation and manual override" in `context/operations/deploy.md`.

**Follow-ups:** none. Committed as `b7e65392bd` and pushed to `origin/main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-rolling-deploy-rejected-candidate-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 60 tokens (2067745 cached reads)
- Output: 24864 tokens
- Cost: $2.6229624999999994
- Wall-clock: 497s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
