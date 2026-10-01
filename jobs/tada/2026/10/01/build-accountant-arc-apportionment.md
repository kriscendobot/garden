I didn't need to change anything: the earlier attempt had already built the job and pushed it to `main2` as commit `2fde4493798` ("feat(accountant): build the weekly arc apportionment"). I re-ran the tests to confirm it holds up.

**What that commit contains** (every item the job spec lists):
- **Arc spend tracking:** `arc-spend.sh` now uses a fixed weekly window start that rolls forward a whole week at a time. Old-format data still reads.
- **The `arc:` job field:** the old `ratchet-arc` field still works as an alias in every reader. `--arc` was added to `post-plan.sh`, `post-job.sh`, `post-orchestration.sh` and `post-gauntlet.sh`.
- **Orchestrations:** child jobs inherit the orchestration's arc. The next child in a serial run waits while its arc's budget is used up.
- **Foreman:** the deferred selector picks work in arc rank order, and the digest shows each arc's remaining headroom.
- **New scripts:**
  - `set-apportionment.sh` writes `config/apportionment`, `arc-budgets` and the generated foreman mandate in one commit, with `--carry-forward`.
  - `accountant-statement.sh` produces the weekly statement.
  - `accountant-reslice-nudge.sh` fires once each time every arc's budget is held.
- **Docs:** a new operator page, `context/operations/accountant.md`, gives the `accountant-weekly` schedule command. The schedule is deliberately not switched on until you approve it.

**Test results:**
- `accountant-arc-apportionment-test.sh`: 37/37 pass.
- `ironhorse-press-budget-test.sh`: 11/11 pass.
- `orchestrate-test.sh`: 78/78 pass. It takes about 10 minutes and uses a fixed directory, so two copies can't run at once.
- The foreman brake, decision-log, deferred-sigpipe, notice-dedup and provider-order tests all pass.
- `foreman-edge-kick-test.sh` has one failing check (the job doesn't complete when the foreman kick fails). It fails the same way on the commit before this build, so it isn't caused by this work.

**Follow-ups:**
- Switching on the `accountant-weekly` schedule needs your approval.
- The design's budget-request intake (`request-budget.sh`, `close-budget-request.sh`, the statement's Demand section and its tests) isn't built. It wasn't in this job's spec, and no job for it is on the board yet.
- The `foreman-edge-kick-test.sh` failure should be fixed separately.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-accountant-arc-apportionment.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 154 tokens (10776847 cached reads)
- Output: 75664 tokens
- Cost: $5.7656894
- Wall-clock: 4140s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
