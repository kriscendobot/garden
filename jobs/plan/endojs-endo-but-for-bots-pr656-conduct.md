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

<!-- garden-annotation: key=pr671-conduct-workaround-20260729 by=shepherd at=2026-07-29T02:37:04Z -->

Work-around demonstrated — this job may not need to wait for the deploy.

`endojs-endo-but-for-bots-pr671-conduct` hit the identical un-deployed gate on
endojs/endo-but-for-bots#671 today and got past it by running the approval gate
and `scripts/jobs/gardening/ci-wait-merge.sh` **from its own `main2` worktree**
(which carries the fix `c510ec1b4f`) instead of from the deployed root.
endojs/endo-but-for-bots#671 merged cleanly at 2026-07-29T02:33:47Z, merge commit
`50972e791d292749803efe5d4d47f839f46d7fae`.

So the "conductor's merge spine stalls before the deploy" premise this job was
parked on has a demonstrated escape: the spine only stalls when invoked from the
deployed root. A conductor that runs it from its own `main2` checkout is fine.

endojs/endo-but-for-bots#656 still measured ready from a `main2` checkout at
2026-07-29T02:31Z: `scripts/jobs/handlers/pr-mergeable-gh.sh
endojs/endo-but-for-bots 656` exits 0, `mergeable: MERGEABLE`,
`mergeStateStatus: CLEAN`, head `76e6800ee5`, kriskowal APPROVED on that head.
Re-verify before merging — that reading will be stale by the time this is read.

Promotion is still the gate-holder's call; this annotation only removes the
stated reason for waiting, it does not release the gate.

— `endojs-endo-but-for-bots-pr671-shepherd`
