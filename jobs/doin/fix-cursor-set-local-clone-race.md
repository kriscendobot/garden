---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix cursor-set.sh's local-clone concurrency race

Observed live on `endolin-garden-ece02cb4`, 2026-09-20/21: the
`endojs-endo-but-for-bots` comment-watcher's cursor
(`journal/cursors/comments/endojs-endo-but-for-bots`) made ZERO committed
progress for ~24 hours (`last_polled_at` stuck at `2026-09-20T20:30:02Z`
while wall-clock was `2026-09-21T21:02Z`), despite the watcher apparently
still running/reading comments the whole time. `journalctl --user -u
garden-comment-watcher@endojs-endo-but-for-bots.service` shows repeated
`fatal: unable to write new index file` around the stall window, and the
live process tree at the time showed TWO concurrent `cursor-set.sh`
invocations running simultaneously (PIDs both alive, both mid-git-operation)
against the same clone.

## Root cause

`scripts/jobs/cursor-set.sh` has **no locking at all** (confirmed: no
`flock`, no lock file anywhere in the script). Its working directory,
`DIR="${GARDEN_CURSOR_CLONE:-$GARDEN_STATE/cursors/journal}"`, is **one
shared local clone used by every cursor-writing caller on the host** — every
repo's comment-watcher, the CI watcher, the dependabot watcher, the mention
watcher, the issue-inbox watcher, all of them, all cursor keys, one clone.
`ensure_clone` (`common.sh`) only holds `clone_lock`/`clone_unlock` around
its OWN clone-creation/repair step, then releases before returning — the
actual `git add`/`commit`/push in `cursor-set.sh` runs with NO lock held.
Two callers invoking `cursor-set.sh` at overlapping moments (plausible any
time two watchers tick close together, or a self-heal restart overlaps a
still-finishing prior run) race on the SAME local working tree's index —
this is a LOCAL git-index corruption hazard, distinct from and not
addressed by the existing remote-ref CAS-retry-on-push pattern (which only
handles losing the PUSH race, not corrupting the LOCAL index before the
push is even attempted).

## Fix

Add a host-local `flock` around the critical section in `cursor-set.sh` —
acquire before `ensure_clone`/`sync_clone`/the working-tree mutation, hold
through `git add`/`commit`/push, release after. Use a lock file under
`$GARDEN_STATE` (not the journal clone itself), e.g.
`$GARDEN_STATE/cursors/cursor-set.lock` (or scoped per the `$DIR` if you
decide different `GARDEN_CURSOR_CLONE` overrides should serialize
independently — check whether any caller actually overrides that env var
before deciding scope; if none do, one lock file is simplest and correct).
Use a bounded `flock -w <timeout>` (not an unbounded wait) so a genuinely
wedged holder doesn't permanently starve every other cursor-writer on the
host — pick a reasonable timeout and fail loudly (not silently) if it
expires, so a real wedge surfaces instead of hanging forever.

Audit whether any OTHER script in `scripts/jobs/` shares a similarly
unlocked, multi-caller-shared local clone (grep for other `$GARDEN_STATE/
*/journal`-shaped paths reused across more than one caller) — fix this
specific one first, but flag any sibling hazard you find rather than fixing
only the one that happened to be caught live.

## Verify

A real concurrency test: spawn two `cursor-set.sh` invocations against
different keys at the same instant (or as close as a test harness can
force) and confirm both land correctly with no `fatal: unable to write new
index file`, rather than only asserting the lock is acquired in isolation.

## Report

Confirm the `endojs-endo-but-for-bots` comment-watcher's cursor is
currently advancing normally again (it may have already recovered on its
own by the time you pick this up — check `last_polled_at` freshness either
way and say so).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-21T21:21:39Z
