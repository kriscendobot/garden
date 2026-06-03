---
created: 2026-06-01
updated: 2026-06-01
author: builder
---

# Skill: gardener-inbox-error-reporting

The uniform pattern for any driver or worker shell script to trap an
unexpected error, capture the failure transcript via `git hash-object`,
and append a message section to `journal/inboxes/<host>/gardener.md`.
The gardener role drains its inbox via `skills/inbox-drain/SKILL.md` on
its next dispatch.

This skill is the shared body that the driver, every per-role worker
script, and the coalesced repo-activity watcher all call from their ERR
/ EXIT traps. The discipline keeps unexpected failures *visible to a
human role* by default, rather than failing silently into a transcript
file the maintainer would have to remember to inspect.

## Inputs

The skill ships one helper:

### `report-error.sh --transcript <path> --lane <n> [--pr <id>] [--state <name>] [--context <one-line>]`

`--transcript <path>` is the file the caller's `-x` subshell wrote.
`--lane <n>` is the driver lane (or `0` for non-driver callers like a
generic worker script).
`--pr <id>` is the PR identifier (`<owner>/<repo>#<n>`) when the failing
work was PR-bound.
`--state <name>` is the workflow state at the time of failure.
`--context` is a one-line description the caller writes; helpful for
maintainers grepping the inbox.

Output: the transcript SHA on stdout. Exits non-zero if the journal
worktree is not reachable.

## State

None. The transcript blob lands in the journal's object database;
the appended inbox section lands at HEAD of the journal branch.

## Procedure

1. **Resolve the journal worktree.** From `$GARDEN_JOURNAL` if set,
   otherwise `$GARDEN_ROOT/journal`. Fail loudly if neither resolves to
   a worktree containing the orphan `journal` branch.

2. **Hash the transcript.**

   ```sh
   TRANSCRIPT_SHA=$(git -C "$JRN" hash-object -w --stdin < "$TRANSCRIPT")
   ```

   The blob is unreferenced. Promotion to `refs/captures/...` is the
   caller's call; this skill does not auto-promote.

3. **Append a message section to the gardener inbox.** The inbox file
   lives at `journal/inboxes/<host>/gardener.md`. If it does not exist
   yet, create it with frontmatter (matching the convention in
   `skills/inbox-drain/SKILL.md`) and an introductory paragraph. The
   appended section names the lane in its heading so the gardener can
   filter or order by lane:

   ```markdown
   ## driver lane <n> — <state> failure at <ISO timestamp>

   - PR: <pr-id or "(none)">
   - State: <state>
   - Transcript SHA: <transcript-sha>
   - Context: <one-line>

   Inspect via `git -C journal cat-file blob <transcript-sha>`.
   ```

4. **Commit and push.** Use the same retry-on-rejection loop as
   `skills/journal-sync/SKILL.md`. The commit message is
   `inboxes(gardener): error from driver lane <n> state <state>`.

5. **Print the transcript SHA on stdout** and exit zero. The caller
   typically discards stdout (the trap is firing on its way to
   non-zero exit) but the SHA is useful for ad-hoc invocations from
   the maintainer's shell.

## Output shape

The appended inbox section is the durable output. Each section is a
discrete failure event, ordered append-only. The gardener's drain
processes one section at a time.

## Notes

- **Lane 0 for non-driver callers.** A worker script that wants to
  use this skill (after a non-driver dispatch posts a failure) passes
  `--lane 0`, and the inbox section heading reads `driver lane 0 —
  <state>` which is conventionally read as "non-driver origin." The
  gardener role's drain treats lane 0 the same as any other lane.

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

- **Concurrent failures.** Two drivers failing simultaneously each
  append their own section. The journal-sync rebase loop linearizes
  them. The inbox section order is loose (whoever pushes first wins
  the linearization race); the gardener's drain handles either order.

- **Lane discrimination, not separate files.** Per the 2026-06-01
  design disposition (Q3), each driver writes to the shared
  `gardener.md` inbox with a lane-named section header. Per-lane
  separate inbox files would multiply the gardener's filesystem-walk
  cost without adding value; section headers are the discrimination.
