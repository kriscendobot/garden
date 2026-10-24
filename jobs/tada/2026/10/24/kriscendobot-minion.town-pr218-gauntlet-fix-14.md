# Gauntlet FIX round 14: kriscendobot/minion.town#218

I applied every request-changes finding from the round-14 panel review (5637810465, on head `4e33e459`). Three follow-up commits went to `split/pr216-ledger` through `safe-push-pr-head.sh`, moving the head from `4e33e459` to `65afe31e`, and CI is green on all 4 checks.

**Commits**
- **`17163163`, first-bond conflicts and retry backoff** (breaker 1, engine-realist 1–2): `bondGuest` now runs a process's bonds one at a time until its first bond commits the shared `key-version/<v>` row. A burst of first bonds after a restart can no longer use up all 5 retries conflicting on that row. A bond that fails still records no version.
  - A code comment now explains why the "row already written" flag never needs resetting: DEPLOYMENT.md says to delete a version row only once no process holding that key is serving.
  - Retries now use exponential backoff with full jitter: up to 50 ms on the first retry, doubling after.
  - New test: a burst of seven bonds whose first one fails.
- **`1578a46b`, backfill could bring back a stale ledger row** (breaker 2): each backfill transaction now checks that the account row still holds the fingerprint and key version the scan read.
  - If that check cancels the write, the backfill rereads the account and records its current bond, or skips the account if it no longer holds one.
  - After 5 attempts it stops without writing any marker.
  - The row-building node code is now shared by the scan and the reread.
  - The pruner's cuts in this script are done: the loop narration and the step labels 1 and 3.
  - The test stub can now simulate a stale write and a reread. Four new tests cover the check, a rebind during the backfill, the skip, and giving up.
- **`65afe31e`, docs** (pruner 4–7): the design doc now describes the checked backfill and the one-at-a-time first bonds. The "Why erase bonds at deletion" paragraph is cut to one sentence, and the redundant comments in `dynamodb.ts` and `accounts.ts` are gone.

**PR body** (pruner 1, 8): rewritten from 416 to about 300 words. The Benchmarking section is gone, Decision now points to design § 8 instead of restating the risk, and the move to #220 is stated once.

**Comment-only findings**: breaker 3–4 and engine-realist 3–5 asked for no change, and I made none. I posted a reply comment going through every finding.

**Checks**
- Locally: the `accounts*` and backfill test suites pass (16 + 37 + 54 tests), `tsc --noEmit` is clean, and `shellcheck -S warning` is clean.
- In the full local `vitest run`, the only failures are `test/git-remote/capability.test.ts` (a known local false-fail) and the `tools/claude-harness` suites, which `npm test` excludes. None of them touch files this PR changes.
- `ci-wait-merge.sh --no-merge` exited 0: CI green, 4/4 (test, changes, Claude harness amd64 and arm64).

**For the next panel round**: the "Why erase bonds" paragraph was cut down here, not moved into #220's design, so if #220 needs the full argument it has to be added there. Next step is panel round 15, which the driver posts.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-14.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3131936 cached reads)
- Output: 23260 tokens
- Cost: $2.0015872000000003
- Wall-clock: 1211s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
