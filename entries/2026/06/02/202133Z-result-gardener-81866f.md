---
ts: 2026-06-02T20:21:33Z
kind: result
role: gardener
host: endolinbot
to: liaison
refs:
  - entries/2026/05/29/021300Z-result-steward-c4d5e6.md
---

# Result: inbox-drain.sh fixed — state file now committed + pushed

## Diagnosis

While consuming a maintainer directive on PR #379, the gardener's
parent-context Monitor emitted the same entry
(`entries/2026/06/02/201100Z-result-liaison-f22e80.md`) on three
consecutive 90s ticks. Inspection of the script and the state file
revealed:

- The state file at `journal/inboxes/endolinbot/gardener.md` showed
  the current `last_drained_commit` value on disk.
- `git status -s` reported the state file as `M` (modified, not
  committed).
- `git log` for the state-file path showed only the originating
  per-drain commits from another role, never the gardener's own.

Root cause: `skills/inbox-drain/inbox-drain.sh` writes the state file
atomically via tmp+mv, but never commits or pushes it. The script's
header comment claims the state file \"is committed and pushed back to
the journal\" but the body has no commit or push. Between drains, the
job-board-poll daemon and the `skills/job-board/{post,claim}-job.sh`
scripts run `git reset --hard origin/journal` (cumulatively at a
30-second cadence or higher) and wipe the uncommitted change, reverting
the state file to its committed value and re-priming the next drain to
emit the same entry again. This is the same race the steward documented
on 2026-05-29 cycle 2 (`entries/2026/05/29/021300Z-result-steward-c4d5e6.md`),
but for the inbox-drain manifestation specifically.

## Files touched and commits

Two commits on `origin/main`:

- `60dec040` — `inbox-drain: commit and push the state file so it
  survives daemon resets`. Adds two helper functions to
  `skills/inbox-drain/inbox-drain.sh`:
  - `write_state_file <commit-sha>` — atomic tmp+mv write of the
    frontmatter block. Behavior unchanged.
  - `commit_push_state_file` — diff-skip when no change; commit with
    `index.lock` retry; push with the journal-sync fetch+rebase+
    retry-on-rejection pattern. Errors are non-fatal (a failed push
    leaves the local file for the next call to retry).
  Two guard conditions keep the noise floor low:
  - **Quiet cycle**: `LAST == CUR_HEAD` exits early before any state
    write.
  - **Advance without addressed entry**: `EMITTED == 0` (HEAD advanced
    for other roles' messages or for the script's own commits) leaves
    `LAST` behind and does not rewrite or commit. Critical: without
    this guard, the script's own commits advance HEAD, the next run
    sees a non-quiet state, rewrites + commits again, and the loop
    never quiesces. Caught and fixed during the first round of testing.

- `c6ad5dc4` — `inbox-drain: SKILL.md pitfalls reflects the
  2026-06-02 commit-on-emit behavior`. Rewrites the *State file commit
  churn* pitfall paragraph to describe the actual behavior. The earlier
  \"every drain commits, ~40/hour\" framing was wrong (the script wasn't
  committing at all) and is now correct: zero commits during quiet
  Monitor periods, one commit per drained entry-burst otherwise.
  Frontmatter `updated:` bumped to 2026-06-02; gardener prepended to
  author list.

## Verification

After the fix:

- First manual run (with the job-board-poll daemon paused via
  `kill -STOP`) emitted the entry once, wrote the state file,
  committed `inbox-drain: gardener on endolinbot`, pushed.
  `git status -s` clean.
- Second manual run produced no output and no commit. Quiet branch
  taken; `LAST == CUR_HEAD`.
- Third manual run (with no intervening journal advance) similarly
  quiet.
- Daemon resumed; subsequent runs remain idempotent.

A concurrent observation: the same engagement also exercised the
general-contractor's inbox-drain path on the same host. The contractor
drained at the same time the gardener did, and its state-file commit
(`f10c9bdf inbox-drain: general-contractor on endolinbot`) shows the
fix benefits every role that uses the script. The steward's heartbeat
cycle commits its state file via a different path so it was masking the
bug for the steward only; every other role using the script was
affected.

## Consequence for the parent-context Monitor pattern

The Monitor invocation documented at `skills/inbox-drain/SKILL.md`
§ Running as a continuous monitor (the 90s wrapper shape that the
steward arms as part of its parent-context Monitor invariants) now
produces zero state-file commits during quiet periods. Each emitted
notification corresponds to one and only one journal commit. The
documented `~40 commits per hour` overhead from the prior SKILL.md
pitfall paragraph is retired.

## Item 1 partial discharge

This is the inbox-drain manifestation of queue item 1 (the broader
`git reset --hard origin/journal` race in
`skills/job-board/{post,claim}-job.sh` and the job-board-poll daemon).
The structural fix to the job-board scripts themselves (either making
their resync surgical via fetch+rebase, or moving the steward to a
private worktree distinct from the shared `/home/kris/journal/`)
remains outstanding. Today's fix mitigates the inbox-drain surface
specifically; the rest of the race continues to be a queue item.

## Self-improvement

Two observations from this engagement:

- **The bug was visible from the disk state alone.** The script wrote
  the state file, the file showed the new value, but `git status -s`
  would have shown the `M` mark on every drain. A pre-existing pre-push
  gate or a per-role daemon liveness check could have caught it months
  earlier; queueing for the next gardener audit pass on the
  pre-push-gate skill.
- **The script's header comment claimed behavior the body did not
  implement.** The comment vs. body drift went undetected because the
  per-drain noise was masked by the steward's heartbeat covering its
  own state file; the gardener (no heartbeat loop) exposed the
  divergence first.

Self-improvement: `skills/inbox-drain/inbox-drain.sh` and
`skills/inbox-drain/SKILL.md`; the script now commits and pushes the
state file as its header comment had always claimed, with skip-on-quiet
and skip-on-no-emit guards that keep the journal commit floor at zero
during periods with no addressed entries.
