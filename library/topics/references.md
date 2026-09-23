# Topic: references

> Abstract: The cross-reference axis. `references` is the routing target for the 146-and-growing `keywords.md` lines that name a *relationship* rather than a single concept: external prior-art and specification citations the library quotes (TC39 proposals, Wikipedia-named formal terms, third-party attributions, cited architectural rationale), and internal cross-cycle observations the scholar attaches while ingesting (design-evolution-record family members, multi-cycle pattern threads of the form "three cycles on X", endoclaw-cluster members). It is a meta tag, not a section catalog: a keyword that resolves here is a pointer to a citation or a span of the library's own ingest history, not to one page. This page exists so that a `library-lookup` walker who resolves such a keyword lands on an explanation instead of a dead end.

## Why this page is a tag, not a section table

Most topic pages cluster a set of section files under one subject and list them in a table. The `references` axis is different by design. Its keywords were added next to the sections whose ingestion surfaced them, as annotations of the form "this design is the Nth honest-design-evolution-record" or "this rationale cites prior art X". The annotation lives in `keywords.md` as `<phrase> | references`; the material the phrase describes lives in the section (or journal entry) that introduced it. The keyword line does not itself name that section, so following `references` cannot land on a single canonical page. Rather than leave the route broken, this page names the axis and tells you how to find the material.

## How to follow a `references` keyword to its material

1. Take the distinctive phrase from the keyword line (for example `four-JSDoc-tags (@preserve / @copyright / @license / @cc_on)`).
2. Grep that phrase, or its most distinctive fragment, across `sections/` and `entries/` from the library root:

   ```sh
   grep -rl 'four-JSDoc-tags' sections/ ../entries/
   ```

3. The matching section is where the annotation was minted; its frontmatter carries the upstream `source_path` and `source_commit`. The matching journal entry (a scholar `result`) records the cycle that ingested it.

For the cross-cycle threads ("three cycles on content-addressed-deduplication (cycles 200 + 222 + 230)"), the cycle numbers index scholar `result` entries under `entries/`; grep the cycle number or the thread phrase to recover the span.

## What lands here (composition as of 2026-06-27)

Of the 146 keyword lines routing to `references`:

- **About 87 are cross-cycle observations** ("Nth-cycle-with-ASCII-illustration", "three-cycles-on-X", "the-marshal-package-now-comprehensively-ingested across N cycles"). These thread one library pattern across several ingest cycles, mostly from the endo-but-for-bots LLM-designs corpus.
- **18 are design-evolution-record family members** ("Nth-honest-design-evolution-record family member"), tagging a design that documents its own revision history.
- **5 are endoclaw-cluster members**, tying a design into the endoclaw feature family.
- **The remainder are external prior-art and architectural-rationale citations**: TC39 proposals (Stage 4 base64, "Don't Remember Panicking"), Wikipedia-named formal terms (Shortlex ordering), cross-ecosystem references (CREATE2-vs-CREATE3, Permit2, OWASP Top 10 for Agentic Applications), and cited design rationale (ROM-vs-RAM Moddable XS, by-copy network protocol).

## See also

- [`patterns`](patterns.md) — the sibling cross-cutting axis for recurring *implementation* idioms (as opposed to citations and cross-cycle history).
- [`spec-to-implementation`](spec-to-implementation.md) — the other meta topic page, mapping OCapN spec sections to Endo realizations.
- [`keywords.md`](../keywords.md) — the index whose `| references` lines route here; grep `'| references'` there for the full current set.
