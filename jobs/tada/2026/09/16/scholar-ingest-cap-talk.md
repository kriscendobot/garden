Verified on `origin/journal2`: source-index, Endo cross-link, and all 8 sections landed.

## Completion report: scholar-ingest-cap-talk

**Survey.** cap-talk (object-capability discussion, founded 1998 by Jonathan Shapiro of EROS). Its current home (groups.google.com/g/cap-talk) is a JavaScript SPA whose message bodies load via an authenticated XHR and are **not fetchable from the sandbox** (plain curl gets only the shell + thread titles; the legacy `_escaped_fragment_` crawl path now just redirects). The list's full historical archive survives as a Mailman/Pipermail archive at `eros-os.org/pipermail/cap-talk/` spanning **1998-March through 2016-January (188 monthly archives)**, host offline but captured by the Internet Archive and fetchable via the `id_` recipe (fetch-source.sh auto-fallback). That is the usable source; each month has threaded HTML + per-message HTML + a `.txt.gz` bundle (content hash = idempotency anchor).

**First slice ingested (1998-March founding month).** New source `library/sources/cap-talk-1998.md` (`source_kind: mailing-list-archive`, anchor sha256 `a88db289`) with 8 thread-based sections and honest per-thread attribution, capturing Shapiro's real-time capability-vs-ACL arguments (card keys are capabilities; ACL-on-cap not cap-on-ACL; confinement provably unsolvable with ACLs; revocation by destroyable indirection) — the primary-source origin of the arguments the library's Miller "Capability Myths Demolished" pages later formalize.

**Indexing, per the job's three explicit asks.**
- *By theme:* 5 rows into `capability-theory`, 7 into `capability-security`, plus a new `revocation` topic; new concepts `capabilities-vs-acls` and `card-keys`; rows into `revocation-by-withdrawal`; 7 keyword lines.
- *Unsettled/contentious:* a dedicated new topic `cap-talk-open-questions.md` naming the ACL/capability equivalence question and the "what counts as a capability" definitional dispute explicitly.
- *Endo relevance:* new project topic `projects/endo/cap-talk-capability-provenance.md` cross-linking the caretaker/revocation and connectivity-axiom lineage, indexed from the endo README.

**Gates.** `library-link-check --changed`: OK. Sections index and topics counts regenerated and landed. All 21 files landed to `origin/journal2` (verified).

**Handoff of remainder.** Active: `scholar-ingest-cap-talk-1999`. Parked (plan/deferred): `-2000-2003`, `-2004-2008`, `-2009-2012`, `-2013-2016`. Full per-era partition + acquisition recipe recorded in the source-index.

**Blocker surfaced (not skipped):** post-2016 Google-Groups messages are unfetchable; the maintainer may know an alternate export/mbox. Result entry: `entries/2026/09/16/135136Z-result-scholar-31e8e8.md`; maintainer digest sent.

Self-improvement: introduced `source_kind: mailing-list-archive` as a labelled web variant for a many-author list; if the fleet ingests more mailing lists this shape is worth promoting into `conventions.md` § source kinds by the conventions owner (routed as a note in the result, not landed by me).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-cap-talk.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (10480406 cached reads)
- Output: 72065 tokens
- Cost: $9.162414000000004
- Wall-clock: 1346s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
