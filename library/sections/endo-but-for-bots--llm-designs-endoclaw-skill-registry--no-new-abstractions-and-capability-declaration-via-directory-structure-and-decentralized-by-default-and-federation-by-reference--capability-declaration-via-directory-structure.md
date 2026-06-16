---
title: §Capability-declaration-via-directory-structure
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
gmail-bridge/
└── requires                       → directory
    ├── oauth                      → string value: "gmail"
    └── network-fetch              → string value: "https://gmail.googleapis.com"
```

§Capabilities-are-pet-name-entries-with-string-scope-hints. §Inspectable-with-the-same-tools — `endo list skills gmail-bridge requires` works because `requires` is just another directory.

§Borrowable-pattern: §encode-structured-metadata-as-directory-structure + §don't-invent-a-new-metadata-format. §The-directory-IS-the-schema. §No-JSON-schema-needed; §no-YAML-parser-needed; §the-existing-tooling-already-knows-how-to-walk-it.

§Sibling to cycle 197 panic's §registered-symbol-as-emulated-private-state (different mechanism, same §use-the-existing-primitive-rather-than-invent-a-new-one discipline).
