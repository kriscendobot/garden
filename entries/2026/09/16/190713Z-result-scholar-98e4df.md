---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-09-16T19:07:19Z
---
---
project: endo
refs:
  - jobs/doin/scholar-ingest-cap-talk-2010-2012.md
---

Completed the four-source 2009-August through 2009-November cap-talk remainder within one scholar cycle.

- Re-fetched all four monthly bundles through the Internet Archive redirect `2id_` path. Their SHA-256 values matched the existing anchors: August `cf93f528...`, September `bde2949e...`, October `68456a3c...`, and November `ba8f8f33...`.
- Added 8 derived, multi-author sections: managed-language object references as capabilities; authentication versus property validation; full abstraction at the bytecode boundary; CORS and ambient cookies; well-known guards versus ambient authority; RabbitMQ's deployment-driven ACL choice; origin-bound geolocation authority; and the Native Client descriptor boundary.
- Updated the monthly survey and Sections tables in `library/sources/cap-talk-2009-2012.md` (22 sections total), the source README, 7 topic pages, 5 concept pages, and open questions 45-49.
- Extended `projects/endo/cap-talk-capability-provenance.md` with the managed-reference, guard, compilation, browser-grant, broker-adoption, and sandbox-layer consequences for Endo.
- Posted successor job `scholar-ingest-cap-talk-2010-2012-remainder` for all of 2010-2012, oldest-first, including the still-unanchored 2012-October bundle.
- Integrity gate: `library-link-check.sh --source-slug cap-talk-2009-2012` passed with every checked link resolving to a committed file; `regenerate-topics-counts.sh --check` reported counts current after regeneration. `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both landed their updated projections.

Self-improvement: nothing this time.
