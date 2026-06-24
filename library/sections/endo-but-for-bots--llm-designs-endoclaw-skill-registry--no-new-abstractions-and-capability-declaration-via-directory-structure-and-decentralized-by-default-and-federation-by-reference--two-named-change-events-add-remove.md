---
title: "§Two-named-change-events: §add + §remove"
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

`if ('add' in change) ... if ('remove' in change) ...`

§Discriminated-union-on-key-presence. §Borrowable-pattern: §discriminated-union-via-key-presence-not-discriminator-string — the consumer checks `'add' in change` not `change.kind === 'add'`. §This-is-rare-and-load-bearing: §if-the-format-grows-a-third-event-the-existing-handlers-skip-it-rather-than-falling-into-a-default-case.
