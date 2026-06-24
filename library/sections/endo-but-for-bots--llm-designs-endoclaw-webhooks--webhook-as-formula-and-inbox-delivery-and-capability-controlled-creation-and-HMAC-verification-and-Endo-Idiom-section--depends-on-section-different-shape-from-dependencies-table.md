---
title: §Depends-On section (different shape from Dependencies table)
source-slug: endo-but-for-bots--llm-designs-endoclaw-webhooks
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-webhooks.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-webhooks.md
total-lines: 79
ingest-cycle: 246
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section
---

```
## Depends On

- [gateway-bearer-token-auth](gateway-bearer-token-auth.md) — gateway must accept remote connections for webhooks to be useful
- [daemon-docker-selfhost](daemon-docker-selfhost.md) — self-hosted daemon is the primary deployment for webhooks
```

§The-Depends-On-section-is-a-bullet-list-with-inline-rationale + §not-a-table-with-Relationship-column. §Two-different-shapes-of-dependency-record in library: §Dependencies-table-with-Relationship-column (seven cycles: 224 + 230 + 236 + 238 + 240 + 242 + 244) + §Depends-On-bullet-list-with-inline-rationale (this cycle's shape).

§First-explicit-observation in library of §Depends-On-bullet-list-as-distinct-from-Dependencies-table. §When-a-design-has-only-two-or-three-dependencies-with-short-rationales, §a-bullet-list-with-em-dash-rationale-is-sufficient + §the-table-shape-is-overkill. §The-form-IS-the-information-density-fit.

§Sibling-to-cycle-244's-three-row-Dependencies-table (where the design had explicit Relationship column); §cycle-246's-two-bullet-Depends-On-section is the lighter weight. §Two-different-shapes-of-dependency-record-fit-different-design-sizes.
