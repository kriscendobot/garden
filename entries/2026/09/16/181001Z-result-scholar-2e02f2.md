---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-16T18:10:04Z
---
Scholar cycle: completed the 2004-2008 cap-talk era index in `library/sources/cap-talk-2004-2008.md`.

Source and acquisition:

- Compared the requested remainder against the captured Pipermail archive index. The index names 59 bundles across 2004-2008 and no `2004-March.txt.gz`; probing that missing path returned 404.
- Fetched and SHA-256 anchored all 41 reachable remainder bundles: 2004 June-December; 2005 June-December; 2006 March-December; 2007 May-December; and 2008 April-December. Together with the first pass, all 59 indexed bundles now have anchors and concise survey dispositions.
- Preserved per-thread multi-author attribution and the derived-summary provenance boundary.

Ingestion and indexing:

- Added 19 sections within the cycle budget: database-query closures; space-bank/capability accounting; objects/facets; Horton accountability; memory sponsorship; deep attenuation; trust versus POLA; user-intent authorization; non-delegatable authority; SAML versus live ocaps; Authodox formal analysis; persistent ocap languages; `argv` leakage; ACL/ocap coexistence; authority monotonicity; Chrome's brokered sandbox; dependency injection versus enforced ocaps; attenuated drag-and-drop; and capability URLs in practice.
- The deferred 2005-April database/query-language thread is now sectioned as `database-query-authority`.
- Updated topics `capability-security`, `capability-theory`, `patterns`, `identity`, `captp`, `compartments`, `exo`, `persistence`, and `tooling`. Grew `cap-talk-open-questions` from 25 to 33 questions with resource sponsorship, delegation evidence, trust/POLA, gesture authorization, non-delegation, persistence, ACL coexistence, and authority-monotonicity boundaries.
- Extended `projects/endo/cap-talk-capability-provenance.md` with facets/endowments, resource budgets, deep attenuation, trusted UI grants, transport/policy boundaries, concurrency assumptions, and browser brokers; updated the project index abstract.

Follow-up and backlog:

- No 2004-2008 monthly-bundle remainder remains. Unsectioned months have explicit dispositions, generally because their principal themes duplicate the first-pass CapDesk/Polaris, petname/web-key, confused-deputy, `ref_send`, pattern-history, and persistence sections or stable paper ingests.
- The archive-wide post-2016 Google Groups export gap remains unchanged.

Verification:

- `library-link-check.sh --source-slug cap-talk-2004-2008`: OK; every checked source and regenerated-section-index link resolves to a committed file.
- `regenerate-topics-counts.sh --check`: current and idempotent.
- Regenerated and landed `library/sections/README.md` and `library/topics/README.md` after all content writes.

Self-improvement: nothing this time.
