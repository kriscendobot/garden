# scholar-refresh-marshal-rankorder-encodepassable

Refresh two drifted `@endo/marshal` longform-comment sources that back
[[rank-order-preserving-encoding]]. The `scholar-ingest-passable-equality`
cycle (2026-06-27) ran the idempotency check while authoring the
`passable-equality` concept and found both files drifted from their recorded
anchors:

- `packages/marshal/src/rankOrder.js` — recorded `source_commit`
  `e6192056a5d7ff5acb084f6a58dca3663aa9943e`; upstream `master` tip
  `337d16a895066a66e7c92d716449273d337dceb9`. Source page:
  `library/sources/endo--packages-marshal-src-rankorder-js.md`.
- `packages/marshal/src/encodePassable.js` — recorded `source_commit`
  `2e9333096fc82fabc9a3c1f6d3e268336e7df943`; upstream `master` tip
  `c423ed37b4c574aaccd778fc72acb2ff8910d586`. Source page:
  `library/sources/endo--packages-marshal-src-encodepassable-js.md`.

Re-read both at the current `master` shas, diff the comment clusters against
the existing section files, and re-ingest per `conventions.md` (new section
files with `supersedes:` + flip the prior sections' `status:` to `superseded`
only if the comment text changed materially; otherwise just bump
`source_commit` on the source/section frontmatter). The sibling patterns-side
key-equality sources (`compareKeys.js`, `checkKey.js`) were verified current
and need no refresh.

priority: low
