---
title: Framework premise assessment: the disposability premise and the authority ladder
source: docs/architecture/framework-premise-assessment.md
source_repo: jordanhubbard/literate-ai
source_commit: 08ff70273a5462cf4d205b730f445a296cb3f067
source_date: 2026-10-03
source_authors: [jkh]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The assessment finds the premise strongest in explicit generation authority, verifier-only acceptance, untrusted cache hits, and distinct signature meanings, but weak at 'disposable': exact prompt hashes prove what was requested, not that a drifting model can reproduce it, and LLM synthesis is not Knuth's deterministic tangle; it proposes a four-step authority ladder ending in regeneratively-qualified-fungible, with shipped source still retained as escrow.

The assessment finds the premise strongest in four places:

- specifications, Flavors, and pinned skills form explicit generation authority;
- generated tests do not grade themselves, because verifier-only acceptance stays independent;
- cache hits never inherit execution authority and must pass current acceptance; and
- signatures, provenance, build authorization, and behavioral safety have distinct meanings.

The weak point is the word **disposable**. A model alias can change, disappear, or produce another implementation. The documentation admits provider weights and defaults are not immutable while also claiming cache deletion cannot affect reconstruction ability; the assessment calls those positions incompatible, because exact prompt hashes prove what was requested, not that the generating capability remains available. Knuth's literate-programming transform was deterministic; LLM synthesis is underdetermined and probabilistic, so the analogy holds for human-centered explanation but not for reproducible tangling.

It proposes an explicit authority ladder:

1. source-authoritative;
2. spec-assisted;
3. derived-source-retained; and
4. regeneratively-qualified-fungible.

Even in the final state, shipped source should be retained as non-authoritative release evidence or escrow: "non-authoritative and throwaway are not the same property." (The later [component authority](literate-ai--docs-architecture-component-authority--append-only-authority-projection.md) document adopts this four-state ladder.)

Source: [docs/architecture/framework-premise-assessment.md](https://github.com/jordanhubbard/literate-ai/blob/08ff70273a5462cf4d205b730f445a296cb3f067/docs/architecture/framework-premise-assessment.md) at commit `08ff702`.
