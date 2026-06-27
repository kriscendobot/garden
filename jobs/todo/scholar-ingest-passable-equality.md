<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-06-27T14:44:56Z -->

# scholar-ingest-passable-equality

Deepen **pass-invariant equality** beyond its current Handle-side framing.
`library/concepts/pass-invariant-handle-equality.md` covers the connector
`handleFor` guarantee; the broader marshalling-level equality invariant
(passable equality preserved across serialize/unserialize) is not yet ingested
as its own concept.

Ingest the in-corpus `@endo/marshal` and `@endo/patterns` equality machinery as
source/section pages and (likely) author a sibling concept `passable-equality`:
the `keyEQ` / `compareKeys` / `sameKey` / `isKey` family, the PassStyle rank
order vs key order distinction (`encodePassable` / `rankorder` — already
ingested as [[rank-order-preserving-encoding]]), and how `sameValueZero`-style
identity composes with structural equality of CopyRecord / CopyArray / CopyMap /
CopySet. Ground every claim in the actual `@endo/marshal` and `@endo/patterns`
source (much is already in `library/sources/` — check before re-ingesting per
the idempotency rule). Cross-link to [[grant-matcher-puzzle]] (the motivation),
[[pass-invariant-handle-equality]] (the Handle-side instance), and
[[smallcaps-encoding]] / [[rank-order-preserving-encoding]].
