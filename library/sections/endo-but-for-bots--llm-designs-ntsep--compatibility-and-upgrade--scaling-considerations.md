---
title: Scaling Considerations
source: designs/ocapn-network-transport-separation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, repository-governance]
status: current
notes: The "structural refactoring, no security properties change" claim is the load-bearing safety story. Pre-1.0 status (`@endo/ocapn` v0.2.2) authorizes the breaking change without semver ceremony. The Syrup wire-format change in OcapnLocation field name is the only inter-implementation coordination cost — must talk to the OCapN spec group.
parent: endo-but-for-bots--llm-designs-ntsep--compatibility-and-upgrade
---

- No scaling impact. The number of registered networks is small (typically 1-2).
- Session routing adds negligible overhead.

Source: [designs/ocapn-network-transport-separation.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-network-transport-separation.md) at commit `0ee0cbb3` on branch `llm`.
