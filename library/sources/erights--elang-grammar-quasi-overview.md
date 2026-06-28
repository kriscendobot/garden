---
source_kind: web
source_url: http://erights.org/elang/grammar/quasi-overview.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/quasi-overview.html
source_fetched_via: mirror
source_content_sha256: 682d72f245492974757cc2bcc5ff510ce983d2fcb101d7d65eed4c26524c6dc7
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  The Quasi-Literals child page of the grammar chapter, ingested by
  scholar-ingest-erights-7. E's pluggable quasi-parser framework — the unifying
  mechanism behind quasi-literal expressions and patterns, with the `simple` (text)
  and `e` (parse-tree) parsers. Direct ancestor of JavaScript tagged template
  literals and `@endo/patterns` quasi-parsers.
---

The **Quasi-Literals** page of E's grammar chapter: the pluggable quasi-parser
framework that unifies the quasi-literal expression and pattern forms. A
quasi-literal is a parser name plus a backquoted string with `$`-substitution and
`@`-extraction holes; expansion routes through the named parser's
`valueMaker(...).substitute(...)` (expressions) or
`matchMaker(...).matchBind(...)` (patterns). The `simple` parser does text
interpolation/matching; the `e` parser produces and matches Kernel-E parse trees.
This match-bind-substitute framework is the ancestor of JavaScript tagged template
literals.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [quasi-literals](../sections/erights--elang-grammar-quasi-overview--quasi-literals.md) | e-language, patterns | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/grammar/quasi-overview.html`.
- Content SHA-256 `682d72f245492974757cc2bcc5ff510ce983d2fcb101d7d65eed4c26524c6dc7`, 32808 bytes, last modified 1998-10-03.
