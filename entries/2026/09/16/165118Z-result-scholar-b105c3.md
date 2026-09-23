---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-16T16:51:20Z
---
# result: cap-talk 2000-2003 CDX-completeness re-enumeration

Retried the full Internet Archive enumeration for `eros-os.org/pipermail/cap-talk/2000-*` through `2003-*` after the 2026-09-16 outage.

## Enumeration
- The CDX index was still in a hard 503 "Temporarily Offline" outage; the Wayback availability API was rate-limited (429). The `web.archive.org` playback endpoint (`web/<ts>id_/`) worked.
- Enumerated authoritatively from the Pipermail **archive index page** (capture 20160913020234, one fetch), which lists every monthly `.txt.gz`: **34 bundles** for 2000-2003.
- Compared against `library/sources/cap-talk-2000-2001.md` (11 recorded) and `cap-talk-2002-2003.md` (12 recorded) = 23 recorded, **0 phantom** rows.
- **11 previously omitted bundles found**: 2001-September; 2002-February, -March, -May, -September, -October; 2003-February, -March, -May, -September, -October.
- Fetched and SHA-256 anchored (hash over compressed `.txt.gz` bytes, matching the existing convention) and surveyed all 11.

## Ingested this cycle (6 sections across 5 months)
- `cap-talk-2002-2003--confused-deputy-redux-namespace-assignment` (2002-May) — capability-theory, capability-security
- `cap-talk-2002-2003--state-transition-model-of-trust-management` (2002-May) — capability-theory, capability-security, cap-talk-open-questions
- `cap-talk-2002-2003--persistent-capability-systems-on-microkernels-eros-vs-l4` (2002-October) — capability-security, capability-theory
- `cap-talk-2002-2003--authorization-versus-authentication` (2003-February) — capability-security, capability-theory
- `cap-talk-2002-2003--capability-myths-demolished-reception-and-usenix-rejection` (2003-March) — capability-theory, capability-security, cap-talk-open-questions
- `cap-talk-2002-2003--access-matrix-column-vs-row-distinction` (2003-May) — capability-theory, capability-security

## Anchored-only, deferred (survey notes recorded in the source files)
2001-September, 2002-February, 2002-March, 2002-September, 2003-September, 2003-October — deferred to follow-on **`scholar-ingest-cap-talk-2000-2003-remainder`** (posted).

## Pages touched
- Sources: `cap-talk-2000-2001.md` (+1 anchor, source_months, notes), `cap-talk-2002-2003.md` (+10 anchors, +6 section rows, source_months, source_authors, section_count 11→17, notes), `sources/README.md` (both rows: counts + notes).
- Topics: `capability-theory.md` (+6), `capability-security.md` (+6). `cap-talk-open-questions` is a curated meta page (no ## Sections table) — frontmatter tags only.
- Concepts: `confused-deputy.md` (+2), `capabilities-vs-acls.md` (+3).

## Integrity gate (step 8)
`library-link-check.sh --changed` exit 0 (all six new section targets resolve). `regenerate-topics-counts.sh --check` reported STALE counts only (informational; no missing topic page).

## Final landing
Regenerated `sections/README.md` (`regenerate-sections-index.sh`, exit 0, no DANGLING) and `topics/README.md` counts (`regenerate-topics-counts.sh`, exit 0). All content landed via `land-journal-edit.sh` (shared files with `--base-blob`).

## Note on tooling
The newest `fetch-source.sh` carries a bounded CDX fallback for availability-API rate-limits, but CDX itself was down this cycle. The Pipermail archive **index page** is a more robust enumeration source than CDX when CDX is offline — one `id_` fetch yields the authoritative month list. Worth encoding.
