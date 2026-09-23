---
title: §The-Depends-On section as §four-named-existing-implementations
source-slug: endo-but-for-bots--llm-designs-endoclaw-skill-registry
section-id: no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-skill-registry.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-skill-registry.md
total-lines: 252
status: Not Started
ingest-cycle: 222
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-skill-registry--no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
---

```
- EndoDirectory (packages/daemon/src/directory.js) — already implemented
- Guest plugin infrastructure (endo install) — already implemented
- String value storage (endo store) — already implemented
- Capability categories being defined enough for meaningful `requires` entries
```

§Three-already-implemented + §one-not-yet-precondition. §Borrowable-pattern: §the-Depends-On-section-with-status-per-dependency. §The-three-already-implemented-bullets-are-load-bearing-because-they-prove-the-no-new-abstractions-claim; §the-one-precondition-bullet-is-the-only-remaining-gating-question.

§Different-from cycle 220's §implementation-status-per-affected-package — cycle 220 tracks the implementation status of *this design's* packages; cycle 222 tracks the implementation status of the *dependencies* this design needs.
