Inbox is empty. Work is complete and pushed.

## Completion report

**Job:** `improve-budget-level-preflight-failures` — harden `scripts/jobs/budget-level.sh` journal clone/sync preflight into explicit, isolated diagnostics with a defined fail-open outcome.

**Root cause.** `ensure_clone "$DIR"` and `sync_clone "$DIR"` ran bare under the script's `set -euo pipefail`. On a transient journal outage `sync_clone` does `exit $GARDEN_OFFLINE_RC` (75); on a hard fetch or unrecoverable-corruption failure either helper `die`s (exit 1). Either raw code escaped `budget-level.sh` and reached the scheduler as a **contextless** failure:
- Run as the scheduler's budget-level *controller* (`scheduler.sh:352`), the raw code paged the maintainer as a budget-**accounting** failure — an `exit_status=75 "offline; skipping tick"` alert that carries no pool/operation context and can't be told apart from a real leveling bug.
- Run as a scheduler `preflight:` *gate*, any non-2 exit makes the scheduler fail open and **spuriously dispatch** the leveling schedule as an LLM job (the gate contract is 0=work, 2=no-work, other=fail-open-dispatch).

**Change (`scripts/jobs/budget-level.sh`).** Wrapped `ensure_clone` + `sync_clone` + the budget-pool row read into a single subshell that holds the clone lock for its whole lifetime (so its `exit`/`die` is contained, the lock is acquired and released entirely within it — nothing leaks to the parent — and the read still sees a point-in-time-consistent clone). The parent captures the subshell rc and classifies it: `3` config-absent, `$GARDEN_OFFLINE_RC` transient-outage, any other a hard clone/sync failure. Each case emits an explicit `WARN` naming the controller, phase, and rc, then **fails open** via the existing `finish` (exit 0 for an operator run, exit 2 for a scheduled preflight — skip this tick, retry next cadence). The per-pool leveling loop below is unchanged (it already had isolated per-operation diagnostics and ran unlocked, as before).

**Tests (`scripts/jobs/test/live-budget-admission-test.sh`).** Added 3 cases, injecting failures through `GARDEN_FETCH_CMD` (routed through a `$HOME` exec-mounted dir since `$TMPDIR` is `noexec`):
- transient preflight outage → controller fails open **rc 0**, logs the offline diagnostic, actuates nothing;
- transient preflight outage under a scheduled run → preserves the **rc 2** no-work contract;
- hard preflight failure → fails open **rc 0** with the distinct hard-failure diagnostic, no actuation.

**Verification (executed).** `bash scripts/jobs/test/live-budget-admission-test.sh` → `RESULT: 17 passed, 0 failed` (14 prior + 3 new). `bash -n` clean on both files; `shellcheck -x` surfaced only pre-existing style-info notes (`SC2015`/`SC2034`/`SC1091`), none in the new block. Committed as `252205765d` and pushed to `origin/main2` (rebase-CAS, landed on attempt 1).

**Follow-ups:** none required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-level-preflight-failures.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 81 tokens (3669231 cached reads)
- Output: 33123 tokens
- Cost: $3.655944499999999
- Wall-clock: 475s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
