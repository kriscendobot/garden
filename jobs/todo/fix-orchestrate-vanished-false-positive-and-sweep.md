---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fixer: orchestrate.sh destroyed the ironhorse campaign a THIRD time — on a child that SUCCEEDED

## The incident (all facts verified against `journal2`, 2026-08-12)

Campaign `ironhorse-test262-implementation-completion-resume-2` (serial,
on-child-failure=halt) halted at child 1/22 and swept 21 children off the board.
Its halt record says:

> Serial run halted at child 1/22 **ironhorse-js-07-promises-async-functions**:
> vanished from the board. 0/22 children completed before the failure.

**The child did not vanish. It succeeded.** Verified board history:

    17:14:50  c47fa3561a  plan(js-07) parked [orchestrated/normal]
    17:19:04  7b9fd67dc4  promote(js-07) plan→todo
    17:19:08  a499031d5c  claim(js-07) endolin-garden2-5bcdff64/cleric-2
    17:19:20  825194d60a  orch observed child-js-07-reap-count=0
    17:22:05  01abb4b49b  orch observed child-js-07-host=endolin-garden2-5bcdff64
    17:38:39  3745cfe050  tada(js-07) DONE endolin-garden2-5bcdff64/gardener-2
                          (D jobs/doin/js-07.md, A jobs/tada/js-07.md — one atomic commit)
    17:40:11              orchestration HALTED: "vanished from the board"

`jobs/tada/ironhorse-js-07-promises-async-functions.md` is present on `journal2`
right now. The orchestration declared it vanished **92 seconds after** its tada
commit landed.

## Why this classification is reachable at all

`child_state()` (`scripts/jobs/orchestrate.sh`) tests, in order: `tada/` → `todo/`
→ `doin/` → `plan/`, and falls through to a bare `printf 'failed'` with the comment
"promoted and vanished without a tada (an older-style doom drop, or a manual
removal)". The tada test is FIRST, so a correct read of a completed child cannot
reach the fallthrough.

Therefore the watcher's journal clone (`$DIR`, default
`$GARDEN_STATE/orch/journal`) did not hold the child in ANY of the four
directories at read time. Root-cause that. Candidates, in rough order of
likelihood — confirm or eliminate each with evidence, do not guess:

- `sync_clone` partially applied the tada commit (delete from `doin/` visible, add
  to `tada/` not), leaving an inconsistent working tree.
- `sync_clone` failed and the tick proceeded on a stale/half-updated clone rather
  than exiting the tick.
- The read straddled a working-tree update, so the four `[ -e ]` tests did not see
  one consistent snapshot.

The fix must make "I could not read the board consistently" **distinguishable from
"the child is gone."** An unreadable or inconsistent board is not evidence of
failure, and must never be treated as one. Fail toward "retry next tick".

## The amplifier — fix this even if the classifier were correct

A single misclassification `git rm`'d 21 unrelated, not-yet-run children. That is
the third time this campaign has been swept (2026-08-08 child 6/29;
2026-08-12T03:34 child 7/29, 22 swept; 2026-08-12T17:40 child 1/22, 21 swept), and
the second DISTINCT false-positive classifier to trigger it — the stall heuristic
was already fixed in `9a16e2a6ef` and this is a different branch.

**A halt should not destroy the remainder.** Leave the not-yet-run children PARKED
in `plan/` under their held `orchestrated` gate, exactly where a doomed child is
left for a human. The halt record can name them without deleting them. Sweeping
converts a recoverable pause into an archaeology exercise every single time, and
the recovery has now been paid for three times.

If there is a real reason the remainder must leave `plan/` on halt, say what it is
and make the removal recoverable by design (a tombstone naming the commit that
holds the bodies) rather than relying on an operator knowing to run
`git show <sweep-commit>^:`.

## Recovery

The 21 swept bodies are recoverable from the parent of the sweep commit — the halt
commit for `…-resume-2`, in the same shape as `c95607119^` was for the prior
incident. **Do not relaunch the campaign** as part of this job; the maintainer will
decide that separately once this is fixed. Restoring the bodies is in scope only if
you can do it without arming the campaign.

Note js-07's completed work is NOT lost — it is in `jobs/tada/`. A relaunch must
not re-run it.

## Definition of done

- The false "vanished" classification root-caused with evidence, and fixed so an
  unreadable/inconsistent board read retries instead of failing the child.
- Halt made non-destructive (remainder parked, not deleted), or an explicit
  argument for why not plus a recoverable-by-design alternative.
- Regression tests for both: a completed-child-read-during-sync case, and a halt
  that leaves the remainder parked.
- Pushed to `main2`; note that a deploy is required before it is live.
