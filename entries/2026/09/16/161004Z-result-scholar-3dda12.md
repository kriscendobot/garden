---
kind: result
role: scholar
host: oros-studio-garden-ce242c49
at: 2026-09-16T16:10:18Z
---
kind: result
role: scholar
project: endo
---
Scholar cycle: ingested the reachable 2000-2001 slice of the cap-talk archive (job scholar-ingest-cap-talk-2000-2003). A faithful first pass of the 2000-2003 era, oldest-first; the 2002-2003 (Miller-paper) era is deferred to a posted follow-on.

Source ingested: `library/sources/cap-talk-2000-2001.md` (source_kind: mailing-list-archive), a year-span index over five independently-hashed monthly Pipermail bundles, each fetched via the Internet Archive `id_` original-bytes route with a concrete CDX capture timestamp (the availability API was rate-limiting; a CDX enumeration plus direct `id_` fetch was the reliable path). Bundle anchors: 2000-July `52cc13f4`, 2000-August `d7fb39c7`, 2000-November `77a32016`, 2001-July `7e0ec8b2`, 2001-August `76388b8a`. 2001-November (`ecd050e4`) fetched and surveyed but carries only list-subscription/off-topic mail, so it anchors no section.

Sections written (10):
- cap-talk-2000-2001--capability-representation-partitioned-tagged-and-password (partitioned/tagged/password taxonomy; System/38, Plessey 250, Mungi, Monash XOR; representation decides confineability)
- cap-talk-2000-2001--confinement-the-sw-model-e-immutability-and-keybits (Shapiro SW model vs E observable immutability; keybits used without revealing keys)
- cap-talk-2000-2001--the-tcb-is-not-singular (per-application TCB vs the universal-TCB intersection)
- cap-talk-2000-2001--keykos-eros-practical-model-for-a-newcomer (persistence, no root, creator-holds-first-key, copied-not-delegated, revocation by nullifiable indirection; spans 2000-July+August)
- cap-talk-2000-2001--a-capability-is-behavior-not-an-object-reference (Landau's behavioral definition and equality)
- cap-talk-2000-2001--process-allocation-branding-and-the-minimal-tcb (No-Domain-Creator debate; branding as rights amplification; resume-key = bug catching not security)
- cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol (Miller's distinction; SPKI approximately-a-capability-system; E cap:// + Pluribus; Waterken https; Stracke's DoS/mutual-trust counterpoints)
- cap-talk-2000-2001--two-threads-of-capability-thinking-os-vs-lambda-calculus (Miller's OS-vs-lambda history; Rees's W7; immutable data and E's Slot)
- cap-talk-2000-2001--reviewing-a-home-rolled-capability-design-goo (Hanson's Goo handles/tickets; Shapiro's "why not SPKI"; Hanson's cert-chain critique)
- cap-talk-2000-2001--authorization-certificates-are-all-around-us (Nicol's everyday bearer-token catalogue; designation not authentication)

Topics touched: capability-theory (+6 rows), capability-security (+10), revocation (+1), captp (+1), cap-talk-open-questions (extended notion #2, added notions #8 "is SPKI a capability system?" and #9 "resume-key: security or bug-catching?"). Concepts touched: card-keys (+1), object-capability (+2). sources/README.md row added.

Project growth: `projects/endo/cap-talk-capability-provenance.md` gained three subsections (off-line-representation-vs-on-line-protocol => CapTP/OCapN two-layer shape and the SPKI verdict; a-reference-is-its-behavior => Far/Remotable facet discipline; lambda-calculus lineage + confinement-by-immutability => SES harden).

Integrity gate (step 8): `library-link-check.sh --changed` = OK (every checked link resolves to a committed file); `regenerate-topics-counts.sh --check` = stale counts only (no missing topic page), reconciled in step 9. Sections index (`regenerate-sections-index.sh`) and topics counts (`regenerate-topics-counts.sh`) regenerated and landed as the final step.

Follow-on posted: `scholar-ingest-cap-talk-2002-2003` (the Miller-paper era), with acquisition notes (use the CDX enumeration; availability API is rate-limited; some captures duplicate the body) and a request to re-check 2000-2001 for any months beyond July/August/November that the partial CDX pass missed.

Self-improvement: the recorded lesson (routed separately) is that the Wayback availability API rate-limits hard during bulk archive ingest; the CDX-enumerate-then-direct-`id_`-fetch path is far more reliable, and some captures duplicate the bundle body. Worth encoding into fetch-source.sh / the conventions PDF-acquisition section for future mailing-list-archive cycles.
