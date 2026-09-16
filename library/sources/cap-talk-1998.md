---
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Jonathan S. Shapiro, Gregory Frascadore, Charles Landau, Jim Dennis, Andrej Presern, Dru Nelson]
source_date: 1998-03
retrieved: 2026-09-16
ingested: 2026-09-16
ingested_by: scholar
section_count: 8
status: current
notes: |
  First slice of the cap-talk mailing-list archive (founding era, 1998).
  Multi-author list — per-thread attribution is carried in each section's
  source_authors, not treated as one authored work. Fetched from the
  Internet Archive because the canonical host (eros-os.org) is offline;
  idempotency anchor is the content hash of the 1998-March.txt.gz monthly
  archive, not a git SHA. See the archive-wide map below for provenance and
  the per-era follow-on plan.
---

Abstract: The cap-talk mailing list is the long-running venue for object-capability / capability-security discussion, founded by Jonathan S. Shapiro (creator of the EROS operating system) in March 1998 and seeded from the EROS architects list. Its historical archive (March 1998 through January 2016, before the list migrated to Google Groups) survives as a Mailman/Pipermail archive on the now-offline `eros-os.org`, captured by the Internet Archive. This source file covers the **founding month (March 1998)** as the first faithful slice: Shapiro's real-time answers to a newcomer's "aren't ACLs and capabilities equivalent?" intuition, which lay out — five years before *Capability Myths Demolished (2003)* formalized them — the token-vs-identity distinction, the ACL-builds-on-capabilities asymmetry, revocation by destroyable indirection, and the definitional dispute over what counts as "a capability." Remaining eras are deferred behind follow-on `scholar-ingest-source` jobs (see below).

## The cap-talk archive (map)

- **Current home:** [groups.google.com/g/cap-talk](https://groups.google.com/g/cap-talk). The Google Groups web UI is a JavaScript single-page app whose message bodies load via an authenticated XHR; a plain `fetch-source.sh` (curl) retrieves only the SPA shell and thread titles, and the legacy `_escaped_fragment_` crawl endpoint now just redirects. **Google Groups message bodies are therefore not directly fetchable from the bot sandbox** (documented as a blocker in this cycle's `result`; the maintainer may know an alternate export/mbox for the post-2016 messages).
- **Historical archive (the usable source):** the Mailman/Pipermail archive at `http://www.eros-os.org/pipermail/cap-talk/`, spanning **March 1998 through January 2016** (188 monthly archives). The host is offline (HTTP 522), but the archive is captured by the Internet Archive and fetched via the `id_` original-bytes recipe (`fetch-source.sh` falls back to it automatically). Each month is available as threaded HTML (`YYYY-Month/thread.html`, `subject.html`, `author.html`, `date.html`), per-message HTML (`YYYY-Month/NNNNNN.html`), and a downloadable `YYYY-Month.txt.gz` mbox-style text bundle. Ingest from the `.txt.gz` bundle (its content hash is the idempotency anchor).
- **Provenance / attribution:** a mailing list of many authors. Each section names its thread's participants in `source_authors`; the archive is not treated as one authored work.

### Per-era follow-on partition

The archive is far larger than one cycle's budget. Suggested partition (each a follow-on `scholar-ingest-source` job, oldest-first):

| Era | Months | Rough theme |
|-----|--------|-------------|
| 1998-1999 (remainder) | 1998-April onward, 1999 | EROS founding-era design; POLA; confinement |
| 2000-2003 | ~2000-2003 | E language emergence; distributed capabilities; the Miller-paper era begins |
| 2004-2008 | ~2004-2008 | ocap patterns; web-key / CapDesk / Polaris; DVH confused-deputy revival |
| 2009-2012 | ~2009-2012 | JavaScript / Caja / SES; ACLs-don't; secure-EcmaScript |
| 2013-2016 | ~2013-2016 | later theory; run-up to the Google Groups migration |
| post-2016 | Google Groups | blocked on a fetchable export; see the blocker note above |

## Sections (1998-March)

| Section | Topics | Status |
|---------|--------|--------|
| [what-is-a-capability-swipe-cards-vs-keys](../sections/cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys.md) | capability-theory, capability-security | current |
| [card-keys-are-capabilities](../sections/cap-talk-1998--card-keys-are-capabilities.md) | capability-theory, capability-security | current |
| [creating-and-granting-capabilities](../sections/cap-talk-1998--creating-and-granting-capabilities.md) | capability-theory, capability-security | current |
| [acls-on-capabilities](../sections/cap-talk-1998--acls-on-capabilities.md) | capability-theory, capability-security | current |
| [capability-ids-and-indirection-revocation](../sections/cap-talk-1998--capability-ids-and-indirection-revocation.md) | capability-security, revocation | current |
| [acl-vs-capability-challenge-problems](../sections/cap-talk-1998--acl-vs-capability-challenge-problems.md) | capability-theory, cap-talk-open-questions | current |
| [rescinded-keys](../sections/cap-talk-1998--rescinded-keys.md) | revocation, capability-security | current |
| [caos-capability-os-terminology](../sections/cap-talk-1998--caos-capability-os-terminology.md) | capability-security, cap-talk-open-questions | current |
