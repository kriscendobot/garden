---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1085-review-d35f5e0c
verdict: miss
category: process
pr: 1085
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
review_at: 2026-09-04T05:16:29Z
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1085#pullrequestreview-5109425602
identity: endojs/endo-but-for-bots#1085:review:5109425602
producing_role: builder
producing_job: endojs-endo-but-for-bots-mount-stream-glob-grep-build (design designs/mount-stream-glob-grep.md; no design build job in jobs/tada)
missed_by: code-panel scope (no existing-surface / sibling-composition equivalence check for a new exported API surface; the decomplector / ergonomist lens that owns it is design-panel-only)
severity: moderate
cluster: existing-cli-surface-equivalence
---

# Miss: streaming search API fused glob+grep instead of mirroring the eager composition seam on #1085

The maintainer review at `comment_url` (CHANGES_REQUESTED) objects, on the
implementation changeset, that the new streaming search API fuses globbing and
grepping into one primitive ("glorp") and asks that the grep-side operation
instead accept a **mandatory input stream of files** to grep. Re-fetch the exact
wording (inline comment id `3931082017`) at `comment_url`; this record is a
paraphrase, never the raw text.

## Grounds (miss)

Grounded in the repo, not the comment: the eager side of the same module already
exposed the two operations as an orthogonal composition seam — `grep(pattern,
glob(g))` — keeping enumeration and content-filtering separate. The new streaming
twin (`streamGrep(pattern, { glob, buffer })` in `packages/daemon/src/mount.js`)
diverged: it internally enumerates its own file set via `globPaths(...)`, braiding
the two concerns the eager sibling kept apart. A full code panel ran on this PR
(gauntlet `endojs-endo-but-for-bots-pr1085-gauntlet-20260901`, 29 seats, three
panel/fix rounds) and reviewed `streamGrep` in fine behavioral detail — the
100k-char line-length abort, `STREAM_BUFFER_MAX`, `buffer:0`/`batchSize:1` cost,
silently-ignored `maxResults` — yet no seat stepped back to the surface shape and
flagged the fusion against the pre-existing eager composition seam.

That is foreseeable, not new direction: the maintainer is enforcing an existing
convention already embodied in the same file (the eager `grep`/`glob`
composition), not stating a fresh requirement. The review-cycle mechanism is
identical to #658 (mount-path reader branches duplicating the CLI's slash-path
traversal) and #897 (pet-name path translation placed in the daemon Exo layer,
duplicating the CLI adapter's `parsePetNamePath`): a code panel approves a new
public surface without tracing the pre-existing equivalent surface, so redundant
or incoherently fused surface reaches maintainer review. The two seats whose
standing briefs own exactly this lens — the **decomplector** (complecting
orthogonal concerns into one primitive; minimum-viable-abstraction) and the
**ergonomist** ("do sibling operations spell similarly?"; "read the surface's
existing operations first") — are **design-panel-only** and never seat on a code
panel, so an implementation PR whose API shape diverges from an existing sibling
gets a code panel with no lens to catch it.

The single-loop code fix genuinely landed and exists in the world: builder job
`endojs-endo-but-for-bots-pr1085-streamgrep-mandatory-file-stream` decoupled the
signature to `streamGrep(pattern, files, { buffer })`, removed the internal glob
enumeration, and pushed `aa15e2478632ca0e0aef53ea06afd982db500601` to the draft
head with tests green. What is absent is the double-loop review-cycle check that
would let the panel catch the next such divergence instead of the maintainer.

## Threshold call

Joins `existing-cli-surface-equivalence` (was count=2 / prs={658, 897}). Third
member, third distinct PR → count=3 / prs={658, 897, 1085}, which meets the
default floor (K ≥ 3 misses across ≥ 2 PRs). The #897 record explicitly foretold
this member ("a third matching miss ... should join and trip a fresh threshold
call"). The three instances share one mechanism catchable by one durable check —
trace a new/changed public surface against its pre-existing sibling for
redundancy and compositional coherence — and the single-loop fixes keep
recurring PR-by-PR while the panel keeps missing the pattern. Dispatch one
`review-improve-existing-cli-surface-equivalence` builder job with the two-part
contract and a per-member re-litigation test.
