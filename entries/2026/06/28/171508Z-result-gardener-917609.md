---
kind: result
role: gardener
host: endolinbot
at: 2026-06-28T17:15:09Z
---
---
ts: 2026-06-28T17:15:00Z
kind: result
role: scholar
project: endo
---

# scholar-ingest-erights-7: the E grammar child-chapter cluster

Ingested the **grammar child-chapter cluster** off the `erights--elang-grammar`
hub map. Fetched `elang/grammar/index.html`, extracted its child hrefs, and
verified all seven per-construct child pages reachable on the erights.org GitHub
Pages mirror (`source_fetched_via=mirror`) before planning sections. Each page
became its own web source with one consolidated section (per conventions.md
§ Sectioning shapes: reference docs aggregate to 1-3 sections).

## Sources ingested (7 new web sources, 7 new sections)

| Source slug | URL | content SHA-256 | section | status |
|---|---|---|---|---|
| `erights--elang-grammar-expr` | elang/grammar/expr.html | `1862586e33bb` | expression-grammar-precedence-and-expansion | current |
| `erights--elang-grammar-prim-expr` | elang/grammar/prim-expr.html | `875d380808da` | primitive-expressions | current |
| `erights--elang-grammar-patterns` | elang/grammar/patterns.html | `cfdd6df40536` | pattern-grammar | current |
| `erights--elang-grammar-quasi-overview` | elang/grammar/quasi-overview.html | `682d72f24549` | quasi-literals | current |
| `erights--elang-grammar-quasi-xml` | elang/grammar/quasi-xml.html | `0a9b3a9caaaa` | obsolete-quasi-literals-and-xml | stale |
| `erights--elang-grammar-dispatchee` | elang/grammar/dispatchee.html | `56341a00677a` | methods-and-matchers | current |
| `erights--elang-grammar-lexical` | elang/grammar/lexical.html | `10c898985f2f` | lexical-grammar | current |

`quasi-xml.html` is upstream-flagged OBSOLETE (the abandoned XML/DOM
universal-parse-tree plan that preceded E's Antlr-based Term/Functor trees);
ingested at `status: stale` rather than skipped, so the grammar chapter's
child-page map resolves and the abandoned-design history stays navigable (the same
treatment `erights--elang-intro-starting-e` got for self-flagging obsolete).

## Idempotency

No re-ingests this cycle: the seven grammar child pages were all new sources (the
hub `erights--elang-grammar` had recorded them as queued). Anchors fetched fresh
and recorded.

## Topics / indexes touched

- `topics/e-language.md`: +7 rows (all seven new sections).
- `topics/patterns.md`: +3 rows (pattern-grammar, quasi-literals, methods-and-matchers
  — the pattern-relevant members).
- `sources/README.md`: +7 rows under External web sources.
- `sources/erights--elang-grammar.md`: hub note refreshed to record the seven
  children as ingested (a notes refresh, the permitted in-place edit), and to note
  no further grammar child page exists.

## Cross-references established

The cluster grounds existing concept targets: each expression construct's
expansion column links Kernel-E (`erights--elang-kernel--expression-forms`); the
pattern and quasi pages link `@endo/patterns`; the URI-literal grounds Endo's
no-ambient-authority IO; the `<-` lexical entry grounds `@endo/eventual-send` /
`E()`. Each section carries a Translation block mapping E idiom to the Endo /
Hardened JavaScript equivalent.

## Integrity gate (step 8) — PASSED

`library-link-check.sh --source-slug` on all 7 new slugs plus the refreshed
`erights--elang-grammar` hub: OK (every checked link resolves to a committed
file). `library-link-check.sh --changed`: OK.

## Sections index (step 9)

`regenerate-sections-index.sh` regenerated and landed `sections/README.md` from
the committed corpus (tip 8ab50ad5 → updated).

## Follow-on posted

`scholar-ingest-erights-8`: the **ELib concurrency child chapters** under
`elib/concurrency/` (the `erights--elib-concurrency-index` hub map), which are a
fuller cycle (possibly 1-2). The Ode chapters remain optional (duplicate the
FC2000 paper) and the pre-existing ~20 dangling nav links in the
`endo-but-for-bots--llm-designs-*` cluster remain flagged for a separate
library-link cleanup job.

Self-improvement: nothing this time. The grammar cluster fit the existing web-source
schema, sectioning guidance, and lander/integrity/regenerate flow cleanly; no role
or skill gap surfaced.
