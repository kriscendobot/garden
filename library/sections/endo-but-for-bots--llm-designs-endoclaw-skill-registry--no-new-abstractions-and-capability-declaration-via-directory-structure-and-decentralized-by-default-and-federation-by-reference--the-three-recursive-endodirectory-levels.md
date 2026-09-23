---
title: §The-three-recursive-EndoDirectory-levels
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
skills/                            (EndoDirectory)
├── gmail-bridge                   → skill descriptor
├── telegram-bridge                → skill descriptor
└── ...

gmail-bridge/                      (EndoDirectory — skill descriptor)
├── code                           → guest module (installable bundle)
├── description                    → string value
├── requires                       → directory of capability declarations
│   ├── oauth                      → string value: "gmail"
│   └── network-fetch              → string value: "https://gmail.googleapis.com"
├── version                        → string value
├── author                         → string value
└── homepage                       → string value
```

§Three-recursive-levels: registry (a directory of descriptors) → descriptor (a directory of metadata) → requires (a directory of capability declarations). §Each-level-is-the-same-shape (EndoDirectory) but §with-a-different-meaning.

§Borrowable-pattern: §uniform-shape-with-recursive-nesting — the same primitive (directory + string-value) suffices at every level. §Recursive-nesting-with-uniform-semantics; §you-don't-need-to-learn-three-vocabularies-because-everything-uses-the-same-three-operations (list / lookup / write).

§Sibling to cycle 211 @endo/common's §tree-shaking-friendly (uniform shape with file-per-export); §different-substrates-same-discipline.
