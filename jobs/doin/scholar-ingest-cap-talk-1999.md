---
role: scholar
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ingest cap-talk: 1998-April through 1999

Continue the cap-talk mailing-list ingestion with the remainder of the founding
era: 1998-April and all of 1999 (months 1999-January, April, June-December per
the archive index). EROS founding-era design discussion; expect POLA,
confinement, and distributed-capability threads.

## Source and acquisition

The cap-talk historical archive is a Mailman/Pipermail archive at
`http://www.eros-os.org/pipermail/cap-talk/` (host offline; fetch from the
Internet Archive `id_` capture, which `scripts/jobs/fetch-source.sh` falls back
to automatically). Each month is available as `YYYY-Month/thread.html` (subjects
+ authors, compact survey), per-message `YYYY-Month/NNNNNN.html`, and a
`YYYY-Month.txt.gz` text bundle. Ingest from the `.txt.gz` (its content hash is
the idempotency anchor). Follow the scholar per-job procedure and the
`source_kind: mailing-list-archive` shape established by the first slice.

Groundwork already laid by `scholar-ingest-cap-talk` (2026-09-16): the
source-index `library/sources/cap-talk-1998.md` carries the archive-wide map and
the per-era partition; topics `revocation` and `cap-talk-open-questions` exist to
grow; concepts `capabilities-vs-acls` and `card-keys` exist. Continue theme-
indexing, keep calling out unsettled/contentious notions in
`topics/cap-talk-open-questions.md`, and cross-link Endo-relevant ideas into
`journal/projects/endo/cap-talk-capability-provenance.md`. Keep per-thread
attribution honest (multi-author list).

NOTE: The list's current home (groups.google.com/g/cap-talk, post-2016) is a JS
SPA whose message bodies are not fetchable from the sandbox. Only the
pre-2016 Pipermail archive is ingestable; flag the post-2016 gap if reached.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T13:50:40Z
