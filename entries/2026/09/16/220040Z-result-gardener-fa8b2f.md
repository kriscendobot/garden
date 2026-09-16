---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-16T22:00:42Z
---
result: scholar cap-talk 2012 April-onward ingest (job `scholar-ingest-cap-talk-2012-april-onward`)

Continued the cap-talk archive after 2012 January-March, completing all remaining fetchable 2012 months. This closes the Pipermail cap-talk archive (2013-2016 is a separate, already-ingested slice); only 2012-October remains unavailable via the Internet Archive.

**Bundles fetched and SHA-256 anchored (8, via the `2id_` original-bytes form; a new "Monthly bundle anchors (2012, April onward)" sub-table in `library/sources/cap-talk-2009-2012.md`):**
- 2012-April `c936ab90` (7 msgs), 2012-May `f8e54393` (11), 2012-June `ff2869ea` (3), 2012-July `a6ac36da` (2), 2012-August `877a93fb` (1), 2012-September `da2582a4` (2), 2012-November `0fe3a079` (13), 2012-December `8e4ad5a7` (196, very dense).

**Sections written (9; extending the "Sections (2012)" table), section_count 65 -> 74:**
- `immutable-instances-and-the-data-boundary` (04): Miller's data-vs-capability answer (Data = unforgeable + identity-free; in Joe-E only scalars).
- `space-recovery-in-mutually-suspicious-systems` (05): KeyKOS space banks vs mark-and-sweep; reclamation is accounting, not POLA-violating graph inspection.
- `implementing-attenuated-delegation` (06): Kevin Reid's taxonomy — generic attenuation is only caretaker/revoker + membrane; richer is API-coupled.
- `nacl-per-message-crypto-for-ken-channels` (09): Brian Warner — VatID = the public key, per-message box/unbox not per-connection TLS, store-and-forward; the OCapN-over-Noise antecedent.
- `password-as-designation-not-authentication` (11): Meijer's MinorFs PAM bug; HMAC-derived sparse-cap root; Karp's revocation question open.
- `capability-enforcement-language-os-or-hardware` (12): the Microsoft-Paper virus/enforcement-locus debate; Barbour's start-high/refuse-insecure-code/security-is-modularity.
- `bits-of-capabilities-ocaps-versus-crypto-caps` (12): Miller's unforgeable-vs-unguessable distinction; Boebert's *-property impossible for crypto-caps.
- `sql-storage-of-a-capability-application` (12): fine-grained caps do not fit a relational schema; secure the edges, not the nodes.
- `permissive-pola-stack-apparmor-minorfs-e` (12): why the AppArmor/MinorFs/E POLA stack went unadopted — no OS/language transition path.
- Survey-only months: July (ParaSail, Tahoe 1.9.2), August (SSV CFP), and the November "scary video" aside.

**Topic pages touched (25 Sections rows):** capability-theory, pass-style, capability-security, programming-language-design, persistence, patterns, revocation, captp, ocapn, networking, identity, authentication-gatekeepers, sandbox-platforms, e-language.

**Concept pages touched (7 Sections rows):** object-capability, caretaker-pattern, per-agent-keypair, web-key, capabilities-vs-acls, principle-of-least-authority, security-as-extreme-modularity.

**Open questions:** added 64-67 (fine-grained caps in a relational DB; language-up vs OS-down enforcement to defeat malware; password as revocable/attenuable designation; whether object-agnostic generic attenuation is possible) in `topics/cap-talk-open-questions.md`; also added the May space-recovery section as a supporting reference under the existing OQ 60. (The job body referenced "number 64"; a peer cycle had already landed 60-63, so 64 was indeed the next number.)

**Project file:** `projects/endo/cap-talk-capability-provenance.md` — added a "The 2012 close" section (self-authenticating transport / VatID-as-public-key, the ocaps/crypto-caps line, the enforcement locus, SQL storage, POLA-stack adoption) and updated the trailing scholar-jobs provenance paragraph.

**2012-October (unavailable via IA):** the eighth retry was NOT attempted. Per the job's ask, an eighth is warranted only after the CDX index (when IA is stable) confirms a `2012-October.txt.gz` capture. On 2026-09-16 the Internet Archive was **globally offline** ("Internet Archive services are temporarily offline"), so the CDX index could not be consulted — October is therefore treated as unavailable via IA and no fetch was attempted. Recorded in the source-page October note.

**Follow-on jobs:** none posted. The 2012 scope is complete (no cycle-budget truncation); the only outstanding item, a 2012-October retry, is externally blocked on IA availability and documented in the source file for a later cycle to revisit when IA is stable. The post-2016 Google Groups era stays not fetchable from the sandbox (`cap-talk-1998.md`).

**Integrity gate:** `library-link-check.sh --changed` passed (EXIT=0, every checked link resolves to a committed file). `regenerate-topics-counts.sh --check` reported stale counts only (28 count lines, no missing topic page) — reconciled by the landing step. `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both regenerated and landed the projected indexes (sections/README.md, topics/README.md Index counts).
