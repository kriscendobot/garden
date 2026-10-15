**Fix round 6 for kriscendobot/minion.town PR #188 is pushed and CI is green.**

I applied the one must-fix seat in the round-6 panel (pruner) as commit `b5c4a01`, pushed with `safe-push-pr-head.sh` (`6639959` → `b5c4a01`). There is no code change, only prose:
- **Design doc, § 2** (`designs/clip-shell-framework.md`): the gutter bullet no longer repeats the list of refresh triggers. It points to Open questions item 3 instead, and I rewrapped the long line.
- **`createClipRefresher` comment** (`deploy/aws/www/shell.js`): removed "(design Open questions #3)".
- **`makeClipSource` comment** (the optional item 3): cut the sentence about how the shell uses the result on first load, and kept the rule for when it returns null versus `[]`. It now says that any other non-2xx status counts as a real server answer, and the broken line wrap is fixed.

I also took one cheap should-fix from archivist and integrator. Open questions item 3 now says a failed refresh empties the main pane as well as the gutter. It also lists every temporary failure the code treats as "no answer": network error, 5xx, 408/425/429, and a response body that fails to arrive.

`vitest test/shell-clip.test.ts` passed (47 tests). I posted a summary comment for the round on the PR. `ci-wait-merge.sh --no-merge` returned rc 0: the single Actions run passed. The bot's token can't read the PR's full status rollup, so the wait script checked the Actions runs API instead and couldn't see any commit statuses or non-Actions checks.

**Not applied, left for later panel rounds or the maintainer:**
- Starting a new read can cancel the previous one too early: faster triggers could cancel every read, and the panel suggests cancelling the old read only when its replacement starts.
- The first-load auto-select is only checked by a regex over the source and needs a real test, plus a test for a failed refresh followed by a good one.
- Regrouping the five `fix(shell)` commits into logical ones.
- Renaming `sameClipRecord(a, b)`'s parameters and the `listed` variable.
- The fast-checker property tests.
- Missing summary comments for rounds 1 and 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (673393 cached reads)
- Output: 5010 tokens
- Cost: $0.6490386000000001
- Wall-clock: 950s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
