---
title: "ADR 0048: Retained-project admission gap"
source: docs/decisions/0048-retained-project-standard-lifecycle.md
source_repo: jordanhubbard/literate-ai
source_commit: 8fbe58f9b78fcba279cba09385121545e9ba9b7d
source_date: 2026-10-02
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: The small retained-source adapter cannot honestly represent a complete adopted project, while simply raising limits or advancing conversion would misstate who owns source authority.

An adopted project can retain its implementation as source authority while adopting
new build and packaging providers. Today `rebuild` rejects any conversion stage
other than `qualified` before even a retained-source review plan is prepared.
The existing retained-source adapter captures a small UTF-8-only tree and qualifies
it through generated-source custody. It cannot represent a complete retained project
with binary assets, large inputs, locked SDKs, native producers, documentation and
an existing test inventory. Raising its limits or marking conversion qualified would
misrepresent the authority being exercised.

This proposal serves framework Goals 1, 4 and 6. It changes lifecycle admission,
not the authority of retained implementation or the existing conversion criteria.
The ZIP provider in issue #17 remains an independent packaging capability.

Source: [docs/decisions/0048-retained-project-standard-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/8fbe58f9b78fcba279cba09385121545e9ba9b7d/docs/decisions/0048-retained-project-standard-lifecycle.md) at commit `8fbe58f9`.
