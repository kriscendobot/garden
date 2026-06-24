---
title: §Two-level harden — harden(result) plus harden(makeTagged)
source-slug: endo--packages-pass-style-src-makeTagged-js
section-slug: the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/makeTagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/makeTagged.js
source-author: Endo project (collective)
total-lines: 31
ingest-cycle: 270
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
---

Lines 23 and 31:
- Line 23: `return harden(create(objectPrototype, {...}))` — harden the constructed result.
- Line 31: `harden(makeTagged)` — harden the factory itself.

§Two-level-harden:
- §**Result-harden** — every value the factory returns IS hardened.
- §**Factory-harden** — the factory function itself IS hardened (not just its closure-captured constants).

§First-explicit-observation in library: **§two-level-harden-discipline (result-harden + factory-harden) — §sibling-pattern to cycle 260's three-disciplines-in-one-export-line (const + harden + PascalCase-Helper-suffix) but for factory functions instead of helper-object exports**.

§The-factory-harden-IS-separate-from-the-export-statement — §`export const makeTagged = (...) => {...};` doesn't include `harden`, and then `harden(makeTagged)` appears below. §the-pattern-IS-NOT `export const makeTagged = harden((...) => {...})` because §the-recursive-`harden`-call-needs-the-named-binding.

§sibling-pattern to many factory-function exports in `@endo/*` — the harden-the-factory-after-export idiom; §first-explicit-observation in library of §the-factory-harden-after-export-idiom-IS-the-canonical-form-when-the-factory-is-named.
