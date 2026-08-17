---
gate: deferred
priority: normal
role: scholar
posted_by: producer
posted_at: 2026-08-17T04:01:18Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ingest the cap-talk mailing list into the library

Source: https://groups.google.com/g/cap-talk (the cap-talk mailing list — the
long-running venue for object-capability / capability-security discussion;
erights and much of the ocap community post there).

## Task

Ingest cap-talk's messages as a library source per
`journal/library/conventions.md`, using the scholar's normal per-source
ingestion procedure (`roles/scholar/AGENT.md` § Per-job procedure).

This is a large, open-ended archive, not a single document — **break the
ingestion up however you judge best** (by thread, by year/era, by topic
cluster, whatever partitions cleanly) and post follow-on
`scholar-ingest-source` jobs for the remainder rather than trying to fit it
in one cycle. Treat this first job as the survey-and-first-pass cycle: get
the archive's shape (how far back it goes, roughly how many threads/messages,
what indexing the Google Groups UI exposes) and ingest a first faithful
slice, then hand off what's left.

## What the library entries should capture

Beyond the normal per-source/per-section ingestion, this source specifically
wants:

- **Indexing by theme**, not just chronology — group threads/messages into
  topic files (e.g. revocation, confused-deputy, capability vs. ACL,
  rights amplification, POLA, distributed capability protocols, ocap
  languages, whatever themes the archive actually clusters into) so another
  role can find "what has cap-talk said about X" in one or two queries.
- **Unsettled and contentious notions** — where the list has open
  disagreement or an idea that never converged. Call these out explicitly
  (a `topics/*.md` section or a dedicated note) rather than burying them in
  a neutral summary; the disagreement itself is often the useful signal.
- **Useful ideas for Endo** — flag anything that bears on Endo's design or
  open questions (capability revocation, sturdyrefs, ocap patterns, distributed
  object protocols, etc.) so it's discoverable from the Endo project tree, not
  just the library. Cross-link into `journal/projects/` where a concrete Endo
  connection is clear.

## Notes

- Google Groups pages are not always directly fetchable from the sandbox; use
  `scripts/jobs/fetch-source.sh` (direct → mirror → Internet Archive fallback)
  per the scholar's normal acquisition discipline rather than hand-rolling a
  fetch. If Google Groups itself resists all three paths for a given thread,
  say so in the job report rather than silently skipping — the maintainer may
  know an alternate archive/mirror (e.g. a mailing-list archive mirror,
  marc.info-style, or a downloadable mbox).
- Normal provenance/attribution discipline applies: this is a mailing list of
  many authors, not a single source's monograph — keep per-message/per-thread
  attribution honest in the source index rather than treating the archive as
  one authored work.
