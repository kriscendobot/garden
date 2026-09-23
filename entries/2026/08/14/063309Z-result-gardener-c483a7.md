---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-14T06:33:14Z
---
# result: scholar-relative-routing-miller — ingest Mark Miller's "relative routing"

Ingested Mark Miller's notion of **relative routing** into the cross-cutting
reference library, abstracted and derived per the scholar conventions
(erights' public-domain / derived-from-not-the-original framing carried
explicitly on every file).

## Sources ingested (2 web sources, 2 sections)

- `erights--elib-distrib-captp-providefor` (http://erights.org/elib/distrib/captp/provideFor.html, Mark S. Miller, public domain; content SHA-256 `3aa67ebe`, fetched via erights.github.io mirror 2026-08-14) — 1 section: the three-vat Granovetter introduction narrative (nonce deposit/withdraw, `vatASearchPath`, E-Order).
- `erights--elib-distrib-captp-acceptfrom` (http://erights.org/elib/distrib/captp/acceptFrom.html, Mark S. Miller, public domain; content SHA-256 `0f1876e8`, mirror 2026-08-14) — 1 section: the `acceptFrom(donorPath :String[], ...)` route-list op — the primary erights grounding for relative routing.

## Concept page (the centerpiece)

- `concepts/relative-routing.md` — new. Core idea (identity is durable, reachability is a plural/ephemeral set of candidate routes; nearest-shortest-most-reliable chosen at connect time); the erights grounding (`donorPath`/`vatASearchPath` search path); the CapTP/OCapN connection-hints mapping (peer locator designator+transport vs hints; Endo `@hint` locator URL; hints-are-ephemeral discipline). "Sections that touch this concept" table links the 2 new erights sections plus 7 existing corpus sections (peer-locator, third-party-handoffs, ode-protocol/Pluribus, connection-hints-ephemeral, dlt locator-format, ocapn-noise transport-plugins-and-hints, dani per-agent-connection-hints). See-also + common-confusions included.

## Project note

- `projects/minion-town/ocap-mailbox-relative-routing.md` — new. Frames the ocap-mailbox adapter's email-backed synthetic guest and in-daemon OCapN-over-Noise session as two *routes* (connection hints) to one peer, short-circuiting to the nearest reliable path; cites the PR #37 review directive.

## Indexes touched

- `topics/captp.md` — +2 section rows (via insert-sections-table-row.sh).
- `concepts/README.md` — +1 row (relative-routing).
- `keywords.md` — +2 pointer lines (relative routing / donorPath families).
- `sources/README.md` — +2 rows.
- `projects/minion-town/README.md` — added a `## Topic notes` index section (+1 row).
- `sections/README.md` and `topics/README.md` Sections-count column — regenerated as the final landing step (regenerate-sections-index.sh, regenerate-topics-counts.sh); captp topic count 62→64.

## Integrity gate (step 8) — PASS

- `library-link-check.sh --changed` and per-source-slug on both new clusters: OK, every link resolves to a committed file.
- `regenerate-topics-counts.sh --check`: current (idempotent) after land.
- All 11 content files landed through land-journal-edit.sh (producer-clone CAS); verified present on origin/journal2 tip.

## Follow-ups / deferred

- The broader erights CapTP `elib/distrib/captp/` hub (4tables, resolving, dagc, partition, SturdyRef, LocatorUnum/NonceLocator, WormholeOp, the OMG presentation) remains un-ingested; only the two routing-relevant pages were taken this cycle (concept-scoped job, within budget). A future `scholar-ingest-erights-captp` job could ingest the rest of the protocol as a full source cluster.
- No follow-on job posted (the concept ask is complete); the CapTP-hub remainder is noted here rather than posted, as it is a distinct, larger ingestion not implied by this job.

Self-improvement: the erights CapTP pages self-declare public domain (stronger than the derived-from license), yet the derived-from-not-the-original framing still reads correctly on every file — the convention degrades gracefully when the source license is more permissive than assumed, so no special-casing was needed.
