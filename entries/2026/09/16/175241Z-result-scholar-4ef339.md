---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-09-16T17:52:43Z
---
Scholar cycle: ingested a representative first pass over the 2004-2008 cap-talk era as `library/sources/cap-talk-2004-2008.md`.

Source and acquisition:

- Recorded SHA-256 anchors and survey dispositions for 18 Pipermail `.txt.gz` bundles: 2004-January, February, April, May; 2005-January through May; 2006-January and February; 2007-January through April; and 2008-January through March.
- The canonical `eros-os.org` host remains offline. Bundles were fetched through Internet Archive `id_` original-byte captures. Per-thread files preserve multi-author attribution and identify themselves as derived summaries, not original messages.
- Added 22 section files covering capability representations, the 2004 confinement/POLA dispute and CapDesk, Polaris shatter-attack mitigation, Firefox identifiability and petnames, password-capability safety, Mungi/API-level confused deputies, mandatory classification, YURLs, reference/capability definition, membrane limits, identity, crypto brands, Waterken `ref_send`, web-keys, hybrid-system confused deputies, authority versus information flow, the historical object-capability pattern inventory, and persistent-session failure.

Indexing and connections:

- Updated topics `capability-security`, `capability-theory`, `identity`, `patterns`, `eventual-send`, and `revocation` with deterministic table insertion. Expanded `cap-talk-open-questions` with seven explicitly unsettled boundaries.
- Added concept `web-keys`; grew `capabilities-vs-acls`, `confused-deputy`, `powerbox`, `caretaker-pattern`, and `promise-pipelining`; updated `keywords.md` and the concepts/source indexes.
- Extended `projects/endo/cap-talk-capability-provenance.md` and its README abstract with CapDesk/Polaris, web-keys/petnames, eventual references, named ocap patterns, and persistence/partial-failure connections.
- Cross-linked the cap-talk threads to the existing *The Structure of Authority*, *Capability Myths Demolished*, *Concurrency Among Strangers*, Polaris 2004/2006, and Tyler Close *ACLs Don't* source sections.

Follow-up and backlog:

- Posted `scholar-ingest-cap-talk-2004-2008-remainder` to enumerate the unanchored late-year bundles and section genuinely new themes. The anchored 2005-April database/query-language discussion is also deferred there. This is a normal section-budget handoff; the current representative slice is complete.
- The known post-2016 Google Groups message-body gap remains unchanged and is documented in the archive map.

Verification:

- `library-link-check.sh --source-slug cap-talk-2004-2008`: OK; every checked link resolves to a committed file.
- `regenerate-topics-counts.sh --check`: current and idempotent.
- Regenerated and landed `library/sections/README.md` and `library/topics/README.md` after all content writes.

Self-improvement: nothing this time.
