---
ts: 2026-05-13T05:02:56Z
kind: result
role: gardener
project: garden
to: liaison
refs:
  - entries/2026/05/13/045631Z-dispatch-liaison-266ec2.md
---

# Result: fifth standing monitor lands for kriskowal/garden, with the liaison-proxy dispatch asymmetry

Dispatch: [entries/2026/05/13/045631Z-dispatch-liaison-266ec2.md](045631Z-dispatch-liaison-266ec2.md) (gardener, scope verbatim).

## Files written

On garden `main`:

- `skills/monitor-garden/SKILL.md` (new). Issue-loud, non-issue-silent reactions; *Dispatch role asymmetry* subsection explains why the steward dispatches a `liaison` subagent rather than a `monitor` on this daemon's `NEW` lines.
- `roles/monitor/AGENT.md`: § Per-project skills appends the `garden` mapping with a one-sentence note on the asymmetric dispatch role; frontmatter `updated` and `author` bumped.
- `roles/steward/AGENT.md`: § Standing monitors table grows to six rows (the five repo monitors plus review-queue), with a footnote on the `garden` row's asymmetric dispatch and a complementary edit to the *Event consumption* paragraph; frontmatter `author` bumped.
- `CLAUDE.md`: § Current inventory appends `monitor-garden` to the per-project monitor-reaction skill list with a one-sentence asymmetry note.

On journal:

- `worktrees/endolinbot/watch-garden--monitor--20260513-045844.md` (new): standard schema, body paragraph naming the asymmetric dispatch.
- `worktrees/README.md` § Current entries: new row appended.
- `README.md` § Active worktrees and § Open monitors: "4 active standing monitors" -> "5", "5 long-lived poll daemons" -> "6", new daemon row added to the cadence list.

Host-only:

- `/home/kris/.git/info/exclude`: `.garden/` appended so the daemon's polling state directory does not appear in `git status` from any worktree of the shared admin tree. The file is in the admin tree itself (not in any working tree), so the change persists on this host but is not committed.

## Commit SHAs

Garden `main` (pushed to `origin/main`):

- `e2f2fab3bf35ab2b537b039fe41ee1ef21d42776` — monitor-garden skill: per-event reactions + liaison-proxy dispatch asymmetry
- `5ade2fe94e38293ca399da7df1e7da14d6f96fac` — monitor + steward + CLAUDE.md: name the fifth standing monitor (kriskowal/garden)

Journal (will push as part of this entry's batch):

- `39d4bad116ca2329a12040351ae79b4013cf97e7` — worktrees: kriskowal/garden standing monitor on endolinbot (5th)
- this entry — result

## Standing worktree + daemon

- Worktree: `/home/kris/worktrees/kriskowal-garden/watch-garden--monitor--20260513-045844/` (detached worktree of `main`, added off the shared admin tree at `/home/kris/.git/`).
- Daemon: PID `52973`, started at 05:01:45Z, cadence 60s, logs at `/tmp/garden-monitor-kriskowal-garden.{log,err,pid}`.
- First-poll outcome: a `NEW 30` batch on the first 200 (no prior `etag.txt` so the entire backfill of 30 most-recent events came through in one line). All thirty are `PushEvent@refs/heads/{journal,main}` from `kriscendobot`, dated 2026-05-13T02:34Z to 2026-05-13T04:56Z. Per the new skill, `PushEvent` is **silent**, so no liaison-proxy dispatch is owed for any of these. The first `NEW` batch is therefore the expected harmless backfill.

## Dispatch-role asymmetry, one sentence

When the steward scans daemon log tails on each cycle, every `NEW` line on the other four repo monitors (`endo`, `endo-but-for-bots`, `agoric-sdk`, `cosgov`) opens a `monitor` dispatch via `scripts/dispatch-prepare.sh monitor react-to-<repo>-events`, while a `NEW` line on the `garden` monitor opens a `liaison` dispatch via `scripts/dispatch-prepare.sh liaison react-to-garden-issue-<N>` instead, because issue activity on `kriskowal/garden` is meta-evolution work that routes to the liaison's authority directly.

## Verification

- `git -C garden push origin HEAD:main`: succeeded on attempt 1.
- `git -C garden log -2 --pretty='%h %s'` (post-push) shows both commits.
- `kill -0 52973`: exit 0 (alive).
- `tail /tmp/garden-monitor-kriskowal-garden.log` shows the `daemon starting` line at 05:01:45 and the first `NEW 30` batch on the same poll.

Self-improvement: when the dispatch root's `journal/` worktree is reset (step 1 of journal-sync, `reset --hard origin/journal` after fetching), in-progress unstaged edits in tracked files are wiped silently; the working tree of `worktrees/README.md` and `README.md` had to be re-applied after the reset. Future dispatches that prepare large multi-file journal edits should either commit first and rebase, or stash, before running journal-sync's step 1. Worth a *Notes from the field* row on `skills/journal-sync/SKILL.md`; flagged here as a candidate addition rather than landed inline.
