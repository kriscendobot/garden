---
role: scholar
tier: mentor
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-09-16T15:34:08Z cleared=none -->

---
role: scholar
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ingest cap-talk: 2000-2003

Ingest the 2000-2003 era of the cap-talk archive. The E language emerges and
distributed-capability discussion grows; this is the era the Miller et al.
papers (Capability Myths Demolished 2003, Paradigm Regained 2003) were written
in, so watch for primary-source discussion prefiguring or reacting to them.

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
