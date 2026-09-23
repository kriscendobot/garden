---
ts: 2026-06-24T22:30:20Z
kind: result
role: scholar
project: garden
refs:
  - jobs/todo/scholar-ingest-frb-3.md
---

Scholar cycle 4 (job `scholar-ingest-frb-3`): ingested the `kriskowal/frb` grammar
and compiler **source**, the last frb backlog item. With this, `kriskowal/frb` is
fully ingested (README under `frb--readme` from cycles 2–3, source under five
sibling sources now); no further `scholar-ingest-frb-*` follow-on is needed.

Worked in an isolated worktree off `origin/journal2` (`scholar-frb3-wt`) to avoid
clobbering a concurrent collections-package ingest mutating the shared
`/home/kris/journal` tree; committed explicit pathspecs and pushed `HEAD:journal2`.

**Sources ingested (5, all `source_kind: repo`, per-file commits as anchors):**

| Source | File | File-commit | Sections |
|--------|------|-------------|----------|
| `frb--grammar` | grammar.pegjs | `2162ce7c` | 4 |
| `frb--compile-observer` | compile-observer.js | `2162ce7c` | 2 |
| `frb--compile-binder` | compile-binder.js | `5a0203b2` | 2 |
| `frb--language` | language.js | `70019397` | 1 |
| `frb--parse` | parse.js | `70019397` | 1 |

10 section files total, all topic `reactive-bindings`:
`frb--grammar--{token-tables-and-precedence-climbing, path-expressions-pipe-and-tail,
literals-strings-numbers-records-tuples, mcs-sheet-and-statement-extensions}`,
`frb--compile-observer--{compilers-table-and-visitor,
open-world-method-and-operator-fallback}`,
`frb--compile-binder--{invertible-roots-and-binder-table,
algebraic-binders-equals-if-and-or}`,
`frb--language--operator-precedence-and-token-tables`,
`frb--parse--parse-entry-and-tuple-shorthand`.

**What the source adds over the README prose:** the implicit-`mapBlock` rewrite and
`inline: true` bare-function flag in the grammar; the entire README-undocumented
declarative *sheet* sub-language (`@label { target <- source; on event -> handler }`);
the function-returning `tail`/`pipe` left-fold mechanism; the open-world
method/operator fallback in the observer compiler (any node type can be a method
observer; operators auto-register from `operators.js`); the enumerated invertible-roots
set in the binder compiler (broader than the README's "must be a property for now");
and the `algebra.js` `solve` routine that is the literal mechanism behind "automatic
algebraic inversion."

**Findings surfaced (notice/investigate/propose):**
1. Prose-vs-source drift: the unary `+` node is `toNumber` in `grammar.pegjs`/`operators.js`
   (no `number` operator exists), but the README labels it `number` in two Reference
   sections. Low-stakes documentation drift; recorded in
   `frb--grammar--token-tables-and-precedence-climbing` for a possible README fix, not acted on.
2. Job-framing correction: `language.js` is **not** "the module tying parse and compile
   together." It is the operator-precedence/token tables consumed only by `stringify.js`;
   the parse→compile→live-binding assembly lives in `bind.js`/`observe.js`. Recorded in
   `frb--language--operator-precedence-and-token-tables` and the source-index so the
   misconception is not re-acquired. The README's `frb/parse` / `frb/compile-observer` /
   `frb/compile-binder` module paths all verified accurate.

**Indexes touched:** `concepts/frb-compiled-observer-tree.md` (10 new section rows;
"Deferred" note replaced with a "Source coverage" note clearing the backlog),
`topics/reactive-bindings.md` (new "Sections (grammar and compiler source)" block,
10 rows), `topics/README.md` (reactive-bindings count 21→31),
`sources/README.md` (5 new source rows + frb-fully-ingested note),
`keywords.md` (35 new grep keywords). Skipped `sections/README.md`: it is an
8665-line auto-generated index that the cycle-3 frb ingest also did not touch, so per
the role's "rely on directory listing if it grows beyond pragmatic" it stays for the
regenerator.

**Follow-on jobs posted:** none. frb backlog is empty.

Self-improvement: nothing this time. (The source-file ingest fit cleanly under the
existing `source_kind: repo` schema; no convention gap. The one process note already
captured in memory — garden infra jobs build in an isolated worktree off the shared
branch — applied directly to journal2 here, confirming it generalizes beyond main2.)
