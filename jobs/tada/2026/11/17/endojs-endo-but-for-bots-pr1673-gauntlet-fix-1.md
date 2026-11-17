I applied the panel-1 must-fix items from review 5944468021 to PR #1673 and pushed them as one follow-up commit. CI is green on the new head: all 35 checks finished with 0 failures, and `ci-wait-merge.sh` returned rc 0.

**Commit:** `ba78d5e977` on `feat/endopi-iterative-compaction`, advanced from `59a8b6a865` with `safe-push-pr-head.sh` in advance mode.

**Must-fix items:**
- **Unknown window (assessor, wire-watcher, corner-prober):** `planContextCompaction` now returns early when not forced and the window size or token usage is unknown. An explicit `reserveTokens` can therefore no longer trigger compaction on every turn. A new test covers reserves of 0, 4096 and 16384 with `windowTokens: 0` and `usedTokens: 50_000`.
- **Default reserve sentinel (corner-prober):** a missing `reserveTokens` now means "use the default", which keeps the 30% cap. Any explicit value is used as given, including 16384. The Fae and Floot config readers leave the field out when the variable is unset. A test shows an explicit 16384 on a 16k window fails closed, while the default is capped.
- **Two paths to one module (surfacer):** `providers/index.js` now re-exports `defaultContextCompactionSettings` and a `ContextCompactionSettings` typedef. I removed the extra `./providers/context-compaction.js` entry from `package.json` `exports`. Fae and Floot import from the main `index.js` path.
- **No lal doc or shared type (surfacer):** the settings shape is now one typedef, which both agents use in their JSDoc. I added a context-compaction section to the lal README. The Floot README now says a forced compaction takes precedence over `FLOOT_COMPACTION_ENABLED=false`.
- **Settings wiring untested (coverage-auditor):** two new tests in `fae/test/subagent-loop.test.js` drive settings through `spawnWorkerLoop` to the provider. One shows `enabled: false` produces no summary request. The other shows `customInstructions` reaches the summary request.
- **Loosened assertion (coverage-auditor):** the headroom test is back to matching only `/summary and tail exceed/`. I shrank its fixture summary so the test reaches the headroom check again.

**Should-fix and comment items also done:**
- Whitespace-only custom instructions now fail at config time, with tests.
- Error messages name the offending variable.
- `enabledText` is renamed `rawEnabled`.
- Fae's driver reads its config once instead of twice.
- `historyMarker` is renamed `historyHeading`.
- The `forceCompaction` JSDoc is aligned with the planner's wording.
- Comments are trimmed and the boundary change from `<` to `<=` has a note.
- Added changeset `.changeset/lal-configurable-context-compaction.md`.

**Not done:** the shared `readCompactionSettings` helper suggested by the integrator, and the PR-body trims suggested by the pruner.

**Local checks:**
- These ran and passed:
  - lal compaction tests: 19 passed.
  - Fae workload-config, subagent-loop and inbox-conversation tests: 41 passed.
  - Floot workload-config tests: 2 passed.
- Prettier was applied to the changed files.
- ESLint found no errors, only existing-style warnings.
- `tsc` is clean for lal and Floot. Fae has type errors, but none in the files or lines this commit touches.
- I did not run the repo-root `tsc` check or the full Floot suite.

**CI:** the macOS jobs were cancelled at 15 minutes twice without ever getting a runner (no runner assigned, zero steps). The first wait therefore reported RED, rc 3, on those cancellations alone. I re-ran the failed jobs twice. macOS 22.x then passed, and on the second re-run macOS 24.x got a runner and the rollup went green.

**Follow-ups:** the panel-2 review comes next. The shared config-reader helper and the PR-body trims remain open as should-fix items.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1673-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (6423459 cached reads)
- Output: 30275 tokens
- Cost: $2.8924477999999993
- Wall-clock: 2719s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
