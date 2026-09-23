---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-16T14:12:11Z
---
---
kind: result
role: scholar
project: endo
---

# scholar-ingest-cap-talk-1999

Completed the founding-era continuation: 1998-April plus every 1999 month present in the Pipermail index (January, April, and June through December).

## Source acquisition

- Fetched 10 monthly `.txt.gz` bundles with `fetch-source.sh`; the offline canonical host fell back to Internet Archive `id_` original bytes.
- Recorded every bundle's SHA-256 in the year source indexes. The new `library/sources/cap-talk-1999.md` is a month-by-month provenance and survey map; `cap-talk-1998.md` now includes April.
- Preserved per-thread multi-author attribution. Every new section identifies itself as a derived summary, not the original messages.
- Reconfirmed the boundary: post-2016 Google Groups bodies remain unavailable to the sandbox; the gap stays documented.

## Ingested and indexed

- Added 14 thematic sections: three from April 1998 and eleven from 1999. Themes cover capability definition and delegation, dead-reference sameness, CGI confinement and authenticated capability buckets, shared-object lifetime, grant matching, single-level-store persistence, principal attribution through proxies, storage-GC covert channels, unforgeability techniques, DMA driver authority, seals and rights amplification, transaction failure, distributed capability RPC and closures, and the principal-policy debate.
- Grew the capability-security, capability-theory, persistence, revocation, CapTP, and eventual-send topics; updated five concept pages plus keyword shortcuts.
- Expanded `cap-talk-open-questions.md` from two to seven explicit contested questions.
- Extended `projects/endo/cap-talk-capability-provenance.md` with direct implications for Endo gateways, CapTP, retention, durable operations, and brands.

## Verification and landing

- `library-link-check.sh --library <staging>/library --source-slug cap-talk-1998`: OK; every checked link resolved.
- `library-link-check.sh --library <staging>/library --source-slug cap-talk-1999`: OK; every checked link resolved.
- `regenerate-topics-counts.sh --check --library <staging>/library`: current and idempotent after landing.
- `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` regenerated and landed both projected indexes.

Follow-ups: the already-posted later-era jobs (2000-2003, 2004-2008, 2009-2012, and 2013-2016) own the remaining ingestable Pipermail history. Post-2016 remains blocked on a fetchable export.

Self-improvement: nothing this time.
