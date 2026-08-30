---
created: 2026-06-01
updated: 2026-08-30
author: gardener, builder
---

# Skill: gardener-inbox-error-reporting

The uniform pattern for any job-board service or worker shell script to
trap an unexpected error, capture the failure transcript via
`git hash-object`, commit it as a content-addressed file under
`journal/inboxes/<host>/captures/<sha>` so the SHA is reachable to
every off-host responder, and append a message section to
`journal/inboxes/<host>/gardener.md` that names it. The gardener role
reads that inbox on its next dispatch.

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

The transcript lands twice: as a blob in the journal clone's object
database (`hash-object -w`, immediately, even with no network) and as a
tracked file `inboxes/<host>/captures/<sha>` committed alongside the
appended inbox section at HEAD of the `journal2` branch. The second is
what carries it off-host.

## Procedure

1. **Resolve the journal worktree.** From `$GARDEN_JOURNAL` if set,
   otherwise `$GARDEN_ROOT/journal` (the worktree of the `journal2`
   branch). Fail loudly if neither resolves to a journal worktree.

2. **Hash the transcript.**

   ```sh
   TRANSCRIPT_SHA=$(git -C "$GARDEN_JOURNAL" hash-object -w --stdin < "$TRANSCRIPT")
   ```

   An empty transcript is replaced by a synthetic self-describing line
   (never escalate the zero-byte blob `e69de29b…`), and a transcript
   over `GARDEN_REPORT_ERROR_MAX_BYTES` (default 64 KiB) is truncated
   to bounded beginning and ending slices *before* hashing, with an
   explicit marker reporting how many middle bytes were omitted. The
   SHA therefore always names exactly the bytes a responder will read.
   The caller's file is never mutated; both rewrites stage a temp copy.

2b. **Commit the transcript as a content-addressed capture file.**

   ```sh
   cp "$TRANSCRIPT" "$GARDEN_JOURNAL/inboxes/$GARDEN/captures/$TRANSCRIPT_SHA"
   ```

   `hash-object -w` alone writes a **loose** blob: it lives in the local
   clone's object DB and nothing in the pushed history points at it, so
   `git push HEAD:journal2` does not carry it and every off-host
   responder — the central mentor — gets an escalation naming a SHA it
   cannot `cat-file`. Writing the same bytes to a tracked file named by
   the SHA puts the blob in the pushed **tree**, so it rides the same
   push as the inbox section and resolves after a plain `journal2`
   fetch. The path *is* the SHA, so the write is idempotent and deduped
   across repeated escalations of identical content.

   (The companion
   [`prompt-on-failure-capture`](../prompt-on-failure-capture/SKILL.md)
   skill — and `capture_blob` / `anchor_blob` in `common.sh` — own the
   capture-and-anchor primitives; this skill is the inbox-append form,
   and the committed capture file is what makes its SHA reachable
   off-host. A caller using this skill does **not** additionally need
   `anchor_blob`: `refs/captures/*` is not retrieved by an ordinary
   fetch, so it is the weaker route, useful only as a fallback when this
   escalation fails outright.)

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
   - Capture: inboxes/<host>/captures/<transcript-sha>

   Inspect via `git -C journal cat-file -p <transcript-sha>` (or read
   `journal/inboxes/<host>/captures/<transcript-sha>`) -- both work
   off-host after a plain `journal2` fetch.
   ```

4. **Commit and push.** Stage **both** the inbox file and the capture
   file (the section names the SHA; the capture is what makes that SHA
   reachable — one commit, so a responder never reads a section whose
   capture is missing), then use the same retry-on-rejection loop as
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

- **Transcript size is capped, because the capture is permanent.**
  A committed capture is not a loose blob git gc can reclaim: it is in
  `journal2`'s history, and every host pays for it on every fetch.
  `journal2` is deliberately *not* the transcript archive — that is the
  `transcripts2` orphan branch, and the fleet-wide fetch cost is exactly
  why ([`designs/transcript-journal-capture.md`](../../designs/transcript-journal-capture.md),
  Decision 1). An escalation attachment is a bounded exception to that,
  so the helper divides `GARDEN_REPORT_ERROR_MAX_BYTES` (default
  `65536`; `0` disables the cap) between bounded slices from the
  **beginning and end** before hashing. A banner describes the retained
  slices, and an explicit marker between them reports the number of
  omitted middle bytes. This preserves early setup and diagnostic
  context as well as the final failure. 64 KiB matches the amount of
  source transcript the fleet's capture readers consume. At the
  fleet's observed rate (~24 escalations/day across six hosts) the
  worst case is ~1.5 MiB/day and the realistic case far less. A caller
  that needs more can raise the cap for its invocation; a caller whose
  transcript is routinely megabytes is capturing too much (`set -x` on
  a loop with thousands of iterations) and should trim before
  calling.

- **Capture accumulation.** Captures are content-addressed and deduped,
  so repeats are free, but distinct failures accumulate one file each
  under `inboxes/<host>/captures/`. Deleting old capture files is safe
  and shrinks the working tree (the history still carries the bytes);
  no pruner exists yet — a noted follow-up, not a blocker at the
  current failure rate and the 64 KiB cap.

- **No-network fallback.** When the journal worktree's `origin` is
  unreachable, the skill still hashes the transcript, writes the
  capture file, and appends the inbox section to the local journal
  worktree; the push retry loop will eventually succeed once
  connectivity returns, carrying both. The transcript blob is durable
  as soon as `hash-object -w` writes it.

- **Concurrent failures.** Two services failing simultaneously each
  append their own section. The journal-sync rebase loop linearizes
  them. The inbox section order is loose (whoever pushes first wins
  the linearization race); the gardener's read handles either order.

- **Lane discrimination, not separate files.** Per the 2026-06-01
  design disposition (Q3), each caller writes to the shared
  `gardener.md` inbox with a lane-named section header. Per-lane
  separate inbox files would multiply the gardener's filesystem-walk
  cost without adding value; section headers are the discrimination.
