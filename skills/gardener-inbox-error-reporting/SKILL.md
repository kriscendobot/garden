---
created: 2026-06-01
updated: 2026-06-24
author: builder
---

# Skill: gardener-inbox-error-reporting

The uniform pattern for any job-board service or worker shell script to
trap an unexpected error, capture the failure transcript via
`git hash-object`, and append a message section to
`journal/inboxes/<host>/gardener.md`. The gardener role reads that
inbox on its next dispatch.

This skill is the shared body that the job-board services, every
per-role worker script, and the coalesced repo-activity watcher all
call from their ERR / EXIT traps. The discipline keeps unexpected
failures *visible to a human role* by default, rather than failing
silently into a transcript file the maintainer would have to remember
to inspect.

The capture-and-append targets the orphan **`journal2`** branch (v2's
job-board / message-bus branch — directory `journal`, branch
`journal2`, per `scripts/jobs/common.sh`); a v1-era copy that pushed to
`journal` would push to the wrong branch. The helper honors the
`JOURNAL_BRANCH` environment override (default `journal2`) so it stays
in step with `common.sh`.

## Inputs

The skill ships one helper:

### `report-error.sh --transcript <path> --lane <n> [--pr <id>] [--state <name>] [--context <one-line>]`

`--transcript <path>` is the file the caller's `-x` subshell wrote.
`--lane <n>` is the originating lane or service id (or `0` for
non-lane callers like a generic worker script).
`--pr <id>` is the PR identifier (`<owner>/<repo>#<n>`) when the failing
work was PR-bound.
`--state <name>` is the workflow state at the time of failure.
`--context` is a one-line description the caller writes; helpful for
maintainers grepping the inbox.

Output: the transcript SHA on stdout. Exits non-zero if the journal
worktree is not reachable.

## State

None. The transcript blob lands in the journal clone's object database;
the appended inbox section lands at HEAD of the `journal2` branch.

## Procedure

1. **Resolve the journal worktree.** From `$GARDEN_JOURNAL` if set,
   otherwise `$GARDEN_ROOT/journal` (the worktree of the `journal2`
   branch). Fail loudly if neither resolves to a journal worktree.

2. **Hash the transcript.**

   ```sh
   TRANSCRIPT_SHA=$(git -C "$GARDEN_JOURNAL" hash-object -w --stdin < "$TRANSCRIPT")
   ```

   The blob is unreferenced. Promotion to `refs/captures/...` is the
   caller's call; this skill does not auto-promote. (The companion
   [`prompt-on-failure-capture`](../prompt-on-failure-capture/SKILL.md)
   skill — and `capture_blob` / `anchor_blob` in `common.sh` — own the
   capture-and-anchor primitives; this skill is the inbox-append form,
   which makes the blob reachable off-host by committing a file that
   references it.)

3. **Append a message section to the gardener inbox.** The inbox file
   lives at `journal/inboxes/<host>/gardener.md`. If it does not exist
   yet, create it with frontmatter and an introductory paragraph. The
   appended section names the lane in its heading so the gardener can
   filter or order by lane:

   ```markdown
   ## lane <n> — <state> failure at <ISO timestamp>

   - PR: <pr-id or "(none)">
   - State: <state>
   - Transcript SHA: <transcript-sha>
   - Context: <one-line>

   Inspect via `git -C journal cat-file -p <transcript-sha>`.
   ```

4. **Commit and push.** Use the same retry-on-rejection loop as
   `skills/journal-sync/SKILL.md`, pushing `HEAD:$JOURNAL_BRANCH`
   (`journal2` by default). The commit message is
   `inboxes(gardener): error from lane <n> state <state>`.

5. **Print the transcript SHA on stdout** and exit zero. The caller
   typically discards stdout (the trap is firing on its way to
   non-zero exit) but the SHA is useful for ad-hoc invocations from
   the maintainer's shell.

## Output shape

The appended inbox section is the durable output. Each section is a
discrete failure event, ordered append-only. The gardener processes
one section at a time.

## Notes

- **Lane 0 for non-lane callers.** A worker script that wants to use
  this skill (after a non-lane dispatch posts a failure) passes
  `--lane 0`, and the section heading reads `lane 0 — <state>`,
  conventionally read as "non-lane origin." The gardener treats lane 0
  the same as any other lane.

- **Relationship to the v2 message bus.** v2's primary point-to-point
  channel is the per-doer `inbox/<doer>/{unread,read}` and the
  `msgs/role/gardener` topic (see
  [`message-bus`](../message-bus/SKILL.md)). Those are addressed to a
  *live* doer or polled by *working* gardeners; this skill's
  shared-file `inboxes/<host>/gardener.md` is the durable, host-scoped
  failure log that survives when no gardener is currently working that
  host — the right shape for an ERR-trap firing from a deterministic
  service. Reconciling the two surfaces (e.g. also emitting a
  `msgs/role/gardener` ping on append) is a noted follow-up, not part
  of this port.

- **Transcript size.** `git hash-object` happily ingests megabytes;
  the journal repo's git gc cleans up unreferenced blobs after the
  grace window. A failure transcript larger than ~10MB suggests the
  caller is capturing too much (`set -x` on a loop with thousands of
  iterations); trim before calling.

- **No-network fallback.** When the journal worktree's `origin` is
  unreachable, the skill still hashes the transcript and writes the
  inbox section to the local journal worktree; the push retry loop
  will eventually succeed once connectivity returns. The transcript
  blob is durable as soon as `hash-object -w` writes it.

- **Concurrent failures.** Two services failing simultaneously each
  append their own section. The journal-sync rebase loop linearizes
  them. The inbox section order is loose (whoever pushes first wins
  the linearization race); the gardener's read handles either order.

- **Lane discrimination, not separate files.** Per the 2026-06-01
  design disposition (Q3), each caller writes to the shared
  `gardener.md` inbox with a lane-named section header. Per-lane
  separate inbox files would multiply the gardener's filesystem-walk
  cost without adding value; section headers are the discrimination.
