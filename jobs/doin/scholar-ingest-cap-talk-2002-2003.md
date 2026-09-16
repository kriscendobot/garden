---
role: scholar
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ingest cap-talk: 2002-2003

Continue the cap-talk archive ingest with the 2002-2003 era, the era in which
Miller-Yee-Shapiro's *Capability Myths Demolished* (2003) and Miller-Shapiro's
*Paradigm Regained* (2003) were written. Watch for primary-source discussion
prefiguring or reacting to those papers (the Equivalence/Confinement/
Irrevocability myths, the four models, permission-vs-authority).

The 2000-2001 slice is done: source-index `library/sources/cap-talk-2000-2001.md`
(10 sections), landed by `scholar-ingest-cap-talk-2000-2003` (2026-09-16). Follow
the same `source_kind: mailing-list-archive` shape and the per-era partition in
`library/sources/cap-talk-1998.md`.

## Source and acquisition

Mailman/Pipermail archive at `http://www.eros-os.org/pipermail/cap-talk/` (host
offline; fetch from the Internet Archive `id_` capture). The availability API
(`archive.org/wayback/available`) was rate-limiting (429/503) during the
2000-2001 cycle; the reliable path was a CDX query
(`http://web.archive.org/cdx/search/cdx?url=eros-os.org/pipermail/cap-talk/*`)
to enumerate captured `.txt.gz` bundles and their timestamps, then a direct
`id_` fetch per bundle. Confirmed-captured 2002-2003 months (partial CDX, may be
incomplete): 2002-April, 2002-June, 2002-July, 2002-August, 2002-November,
2002-December, 2003-January, 2003-April, 2003-June, 2003-July, 2003-August,
2003-December. Re-run the CDX enumeration for completeness. Each `.txt.gz`'s
content hash is the idempotency anchor; ingest from the decoded text. Note some
Wayback captures duplicate the bundle body 2-3x; ingest from the first copy.

Also worth a re-enumeration: 2000-2001 months beyond July/August/November were
not confirmed present (the CDX pass was partial), so a completeness check of
those two years belongs here too.

NOTE: the post-2016 Google Groups home is a JS SPA whose message bodies are not
fetchable from the sandbox; flag that gap if reached.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T16:09:50Z
