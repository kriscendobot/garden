The tick-failure WARN in `scripts/jobs/deadline-nudge.sh` now names the failing stage and command. The change is committed and pushed to `main2` as `19d0ba38bbc`. `deadline-nudge-test.sh` passes 51/0 (about 2.5 minutes per run), and `shellcheck -S warning` is clean.

**What changed in `deadline-nudge.sh`:**
- **Fault record:** a host-local, rebuildable file at `$GARDEN_STATE/deadline-nudge/tick-fault` (the path can be overridden with `GARDEN_DEADLINE_NUDGE_FAULT`). The parent deletes it before each tick. Every write to it is best-effort, so recording a fault can never fail the tick itself.
- **Stage names:** `tick_stage` overwrites the record with the stage name as each stage starts: init, clone, then journal-sync, staging and push with their attempt number (for example `staging (attempt 1/5)`). A failure that fires no trap therefore still leaves its stage behind.
- **Push exhaustion:** the `return 1` path, which runs outside the traps, adds a `detail:` line ("push stage exhausted after N attempt(s) (last commit_and_push rc=…)").
- **Signals:** TERM, INT and HUP are now caught inside the subshell. The handler records the signal name and exits with 128 plus the signal number.
- **Exit trap:** on a non-zero exit, `tick_on_exit` adds rc, command with call stack, and the recent failed commands to the record. Its ERROR log line now also includes the stage.
- **Parent WARN:** the final WARN now reads like `rc=N; stage=…; [signal=…;] [detail=…;] command=…; recent failed commands: …; fault record <path>`. When no command was recorded (for example after SIGKILL or an out-of-memory kill), it says "no fault record — failure bypassed the traps", gives the last stage, and names the likely signal when rc is above 128.

**Tests in `scripts/jobs/test/deadline-nudge-test.sh`:** these run against a throwaway journal and inject faults through an exported `git` function or `GARDEN_PUSH_CMD`.
- **Helper exit:** a helper `exit 7` during staging must produce a WARN with `stage=staging (attempt 1/5)` and `` command=`exit 7` `` plus its stack. This case was already tested; it now also checks the WARN line.
- **SIGKILL (new):** the WARN must give rc 137, the staging stage, and the "bypassed the traps … signal 9" note.
- **SIGTERM (new):** the WARN must give rc 143, the staging stage, `signal=TERM`, and the command.
- **Push exhaustion:** the WARN must give `stage=push (attempt 1/1)`, the exhaustion detail, and the command.

**Follow-ups:**
- The 2026-09-29T22:01:29 `rc=1` failure has not been diagnosed yet. The next failing tick's WARN, or the `tick-fault` file on the leader host, will name the operation that needs fixing.
- Failures that a stage handles itself (clone, sync or staging problems that defer and return 0) still produce no WARN. They were already logged under their stage names, so I left them unchanged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-failure-trace-expanded-window.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (950040 cached reads)
- Output: 12716 tokens
- Cost: $0.9918
- Wall-clock: 592s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
