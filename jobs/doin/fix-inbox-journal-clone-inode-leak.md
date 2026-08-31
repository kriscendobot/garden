---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix the inbox-journal-clone inode leak (fleet-wide infra defect)

The garden fleet leaks host-local journal clones under
`$GARDEN_STATE/inbox/<doer>/journal`, one per job doer, and never prunes them.
Each clone costs ~17k-29k inodes. This has twice driven a host to inode
starvation:

- 2026-08-28, `endolin-garden-ece02cb4`: `/dev/nvme0n1p2` reached **0 free
  inodes** with 3972 of 3984 inbox dirs holding a full journal clone
  (~206M inodes). Every `git clone` of journal2 failed with ENOSPC, so no
  gardener could read its inbox, claim, or report — the whole host wedged.
  Diagnosed and manually unwedged by job `minion-town-press-20260828-132012`;
  no durable fix landed, and the maintainer's inbox message noted the leak
  would refill.
- 2026-08-31, `endolin-garden2-5bcdff64`: 2851 inbox clones holding
  **69,052,121 inodes** — 28% of the whole 244M-inode filesystem — with free
  inodes down to 1.11%. Reclaimed by hand during a maintainer muster.

Both hosts share one filesystem, so either host's leak can starve both.

## Where it leaks

`inbox-read.sh:19` sets `DIR="${GARDEN_INBOX_CLONE:-$GARDEN_STATE/inbox/$doer/journal}"`
and calls `ensure_clone` (`common.sh:3052`), which does a full `git clone` of
journal2 when the dir has no `.git`. Nothing ever removes it.

`complete-job.sh:195` already destroys the **journal-side** inbox with the
comment "destroy this job doer's inbox; its lifetime ends with the job":

    [ -d "$DIR/inbox/$base" ] && git -C "$DIR" rm -rq "inbox/$base"

but `$DIR` there is the gardener's OWN clone
(`$GARDEN_STATE/gardeners/$id/journal`, set at `complete-job.sh:39`), not the
inbox clone. The host-local clone at `$GARDEN_STATE/inbox/$base/` survives the
job that created it, forever.

## The fix (two parts — please do both)

**1. Close the common path in `complete-job.sh`.** After the completion push
succeeds (the `rc=0` branch, alongside the existing `foreman_kick`), also drop
this doer's host-local inbox state:

    rm -rf "$GARDEN_STATE/inbox/$base"

This matches the already-stated intent that the doer's inbox lifetime ends with
the job. Confine the removal to `$GARDEN_STATE/inbox/` (refuse anything that
resolves outside it, the way `scratch_cleanup` in `common.sh:2252` does) and
make it best-effort/fail-open — a cleanup failure must NEVER strand a finished
job in `doin/`. Note `$GARDEN_STATE/inbox/<doer>/` holds exactly two entries,
`journal` and `journal.lock`; both go.

**2. Add a sweeper for jobs that never complete.** Part 1 cannot recover the
majority of the observed leak, because a doomed, reaper-killed, or
host-crashed job never reaches `complete-job.sh`. Add a periodic sweep that
removes `$GARDEN_STATE/inbox/<doer>/` when ALL of these hold:

  - `<doer>` is in neither `jobs/todo/` nor `jobs/doin/` on a freshly-synced
    journal clone (parked `plan/` jobs need no clone — one is re-created on
    demand when they are promoted);
  - the dir has not been modified for at least a couple of hours;
  - no live process has its cwd inside it.

It must run on **every host** (not leader-only), like the reaper and the
root-repo guard — each host can only see and reclaim its own
`$GARDEN_STATE`. Fold it into `reaper.sh`'s existing janitor section, or add a
`garden-state-keeper` timer alongside `garden-clone-keeper`, whichever fits the
codebase better. Removal must be confined to `$GARDEN_STATE/inbox/` and must
never touch a live doer's clone.

Nothing durable is lost by either removal: all message state lives on
`origin/journal2`, and `inbox-read.sh` re-clones on demand. This is the same
operation performed by hand on both hosts, twice, without loss.

## Also worth doing

Consider a `low-inode` reclamation hint: the root-repo guard already detects
inode starvation and reports it but explicitly performs no deletion. Once the
sweeper above exists and is provably safe, the guard could invoke it rather
than only paging a human.

## Definition of done

Both parts landed on `main2` with the normal gates, plus real-execution
evidence: show the sweeper correctly selecting dead doers and refusing live
ones on a host with a populated `$GARDEN_STATE/inbox/`, and cite the commands
and their output. Report the before/after `df -i` on the host you run it on.
