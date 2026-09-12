Everything is complete and verified. Inbox is empty; the change landed bare on `main2` as `f5e91b6625`.

## Completion report

**Job:** Implement recommendation 6 of `designs/cybernetics-audit.md` § 7 [wrong sensor] — route panel seat/decider error into the gauntlet's retry budget, not the decline branch.

**Blocker honored first:** Read `jobs/tada/diagnose-panel-seat-error-rate.md` and `designs/panel-seat-error-rate-diagnosis.md`. Its landed recorder fix already gives `panel.sh` distinct dispositions (`seat-error`, `decider-error`, `interrupted`) and preserves exit codes; it explicitly leaves the gauntlet-side routing as remaining work ("Genuine `seat-error` and `decider-error` outcomes should use the gauntlet's bounded stage-retry path"). This job is exactly that routing — no overlap or contradiction, and no panel.sh change was needed (its non-zero exit is already the signal).

**What changed (`scripts/jobs/gauntlet.sh`):**
- **Panel stage brief, step 4:** on a non-zero `panel.sh` exit (a sensor failure — seat/decider error or interruption), the gardener now completes *normally* and emits a distinct `<!-- gauntlet-stage-result: panel=panel-error -->` marker instead of `orchestration-failed: true`. Added the marker to the stage's allowed marker list.
- **Transition table, `panel` branch:** a new `panel-error)` case routes into the existing `retry_failed_stage` under `max_stage_retries` (2) — the same bounded path `d28a2d5f76` gives a doomed transient stage. A transient blip re-runs the round; exhausting the budget halts loudly, naming the sensor error. Everything unparseable still fails closed.
- Updated the top-of-file doc comment to record the new axis.

**Tests (`scripts/jobs/test/gauntlet-test.sh`):** added SUBTEST 11 (recovery: one `panel-error` re-posts the same round under the budget without halting, then a real `panel=pass` proceeds) and SUBTEST 12 (exhaustion: three `panel-error`s halt at `max_stage_retries=2`, halt message names the spent budget and the sensor failure). **46/46 pass.** `bash -n` and `shellcheck -x` clean (only pre-existing SC1091/SC2015 infos shared by the whole file).

**Boundaries respected:** `max_iterations` and the disposition rule untouched; no seat-error root-cause investigation; a genuine review verdict (pass/must-fix, exit 0) never reaches the retry path and keeps its semantics.

**Follow-up / note:** My first pass of edits accidentally targeted the *deployed garden root* (`/home/kris/garden/scripts/...`) by absolute path rather than the worktree. A concurrent deploy reverted `gauntlet.sh` there; I restored the one surviving stray edit to the deployed-root test file with a plain `cp` from the pristine worktree copy (no git run in the root) and confirmed both deployed-root files matched their HEAD before redoing all work correctly in the worktree. No stray change persisted. Worth guarding against generally, but nothing outstanding here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/cybernetics-rec6-panel-error-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (5289846 cached reads)
- Output: 39287 tokens
- Cost: $4.9944999999999995
- Wall-clock: 612s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
