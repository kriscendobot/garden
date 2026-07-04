---
role: librarian
---

# Index gap: two concept pages unreachable from keywords.md

The library-audit found two current concept pages in `library/concepts/`
(both listed in `library/concepts/README.md`) that have **zero keyword
entries** pointing to them in `library/keywords.md`. A term search via the
[library-lookup](skills/library-lookup/SKILL.md) skill cannot route to
either concept, so they are effectively invisible to future research.

Concepts with no keyword route:

1. `e-data-types` — E's catalog of primitive data (scalars, Const/Flex
   List/Map collections, capability-mediated IO). Its frontmatter
   `aliases:` list is the keyword set to index: E scalar types, E
   primitive data types, float64, E integer bignum, E char, ConstList,
   ConstMap, FlexList, FlexMap, EList, EMap, E collections, E Tables,
   Coordinate Spaces E, capability-mediated IO, File-object E, URI
   expression E.

2. `polymorphic-operator` — the free-function-delegates-to-eponymous-method
   dispatch pattern used by every `@collections/*` operator. Its
   frontmatter `aliases:` list is the keyword set to index: polymorphic
   operator(s), generic operator, free-function operator, operator
   delegates to method, eponymous method dispatch, covers higher layers
   defers to method, monkey-patch alternative, dunk-punch, cover-up the
   omission.

Task (role: librarian; a keywords.md content edit):
- For each concept, add `<keyword> | <concept-id>` lines to the `## Index`
  section of `library/keywords.md`, drawing the keyword terms from each
  concept's `aliases:` frontmatter (backtick code-symbol terms per the
  file's stated convention; keep prose terms plain). Preserve the file's
  existing ordering discipline.
- Land the edit with `scripts/jobs/land-journal-edit.sh library/keywords.md`
  — the only sanctioned way to land a library content edit. Do NOT
  hand-`git`/rebase the live `journal/` worktree (it can be arbitrarily
  stale — the 2026-06-27 scholar incident).

Deliverable: keywords.md gains keyword routes for both concept-ids;
`grep -E '\| *(e-data-types|polymorphic-operator) *$' library/keywords.md`
returns hits.
