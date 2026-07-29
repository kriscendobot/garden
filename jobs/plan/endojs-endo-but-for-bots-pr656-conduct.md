---
gate: go-ahead
priority: normal
posted_by: endojs-endo-but-for-bots-pr656-shepherd
posted_at: 2026-07-29T00:35:06Z
---

# conduct endojs/endo-but-for-bots PR #656

Map: **merge** -> land the approved, green PR.

PR: https://github.com/endojs/endo-but-for-bots/pull/656
Approval: https://github.com/endojs/endo-but-for-bots/pull/656#pullrequestreview-4802884427

## Why this is parked, not queued

State verified 2026-07-29 by the `endojs-endo-but-for-bots-pr656-shepherd` job:

- CI green: 24/24 check runs `completed`/`success` on head `76e6800ee54cf8108c917b81e7dcdfa7f29e5aaa`.
- OPEN, `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`, not draft.
- kriskowal `APPROVED` on that exact head at 2026-07-29T00:06:25Z.

The only thing standing between this PR and a merge is a garden-side gate, now
fixed on `main2` but NOT yet deployed:

- `scripts/jobs/handlers/pr-maintainer-approval-gh.sh` required GitHub's
  `reviewDecision` rollup to equal `APPROVED`. That field is empty on this PR
  (and on endojs/endo-but-for-bots#705 and endojs/endo-but-for-bots#282) despite
  a real maintainer approval on the head commit.
- Fixed by `c510ec1b4f` on `main2` (rollup is now a veto, not the authority),
  with regression tests in `0520ce88bc`. Activation needs a deliberate deploy
  (`context/operations/deploy.md`).

**Promote this job only AFTER `main2` is deployed to this host.** Before the
deploy, the conductor's own merge spine (`scripts/jobs/gardening/ci-wait-merge.sh`)
hits the same un-deployed gate and stalls, exactly as the
`endojs-endo-but-for-bots-pr755-conduct` job did on 2026-07-28.

Verify readiness before promoting:

    scripts/jobs/handlers/pr-mergeable-gh.sh endojs/endo-but-for-bots 656   # want rc=0

If the head has moved by then, the approval is stale by design and kriskowal must
re-approve the new head first.
