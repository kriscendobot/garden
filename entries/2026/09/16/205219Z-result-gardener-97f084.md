---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-16T20:52:21Z
---
# Result: scholar-ingest-cap-talk-2011-2012-remainder

Continued the cap-talk 2011-2012 ingest after the January-March 2011 cycle. Source cluster: `library/sources/cap-talk-2009-2012.md`.

## Sectioned (10 new sections, 2011 April-July, oldest-first)

- 2011-April (163 msgs): `capabilities-for-immutable-data-sealed-values` (the 71-message Barbour/Magi debate on whether a sealed value is a capability); `type-passing-and-rights-amplification`; `examples-of-capabilities-for-outsiders`; `yurls-hash-length-and-self-authenticating-names`; `gc-versus-raii-resource-lifetime` (spans into May).
- 2011-May (19 msgs): `defensive-correctness-provability`.
- 2011-June (85 msgs): `comparing-models-zbac-versus-capabilities`; `avoiding-excess-authority-in-chained-access`; `re-authentication-and-time-limited-capabilities`.
- 2011-July (9 msgs): `sitelier-capability-os-for-the-web`.

## Fetched, SHA-256 anchored, surveyed (not yet sectioned)

- 2011-August `4ca3b6e3`; September `62af2753`; October `8c308efd`; November `1b343432` (111 msgs, dense); December `b67c8937`.
- 2012-January `52782d21` (149 msgs, dense OAuth thread); February `fd720c29`; March `6deacabd`.
- April-July 2011 re-fetched this cycle; all four SHAs re-matched their recorded anchors (determinism confirmed).

## 2012-October retry (seventh attempt)

Failed again: availability API 429, CDX 503, `2id_` redirect 404. The redirect form has now 404ed on the last two attempts specifically. Recorded in the index that a later cycle should confirm a CDX capture exists before an eighth attempt, else treat as unavailable via IA.

## Topic/concept/open-question/project updates

- Source index `cap-talk-2009-2012.md`: April-July rows now carry surveys + section links; new Aug-Dec 2011 and Jan-Mar 2012 anchor tables; abstract, notes, `source_months`, `section_count` (44 to 54), and the 2012-October failure note updated.
- Open questions: added the missing **#56** (Zooko-triangle presentation residue, referenced but never landed by the Jan-March cycle) plus new **#57** (is sealed/immutable data a capability), **#58** (provability of defensive correctness; OZE vs TGC05 definitions), **#59** (whose authority in chained access).
- Topic `## Sections` rows added for all 10 sections across capability-theory, capability-security, programming-language-design, content-addressed-storage, identity, distributed-objects (via `insert-sections-table-row.sh`).
- Concept `## Sections that touch this concept` rows added to object-capability, opaque-box, record-value, capabilities-vs-acls, policy-vs-capability-authorization, confused-deputy, capability-chain, powerbox, revocation-by-withdrawal, web-keys, content-address-versus-signature, sturdyref.
- Project `projects/endo/cap-talk-capability-provenance.md`: new "The 2011 arc" section + updated trailing scholar-jobs paragraph (the Jan-March cycle had left the project file un-updated for all of 2011).

## Integrity gate + landing

- `library-link-check.sh --changed`: OK (every changed link resolves to a committed file).
- `regenerate-topics-counts.sh --check`: STALE as expected pre-land; reconciled and landed in step 9.
- All 31 content files landed via `land-journal-edit.sh`; `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` regenerated and landed `sections/README.md` and `topics/README.md`.

## Remainder (a further `scholar-ingest-cap-talk-2011-2012-remainder` cycle owns it)

Section August-December 2011 (all anchored; dense November legacy-web/OpenID/Horton month is the standout) and all of 2012 (Jan-Mar anchored; the dense 2012-January OAuth thread is the obvious next standout; April onward unanchored). Retry 2012-October only after confirming a CDX capture exists.
