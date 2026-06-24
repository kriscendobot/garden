# Tear down the live-tree partial WIP and unwedge the watchman (HIGH PRIORITY — garden-wide deploy outage)

Wear the **mentor** role. The `harden-fleet-gh-identity` gardener reported (maintainer
msg `20260624T223047Z-ff38ba`) that the **live `/home/kris` tree has uncommitted WIP
that WEDGES `garden-watchman`**: the watchman's fast-forward aborts on a dirty working
tree, so **origin/main2 is not auto-deploying to the live tree garden-wide**. The live
tree is stuck at `51030653`; **origin/main2 is 9 commits ahead** and NOT live.

## Liaison investigation (verified — the WIP is already committed)

The live uncommitted edits are **redundant duplicates of work already on origin/main2**.
Multiple jobs edited the live tree directly (to make fixes "live" while the watchman
was wedged) AND committed the same work to main2 via isolated worktrees. Confirmed:
- live `common.sh` flock serialization == `origin/main2` commit **`0f49238b`**
  ("harden producer push path — serialize shared clone + verify-after-push").
- the other dirty files map to the other 8 stuck commits: comment-watcher
  (`fb7a73d6`), bulletin job-descriptions (`07c548e4`) + message links (`4fa4c29f`),
  fleet gh identity incl. `scripts/jobs/bin/gh` (`11240ac2`), the timer integration
  test (`f757e17e`), the mentor journalctl timeout (`d171bbef`), and the README
  reframe (`0abc27e2`).

So no work is at risk; the task is a **safe teardown** so the watchman can deploy.

## Task

1. **Verify equivalence (safety first).** For every dirty path in the live tree
   (`git -C /home/kris status --short`; tracked-modified AND the untracked
   `scripts/jobs/bin/`), diff the live content against `origin/main2`'s version and
   confirm it is already represented there. **If ANY file carries a live-only delta
   not on origin/main2, capture it as a patch and land it properly (commit to main2
   via an isolated worktree) BEFORE discarding** — never lose work. (`git -C /home/kris
   diff` re-derives the WIP snapshot.)
2. **Tear down the partial.** Once verified redundant: `git -C /home/kris checkout --`
   the dirty tracked files and remove the redundant untracked `scripts/jobs/bin/`
   (already on main2 at `11240ac2`), leaving the working tree **clean**.
3. **Unwedge + deploy.** With the tree clean, run `scripts/jobs/watchman.sh` (or let it
   tick) so the live `/home/kris` tree fast-forwards `51030653 → origin/main2`
   (`0f49238b`), deploying all 9 commits. Restart services whose code changed and need
   it to pick it up — at least `garden-bulletin.service` (non-blocking), and confirm
   the comment-watcher timer fix (`fb7a73d6`) is now live (the timer actually fires).
4. **Verify.** Live `main2` HEAD == `origin/main2`; the watchman no longer aborts;
   spot-check that previously-stuck fixes are live (comment-watcher fires on its timer;
   bulletin renders per-job descriptions + followable maintainer messages).
5. **Root-cause guard (prevent recurrence).** The cause is jobs editing the LIVE
   `/home/kris` tree directly instead of an isolated worktree, dirtying it and wedging
   the watchman silently. Implement (or post a follow-up for) a guard: jobs build in
   isolated worktrees and never leave the live tree dirty, AND/OR the watchman should
   **report/stash a dirty tree loudly** (a maintainer message) instead of silently
   wedging garden-wide. Note which you did.

## Definition of done

Live tree clean and fast-forwarded to origin/main2 (all 9 commits deployed), watchman
unwedged, affected services restarted and verified live, no work lost, and a
recurrence guard implemented or a follow-up posted. Report what was discarded vs
preserved, the deployed HEAD, and the guard. If a dirty file holds a live-only delta,
report it rather than discarding.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 16
  claimed_at: 2026-06-24T23:12:16Z
