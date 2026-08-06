<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T05:44:59Z cleared=none -->

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

<!-- garden-annotation: key=pr656-gate-deployed-approval-stale-20260801 by=deadmail-20260729T023454Z-34a94e at=2026-08-01T09:55:57Z -->

The un-deployed-gate premise is now fully retired — but a NEW, legitimate blocker
has taken its place. Verified 2026-08-01T09:55Z from the deployed root of host
`endolin-garden-ece02cb4`.

## The gate fix IS deployed here

`/home/kris/garden/scripts/jobs/handlers/pr-maintainer-approval-gh.sh` is now
byte-identical to `main2` (`diff` clean), i.e. it carries `c510ec1b4f` — the
`reviewDecision` rollup is a veto, no longer the authority. Real-execution
evidence, run from the DEPLOYED root:

    $ /home/kris/garden/scripts/jobs/handlers/pr-maintainer-approval-gh.sh \
        endojs/endo-but-for-bots 656
    [pr-maintainer-approval] merge blocked: no maintainer approval
      (no current APPROVED review on head d74caef78ce22ebcbeeaa6134388340ad8dddbc3)
    rc=1

That is the POST-fix code path (the individual-review check), not the pre-fix
`reviewDecision=none` short-circuit this job was parked on. So neither the deploy
nor the `main2`-worktree work-around is needed any longer.

## What actually blocks endojs/endo-but-for-bots#656 now

The head has moved, exactly as this job's own text anticipated:

- head is now `d74caef78ce22ebcbeeaa6134388340ad8dddbc3` (was `76e6800ee5` when
  parked).
- kriskowal's `APPROVED` review still carries `commit_id 76e6800ee5`, so the
  approval is **stale by design**. kriscendobot's only review on the newer head
  is `COMMENTED`, which does not approve.
- `mergeStateStatus: UNSTABLE`; one check still `pending`
  (`test (24.x, macos-15)`). The other 23 pass.

**kriskowal must re-approve head `d74caef78c` before this job can merge.** The
approval gate is now correctly, not spuriously, refusing.

## Related PRs from the original stranded set — both landed

- endojs/endo-but-for-bots#671 MERGED 2026-07-29T02:33:47Z (merge commit
  `50972e791d292749803efe5d4d47f839f46d7fae`).
- endojs/endo-but-for-bots#691 MERGED 2026-07-30T20:26:28Z.

endojs/endo-but-for-bots#656 is the last of the three still open.

Promotion remains the gate-holder's call. This annotation only corrects the
recorded facts; it does not release the gate.

— `deadmail-20260729T023454Z-34a94e` (dead-letter carrier for
`endojs-endo-but-for-bots-pr671-conduct`)
