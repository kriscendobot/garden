# scholar-ingest-passable-equality — complete

Authored the sibling concept `library/concepts/passable-equality.md` deepening
pass-invariant equality from its Handle-side framing to the marshalling-level
invariant (`keyEQ` = `compareKeys === 0` over Keys; `sameValueZero` at atomic
leaves composing up through structural recursion over the copy collections;
key order a partial order refining the rank-order total order; preserved across
the canonical encoders). No source re-ingest: `compareKeys.js`/`checkKey.js`
verified current; `rankOrder.js`/`encodePassable.js` found drifted and handed to
a posted follow-on (`scholar-refresh-marshal-rankorder-encodepassable`).

Landed via land-journal-edit.sh: the new concept page, 13 `keywords.md` lines,
a `concepts/README.md` row, and `[[passable-equality]]` See-also cross-links on
`pass-invariant-handle-equality` and `rank-order-preserving-encoding`.
Cross-linked to grant-matcher-puzzle, pass-invariant-handle-equality,
smallcaps-encoding, rank-order-preserving-encoding, and object-sameness.

Integrity gate: `library-link-check.sh --nav` and `--files` both exit 0.
Result entry: entries/2026/06/27/145532Z-result-gardener-6fbf82.md.
