The fix for FIX round 7 on PR #241 was already on the head, so I pushed nothing this attempt, and CI is green on that head (`e28a4590`).

**Must-fix: `numRuns` (spell-out-identifiers)**
- An earlier claimant of this job pushed `e28a4590` at 08:31Z, after panel-7's prepass finished at 08:06Z. It adds a `spell-out-exempt` marker on line 1 of `test/claude-onboarding-freeze.test.ts`.
- I checked that the marker is the right fix: `numRuns` is fast-check's own parameter name, so it can't be renamed, and the probe documents this marker as the way to waive such a case.
- The marker exempts the whole file, but `numRuns` was the only abbreviation the prepass flagged there, and the commit adds only that comment line.
- The probe now passes when run against the PR diff with `PRE_PUSH_BASE_REF=origin/main-9196892`.

**Advisory: comment at `src/endo/claude/agents.ts:766` (concision)**
- I kept this comment, with no edit. It records reasoning the code doesn't show: why rollback is skipped when another call holds the key, why the directory child is removed first, and why frozen onboarding gives back only the slot.
- It matches the code that follows it.

**CI**
- `ci-wait-merge.sh --no-merge` returned rc 0. I ran it with a 560s deadline rather than the job's 3600s, but it went green on the first call.
- The only run, `test (typecheck + vitest)` (41995220102), completed with `success` on `e28a4590`, which is still the PR head.
- **Visibility gap:** the bot token can't read `statusCheckRollup`, so the result comes from the Actions runs API, which doesn't show commit statuses or non-Actions checks.

**Follow-ups**
- The PR is still a draft. Panel-8 comes next from the driver, and I did not run it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 56 tokens (1631699 cached reads)
- Output: 11372 tokens
- Cost: $1.4215958000000002
- Wall-clock: 4339s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
