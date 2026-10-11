---
title: "ADR 0011: Verifier boundaries and consequences"
source: docs/decisions/0011-component-domain-structure-literate-markdown-v2.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Independent verification remains the invariant: generated code never grades its own properties, prompt assembly may include locked bytes but not domain branches, and the bounded predicate language explicitly makes no completeness claim.

Invariant, property-acceptance, and error-taxonomy checks run only in the independent
verifier. Parsing remains fail-closed per provider version. The initial field and
acceptance kinds are policy, while completeness of the predicate language is deferred;
the bounded grammar grows through versioned contract additions.

The prose cap remains a pressure toward decomposition. Structured authoring adds some
cost for complex Components but makes schemas, errors, and budgets diffable and
reusable. Every new field widens lock identity inputs, so upgrading to v2 requires a
reviewed re-lock. Generation context may carry locked bytes verbatim but cannot branch
on domain vocabulary, converting prompt neutrality from a tripwire into validation.

Source: [docs/decisions/0011-component-domain-structure-literate-markdown-v2.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0011-component-domain-structure-literate-markdown-v2.md) at commit `fcc40bc6` (source lines 69-102).
