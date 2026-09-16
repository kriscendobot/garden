---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-09-16T18:50:29Z
---
# Result: scholar-ingest-cap-talk-2009-2012-remainder

Remainder cycle over the cap-talk 2009-2012 source index
(`library/sources/cap-talk-2009-2012.md`). Sectioned the rest of 2009's
fetchable standout threads, anchored the missing bundles that were reachable,
authored a core concept page, and posted a follow-on for 2010-2012.

## Sources ingested / sectioned
- **cap-talk 2009-April** (`c48f9016`, already anchored): 1 section —
  `hiding-webkeys-from-the-address-bar` (Karp: authority-bearing webkeys must be
  hidden from users/address bar; SCoopFS inbox-leak; mashup tension).
- **cap-talk 2009-June** (`5b9ecc12`, already anchored): 2 sections —
  `defining-ambient-authority` (the Wikipedia/wiki.erights definitional thread),
  `origin-header-amplifies-ambient-authority` (Miller's CORS/Origin ambient-
  authority critique).
- **cap-talk 2009-July** (`0fb93565`, already anchored): 1 section —
  `defensive-correctness-versus-consistency` ("controversial article" thread).
- **cap-talk 2009-December** (`e30d2d0b`, NEWLY anchored this cycle): 1 section —
  `reducing-ambient-user-authority-install-manifest`.
- **cap-talk 2009-May** (`ab5d6ffa`): light month (8 msgs) — survey row only, no
  section (correct; content did not warrant a standalone section).

5 new section files total; source `section_count` 9 -> 14.

## Concept authored
- `concepts/ambient-authority.md` (new; genuine gap the June/December threads made
  load-bearing). Added to `concepts/README.md` and `keywords.md`.

## Monthly bundle anchors added
- 2009-December `e30d2d0b6139e606a9e5c68e17831ac062950deeea9ea226218d37f83c77a40f`
- 2010-October `6400467f7ecfd40ac0a49d55996a57b16129742f8d3aa84a157c420bea3c5e0f`
- 2011-April `f28a7548e567b27ebc011f3f9ada2db5c782e5f6867a33eb70614f9e5aa258a1`
- 2011-May `ee0c54e925a044f536a160f117cb132615fa750659bedd5a7b022c460d0d2642`
- 2011-June `8cbb4cb659ac9deb86d73395a2ef63dc0462094c805a3a7d6730c8ae515e8072`
- 2011-July `807b66a51b579006d17b26a159c5b86b450ccd776e8e137b04353e6e75333da6`
(2010-2012 anchors recorded in a new "Monthly bundle anchors (2010-2012)" table;
they are anchored, not yet sectioned.)

## Topic / concept pages touched
- `topics/capability-security.md` (+5 Sections rows), `topics/capability-theory.md`
  (+2 rows) via `insert-sections-table-row.sh`.
- `topics/cap-talk-open-questions.md`: appended open questions **43** ("is
  defensive correctness up to resource exhaustion usefully stricter than
  cooperative progress?") and **44** ("can ambient user authority be eliminated,
  or only reduced and rationed?"). (Numbers moved from an intended 37/38 to 43/44
  after a concurrent 2013-2016 peer scholar filled 37-42 mid-cycle.)
- Concept back-rows added to `web-key`, `confused-deputy`,
  `robust-composition-thesis`, `principle-of-least-authority`, `powerbox`.
- `projects/endo/cap-talk-capability-provenance.md`: new section "Ambient
  authority is the hazard; defensive consistency is what Endo guarantees" +
  trailer update.

## Follow-on posted
- `scholar-ingest-cap-talk-2010-2012` — sections 2009-Aug through Nov (anchored
  but content-fetch-failed this cycle), all of 2010-2012, and anchors 2012-October
  (which failed across 4 fetch attempts) and the many unlisted 2010-2012 months.

## Deferred backlog
- 2009-August/September/October/November: anchored, content fetch failed
  (transient Internet-Archive) — sectioning owned by the follow-on.
- All of 2010-2012 sectioning; most 2010-2012 anchors; 2012-October anchor.
- Post-2016 Google Groups era: still not fetchable from the sandbox.

## Integrity gate (step 8)
- `library-link-check.sh --source-slug cap-talk-2009-2012`: OK — every checked
  link resolves to a committed file.
- `regenerate-topics-counts.sh --check`: counts current (idempotent).

## Index regeneration (step 9)
- `regenerate-sections-index.sh`: landed (5 new sections projected into
  `sections/README.md`).
- `regenerate-topics-counts.sh`: landed (`topics/README.md` counts reconciled).

## Note on concurrency
Five files (web-key, cap-talk-open-questions, capability-security,
capability-theory, endo provenance) hit `land-journal-edit.sh` base-blob
concurrent-edit refusals because a peer 2013-2016 scholar advanced the tip
mid-cycle; re-synced the staging clone, re-applied the additive edits on the new
tip (re-numbering the open questions), and re-landed cleanly.
