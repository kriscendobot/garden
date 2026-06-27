<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-27T10:52:44Z -->

# scholar-ingest-grant-matcher-puzzle

Ingest the canonical source for the **Grant Matcher Puzzle** (Mark S. Miller,
erights.org E *equality* taxonomy) as a library **source page**, then promote
the existing draft concept `library/concepts/grant-matcher-puzzle.md` from
`status: draft` to `current`.

Canonical URLs (both unreachable — ECONNREFUSED — on 2026-06-27; erights.org is
intermittently down per `library/conventions.md` § PDF acquisition guidance):
- https://erights.org/elib/equality/grant-matcher/index.html
- http://www.caplet.com/security/taxonomy/grant-match/grant-matcher.html

When reachable, fetch the page, ingest it under the external-source schema
(treat as a web/standards-doc-style source; record the URL and a content hash as
the idempotency anchor), split into sections, and replace the concept's
external-lineage banner with grounded citations. The concept already maps the
puzzle's two questions (equality ↔ [[pass-invariant-handle-equality]]; transport
↔ [[three-party-handoff]]) and the POLA protection; verify those against the
primary source and correct any drift. Also consider the wider E *equality*
taxonomy pages (pass-by-construction, pass-by-proxy, sameness) as adjacent
sources worth a second follow-on.
