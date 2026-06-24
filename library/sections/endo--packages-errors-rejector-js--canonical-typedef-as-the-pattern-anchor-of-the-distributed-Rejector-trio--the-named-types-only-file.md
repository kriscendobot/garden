---
title: §the-named-types-only-file
source: endo--packages-errors-rejector-js
url: https://github.com/endojs/endo/blob/master/packages/errors/rejector.js
authors: [Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/errors/rejector.js
total-lines: 23
ingest-cycle: 340
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-canonical-typedef-as-the-pattern-anchor
  - the-named-canonical-source-of-a-distributed-pattern
  - the-named-types-only-file
  - the-named-Rejector-as-typedef
  - the-named-Rejector-IS-false-OR-Fail
  - the-named-cond-OR-reject-AND-reject-template-literal
  - the-named-three-step-evaluation-shown-in-JSDoc
  - the-named-binary-choice-silent-vs-throwing
  - the-named-references-test-as-illustration
  - the-named-test-file-as-canonical-examples
  - the-named-import-for-typedef-only-with-named-lint-disable
  - the-named-twenty-three-line-types-only-file
  - the-named-streak-resumes-with-tenth-instance
  - the-named-pattern-citation-network-anchored-at-canonical-source
  - the-named-fifteenth-package-source-in-the-pivot
  - thirty-one-cycles-with-named-pivot-domain-stay
  - seventy-five-citation-arc-closures-in-pivot-now
parent: endo--packages-errors-rejector-js--canonical-typedef-as-the-pattern-anchor-of-the-distributed-Rejector-trio
---

The file has:

| Line range | Content |
|---|---|
| 1-2 | `// eslint-disable-next-line no-unused-vars`<br>`import { Fail } from './index.js';` |
| 3-23 | JSDoc block defining the `Rejector` typedef |

**Runtime behavior**: importing `./rejector.js` runs the import, which is a no-op (the imported `Fail` is referenced only in the JSDoc). **No exports**. **No side effects**.

**§the-named-types-only-file** — first-explicit-observation as a tier-3 meta-pattern. A file whose entire purpose is to provide a *type definition* via JSDoc. The file is grep-able and importable for typechecker integration, but doesn't contribute to runtime behavior.

**§the-named-twenty-three-line-types-only-file** — first-explicit-observation. The discipline: when a type definition needs a stable URL anchor (so consumers can `import('./rejector.js').Rejector`), put it in its own file.

**§the-named-import-for-typedef-only-with-named-lint-disable** — first-explicit-observation. Line 1: `// eslint-disable-next-line no-unused-vars`. The import of `Fail` is *unused at runtime* but *referenced in the typedef* (`@typedef {false | typeof Fail} Rejector`). The lint-disable comment explicitly acknowledges this — sibling to cycle 338's `@endo/no-polymorphic-call` disable-comment for the uncurryThis canonical idiom. **§three-cycles-with-named-named-lint-disable-with-canonical-rationale** (211 + 338 + 340).
