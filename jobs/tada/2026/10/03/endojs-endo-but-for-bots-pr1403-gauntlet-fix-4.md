Fix round 4 for endojs/endo-but-for-bots#1403 is pushed and CI is green (33 of 33 checks).

The first CI run had one red cell, `test (24.x, macos-15)`. The failing test was `@endo/daemon` `daemon-teardown › an orphaned daemon shuts itself down`, which has nothing to do with `@endo/inference`. Memory already records this as a known macOS flake that a re-run clears. I re-ran that one job and it passed.

**What changed** (commit `aef833b9c0`, pushed with `safe-push-pr-head.sh` as a fast-forward from `469b886a92`; 11 files in `packages/inference`; 59 tests pass and lint has no errors):
- **Must-fix (breaker, spec-keeper, engine-realist; also raised by saboteur and purist):** `maxWallClockMs` is now capped at a new `MAX_TIMER_DELAY_MS` (`2 ** 31 - 1`). Before, `Infinity` or `3e9` passed the guard and the host timer turned them into about 1 ms, so the turn was cut off at once. New tests cover the guard, the enforcer refusing these values, and a check with real timers.
- **Number shapes:** counts, durations and `retryAfterMs` can no longer be `Infinity`. The enforcer also requires whole numbers for `maxTurns` and `maxOutputBytes`, because the pattern library can't express "integer".
- **Limit enforcer:**
  - `abort` now accepts only the classifier's result tags, so a plugin can't record `ok` or `needs-containment`.
  - The cancellation input is subscribed with `E.when` before the timer starts, so a broken thenable cancels the turn instead of leaving a stray timer.
  - A new optional `reportTerminateError` hook reports a failed kill instead of dropping it.
- **Process killer:** `makeProcessGroupKiller` now takes the child's pid when it is made and returns `() => boolean`. It refuses pids outside `[2, 2**31-1]`, which closes the `kill(-1)` case that would signal every process.
- **Usage recorder:**
  - It now reads and checks `describe()` before the turn starts, so a throwing `describe()` can no longer throw away a finished result.
  - It counts UTF-8 bytes without encoding the whole output.
- **Tag list:** it now has one source. A test checks it against every result variant.
- **Docs:** the prompt-origin gate is described as a tripwire, not an access control. Both wrappers are documented as needing a local backend. The `promptOrigin` type was loosened to `string`, and `detail` now carries a warning not to put secrets in it.
- **New edge-case tests:** `retry_after_ms` of 0, NaN and Infinity; a clock that steps backward; byte counts of `0` and `-0`; empty classifier tables.
- **PR body:** removed the three sections that only said "none" and added a sentence explaining the `test:xs` stub.
- **Summary comment (scribe):** posted 5965023462. It maps each finding to its fix and also lists the round-2 findings the scribe said were still unaccounted for.

**Findings I did not apply, with reasons given in the PR comment:**
- **`clearTimeout: any` (typist):** I tried `unknown`, but then the type checker rejects passing the host's own `clearTimeout`. I kept `any` and added a comment explaining why.
- **`SECURITY.md` (pruner, orthographer):** the file is byte-identical to the repo-root policy and the 132 other package copies. Changing it in one package would make it the odd one out.
- **`cancelled` → `canceled` (orthographer):** the repo's existing cancellation code (`@endo/cancel`, the daemon) spells it `cancelled` everywhere, and nothing in `packages/*/src` uses `canceled`. The new package matches that.

**Follow-up:** the panel-5 stage, which the driver posts.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (4952646 cached reads)
- Output: 29696 tokens
- Cost: $2.6055612000000004
- Wall-clock: 4831s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
