---
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Jonathan S. Shapiro, Gregory Frascadore, Charles Landau, Jim Dennis, Andrej Presern, Dru Nelson, Norman Hardy, Ben Laurie]
source_date: 1998-03 to 1998-04
retrieved: 2026-09-16
ingested: 2026-09-16
ingested_by: scholar
section_count: 11
status: current
notes: |
  Founding-year slice of the cap-talk mailing-list archive (March-April 1998).
  Multi-author list — per-thread attribution is carried in each section's
  source_authors, not treated as one authored work. Fetched from the
  Internet Archive because the canonical host (eros-os.org) is offline.
  The top-level source_content_sha256 remains the March bundle's anchor for
  backward compatibility; the April bundle and its hash are recorded below,
  and each derived section carries its own monthly bundle hash.
---

Abstract: The cap-talk mailing list is the long-running venue for object-capability and capability-security discussion, founded by Jonathan S. Shapiro (creator of the EROS operating system) in March 1998 and seeded from the EROS architects list. Its historical archive (March 1998 through January 2016, before the list migrated to Google Groups) survives as a Mailman/Pipermail archive on the now-offline `eros-os.org`, captured by the Internet Archive. This source file covers **March and April 1998**: Shapiro's real-time answers to a newcomer's "aren't ACLs and capabilities equivalent?" intuition, the token-versus-identity distinction, ACL-on-capability asymmetry, revocation by destroyable indirection, stable identity after destruction, and confinement of web applications. The derived sections are summaries, not the original messages.

## The cap-talk archive (map)

- **Current home:** [groups.google.com/g/cap-talk](https://groups.google.com/g/cap-talk). The Google Groups web UI is a JavaScript single-page app whose message bodies load through application requests; a plain `fetch-source.sh` (curl) does not yield a stable mailbox source, and the legacy `_escaped_fragment_` crawl endpoint now just redirects. **Google Groups message bodies are therefore not directly fetchable as a corpus from the bot sandbox.** The 2013-2016 completion survey found no public cap-talk mbox or alternate mirror. Google Takeout or Vault may provide an authorized member/administrator export, but that is not a public fetchable source.
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
| [2013-2016](cap-talk-2013-2016.md) | 2013 through 2016-January | complete captured Pipermail endpoint: 24 independently hashed bundles and 22 derived thread sections; no 2014-September or 2015 bundle exposed |
| post-2016 | Google Groups | blocked on an owner/member-provided export; no public alternate mbox or mirror found in the completion survey |

## Monthly bundle anchors

Each `.txt.gz` bundle is an independent immutable source. Its SHA-256 is the idempotency anchor carried by sections derived from that month.

| Month | Original-bytes snapshot | SHA-256 |
|---|---|---|
| 1998-March | `web/2id_/.../1998-March.txt.gz` | `a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af` |
| 1998-April | `web/2id_/.../1998-April.txt.gz` | `15da6c5c47a7a927899b39778eb859e19fb64907f5fec97151eba49960fe76b8` |

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

## Sections (1998-April)

| Section | Topics | Status |
|---------|--------|--------|
| [capability-definition-and-delegation](../sections/cap-talk-1998--capability-definition-and-delegation.md) | capability-theory, capability-security | current |
| [dead-object-sameness](../sections/cap-talk-1998--dead-object-sameness.md) | capability-theory, revocation | current |
| [cgi-confinement-and-capability-buckets](../sections/cap-talk-1998--cgi-confinement-and-capability-buckets.md) | capability-security, capability-theory, cap-talk-open-questions | current |
