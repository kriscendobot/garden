The deadline nudge arrived, but the deliverable is already fully complete and landed — no handoff needed. Everything is done: all 33 content files landed to journal2 (verified pending=0), both projected indexes regenerated, the result entry and maintainer digest posted.

## Completion report

**Job `scholar-ingest-cap-talk-2012-april-onward` — complete.** This closes the Pipermail cap-talk archive; only 2012-October remains (IA-unavailable).

**Fetched & SHA-256 anchored (8 bundles, `2id_` original-bytes form):** 2012-April `c936ab90`, May `f8e54393`, June `ff2869ea`, July `a6ac36da`, August `877a93fb`, September `da2582a4`, November `0fe3a079`, December `8e4ad5a7` (196 msgs, very dense). Added a new "Monthly bundle anchors (2012, April onward)" sub-table to `library/sources/cap-talk-2009-2012.md`; `section_count` 65 → 74.

**9 sections written** (extending the "Sections (2012)" table): the April data-vs-immutable-instance boundary, May KeyKOS space-bank space recovery, June attenuated-delegation taxonomy, September **NaCl-per-message-crypto for Ken channels** (VatID = the public key — the OCapN-over-Noise antecedent, and the highlight), November password-as-designation, and December's four (enforcement-locus/virus debate, ocaps-vs-crypto-caps, SQL storage of a capability app, POLA-stack adoption). July/August and the November "scary video" aside are survey-only.

**Cross-references:** 25 topic-page Sections rows across 14 topics; 7 concept-page rows (object-capability, caretaker-pattern, per-agent-keypair, web-key, capabilities-vs-acls, principle-of-least-authority, security-as-extreme-modularity); open questions **64-67** added (plus May section cross-linked under existing OQ 60). The job body's "number 64" was correct — a peer had landed 60-63. Updated `projects/endo/cap-talk-capability-provenance.md` with a "The 2012 close" section and the trailing provenance paragraph, and refreshed the `sources/README.md` row.

**2012-October:** eighth fetch deliberately **not** attempted. Per the ask it requires CDX confirmation of a capture when IA is stable, but the Internet Archive was **globally offline** today ("temporarily offline"), so October is treated as unavailable via IA and documented in the source-page note for a later cycle.

**Gates & landing:** `library-link-check.sh --changed` passed (EXIT=0); topics-counts check was stale-only (no missing page); all 33 content files landed to journal2 (verified `pending=0`); `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both regenerated and landed. Result entry `220040Z-result-gardener-fa8b2f.md` and maintainer digest posted.

**Follow-ons:** none — 2012 scope is complete (no budget truncation); the sole outstanding item (a 2012-October retry) is externally blocked on IA and recorded in-file, so a recurring remainder job would only re-fail. The post-2016 Google Groups era stays not fetchable from the sandbox.

Self-improvement: `fetch-source.sh`'s `2id_` redirect form fetched all eight bundles fine even while the CDX/availability APIs returned 503/429 and the IA site served a global "temporarily offline" page — the two paths fail independently, so a CDX-based capability check can be impossible precisely when byte-fetching still works. A `fetch-source.sh --cdx-probe <url>` mode that reports "IA globally offline" distinctly from "no capture found" would let a future October-style deferral decision be made deterministically instead of by hand-reading an HTML outage page.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-cap-talk-2012-april-onward.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 220 tokens (19400747 cached reads)
- Output: 95287 tokens
- Cost: $14.8778495
- Wall-clock: 2012s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
