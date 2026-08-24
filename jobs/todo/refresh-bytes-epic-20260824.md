---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Refresh `references/bytes-epic.md` on `journal2` — the liaison-maintained
maintainer reference for the passable-byte-arrays PR cluster on
`endojs/endo-but-for-bots` (frozen Uint8Array / immutable ArrayBuffer,
plus the `@endo/hex` codec thread):
https://github.com/kriscendobot/garden/blob/journal2/references/bytes-epic.md

This is a recurring refresh of an existing document — its own header says
"Maintained by the liaison for reference; update as PRs land," but this is
substantial live-research synthesis work (re-verify dozens of PR states via
the GitHub API), so it goes through the board like `refresh-pr-review-sequence`
did, not a hand-edit. It is quite stale: **last refreshed 2026-07-02**, and
the file's own "In-flight" table still lists #572/#475/#503/#472/#586 as if
current, while #475 in particular has moved enormously since.

## What has changed since the 2026-07-02 snapshot (from this week's
## pr-review-sequence.md refresh — verify each of these live, don't just
## transcribe this list)

Per the 2026-08-23 `pr-review-sequence.md` refresh, PR #475 is now "the
broad, integrated line": advanced from a stale frozen base to a fresh `llm`
snapshot and retconned; consolidated `frozenBytes`/`thawedBytes` in
`@endo/immutable-arraybuffer`, carried through bytes/marshal/OCapN/
thixotrope/pass-style/docs/types/changesets; completed DataView emulation;
added hardened262, test262, XS, SES, bytes, and pass-style coverage
including a TextEncoder/TextDecoder intersection matrix. Confirm #475's
current state (open/merged/base/CI/mergeability) live rather than assuming
that summary is still current by the time this job runs.

## What to do

- Individually re-verify, live via the GitHub API, the state (open/merged/
  closed/draft), base branch, and mergeability of every PR currently listed
  in the file: #572, #475, #503, #472, #586, #580, kriscendobot/agoric-sdk#7,
  #473, #468, #449, #435, #451, #140, #57, #429, #430, #417, #56, #27. Do not
  assume any of these are still in the state the file records.
- Update "In-flight (open) — upstream-bound", "@endo/hex codec thread",
  "Landed (merged) — substrate / context", "Closed / superseded", and "Stack
  order (current)" to match live reality. A PR that moved from open to merged
  moves from "In-flight" to "Landed"; a PR that closed without merging moves
  to "Closed / superseded" with a one-line reason, same as the existing
  entries' style.
- Check for any NEW PR in this cluster the file doesn't yet list (search
  `endojs/endo-but-for-bots` for open/recently-merged PRs touching
  `immutable-arraybuffer`, `pass-style` byte-array work, or `@endo/hex` that
  post-date 2026-07-02).
- Preserve the file's existing structure and tone (it's a maintainer-facing
  epic tracker, not a full PR-review-sequence-style document) — this is a
  content refresh, not a redesign. Update the "Last refreshed" date line.
- Validate every PR/issue link in the file resolves to a real, canonical
  GitHub URL.
- Land through an isolated producer clone with a fetch/rebase/push CAS loop,
  same discipline as `refresh-pr-review-sequence-20260823` used. The
  accepted commit should touch only `references/bytes-epic.md`.

## Out of scope

Do not touch `pr-review-sequence.md` or any other reference file. Do not
open, review, comment on, or merge any of the PRs surveyed — this is a
read-only status refresh.
