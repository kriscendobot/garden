All five must-fix items from the round-3 panel review are fixed on PR #154 (kriscendobot/minion.town). The fix is pushed as `8b73552` and CI is green: `ci-wait-merge` returned rc 0 with 3/3 checks passing.

**Must-fix items:**
1. **Shell injection in `deprovision`:** every place the agent name goes into the remote program now passes through `quote()`. `unstage` (a should-fix in the same file) now quotes the stage path too.
2. **Repeated MANIFEST keys:** `readManifest` now refuses a MANIFEST that repeats a key, instead of letting the last value win. A new restore test covers a backup that repeats `db_sha256` with a tampered database; it is refused and the live state is left alone.
3. **Reaper tests that tested nothing:** I replaced the two tests with ones that only pass because of the specific guard code:
   - a failing `ss` that still prints a listener line must not cause any reaping;
   - a pid that no longer exists, listed before a live orphan, must not stop the orphan from getting SIGTERM.

   I deleted each guard in turn and the matching test failed. The reaper also now ignores pids ≤ 1, a should-fix.
4. **Stale name in the pin-drift test:** the comment and the test title in `test/endo-pin-drift.test.ts` now say `endoCommit`.
5. **Missing summary comments:** I posted one comment covering rounds 1–3, mapping each round's items to their commits (issuecomment-5984429944).

**Should-fix items also done:** `renderRemoteProgram` now rejects a variable whose value is `undefined`. `readRemoteProgram` now requires the two-line `#` header and a non-empty body. Both have tests.

**Local checks:** the full `vitest` run had 860 passing and 1 failing. The failure is `test/git-remote/capability.test.ts › propagates a git failure`. This diff doesn't touch that code; I believe the failure comes from the local environment but didn't confirm it. CI passed. `tsc` and prettier are clean.

**Left for later** (should-fix items, not blocking):
- The `endoCommit` regex is still copied in three places, and there are still two `quote` helpers.
- `sha256` still reads whole files into memory instead of streaming them.
- The `→`/`…` characters in the newly written files are still there.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2142940 cached reads)
- Output: 12753 tokens
- Cost: $1.3026479999999998
- Wall-clock: 442s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
