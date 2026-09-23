---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-09-16T13:51:38Z
---
---
kind: result
role: scholar
project: endo
---

# scholar-ingest-cap-talk — founding-era first pass

Survey-and-first-pass cycle for the cap-talk mailing list (object-capability /
capability-security discussion, founded 1998 by Jonathan Shapiro of EROS).

## Archive shape (survey)

- **Current home** groups.google.com/g/cap-talk is a JavaScript SPA; message
  bodies load via an authenticated XHR and are NOT fetchable from the sandbox
  (plain curl gets only the shell + thread titles; the legacy
  `_escaped_fragment_` crawl path now just redirects). Documented as a blocker
  for the post-2016 messages.
- **Historical archive (the usable source)** is the Mailman/Pipermail archive at
  `http://www.eros-os.org/pipermail/cap-talk/`, spanning **1998-March through
  2016-January** (188 monthly archives). Host offline (HTTP 522); fetched via the
  Internet Archive `id_` recipe (fetch-source.sh auto-fallback). Each month:
  threaded HTML, per-message HTML, and a `.txt.gz` bundle. Idempotency anchor is
  the `.txt.gz` content hash.

## Ingested (first slice: 1998-March founding month)

New source `library/sources/cap-talk-1998.md` (source_kind mailing-list-archive;
1998-March.txt.gz content SHA-256 `a88db289`), 8 thread-based sections, honest
per-thread attribution:

- `cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys` (Frascadore) — the seeding equivalence intuition.
- `cap-talk-1998--card-keys-are-capabilities` (Shapiro) — token vs identity; ACL-on-cap not cap-on-ACL; confinement provably unsolvable with ACLs.
- `cap-talk-1998--creating-and-granting-capabilities` (Shapiro) — space bank; holder-discretion granting; storage accounting vs GC; connectivity rule.
- `cap-talk-1998--acls-on-capabilities` (Shapiro) — group-manager+user-object recipe; UNIX fd is a capability; intrinsic syscall rights as ambient authority.
- `cap-talk-1998--capability-ids-and-indirection-revocation` (Shapiro) — opaque fixed-size key IDs; destroyable indirection object as EROS revocation primitive.
- `cap-talk-1998--acl-vs-capability-challenge-problems` (Shapiro, Frascadore) — the challenge problems; the unsettled equivalence question.
- `cap-talk-1998--rescinded-keys` (Landau, Shapiro) — revocation must be indistinguishable from a live key; the fixed EROS thread table.
- `cap-talk-1998--caos-capability-os-terminology` (Dennis, Presern, Shapiro) — the definitional dispute that syscall-gating is not an object-capability model.

## Indexing (theme + unsettled + Endo, per the job's asks)

- **By theme** — sections filed under `capability-theory` (5 rows added) and
  `capability-security` (7 rows added); new topic `revocation` (destroyable
  indirection / caretakers / rescinded-key indistinguishability).
- **Unsettled/contentious** — new topic `cap-talk-open-questions.md` calling out
  the two founding open disputes explicitly: (1) are ACLs and capabilities
  equivalent (resolved externally by Capability Myths Demolished 2003), and
  (2) what counts as "a capability" (the never-converged definitional dispute).
- **Endo relevance** — new project topic
  `projects/endo/cap-talk-capability-provenance.md`: destroyable-indirection
  revocation as the caretaker/revocation-by-withdrawal ancestor; only-connectivity
  -begets-connectivity and objects-allocated-not-created as antecedents of Endo's
  reachability/storage model; designation-not-identity + the ocap-hygiene point.
- New concepts `capabilities-vs-acls`, `card-keys`; rows added to
  `revocation-by-withdrawal`; 7 keyword lines.

## Integrity gate (step 8)

- `library-link-check.sh --changed`: OK (every checked link resolves to a committed file).
- `regenerate-topics-counts.sh --check`: STALE (informational; reconciled at land).
- Sections index and topics counts regenerated and landed as the final step.

## Follow-on jobs (remainder)

- ACTIVE: `scholar-ingest-cap-talk-1999` (1998-April + 1999).
- PARKED (plan, deferred): `scholar-ingest-cap-talk-2000-2003`,
  `-2004-2008`, `-2009-2012`, `-2013-2016`. The full per-era partition and
  acquisition recipe are recorded in `sources/cap-talk-1998.md`.

## Blocker surfaced (not silently skipped)

Google Groups (post-2016 cap-talk) is not fetchable from the sandbox. The
pre-2016 Pipermail archive covers the list's whole first 18 years; the maintainer
may know an alternate export/mbox for the Google-Groups-era messages.

Self-improvement: introduced `source_kind: mailing-list-archive` as a labelled
web variant (Internet-Archive-anchored, per-thread attribution) for a
many-author list; if the fleet ingests more mailing lists, this shape is worth
promoting into `conventions.md` § source kinds by the scholar-conventions owner.
