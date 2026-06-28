---
id: kernel-e
aliases: ["Kernel-E", "Kernel E", "kernel language", "E kernel language", "kernel-E expansion", "canonical expansion to Kernel-E", "Kernel-E parse tree", "Kernel-E special forms"]
topics: [e-language, capability-security]
---

# kernel-e

**Kernel-E** is the small lambda-calculus-like subset of Mark Miller's E language
that all of surface E is parsed into. E is specified in two layers: the full
LALR(1) surface grammar, and a **canonical expansion** of every surface construct
into Kernel-E that happens during parsing. Because E parse trees contain only
Kernel-E nodes, the expansion of a construct *is* its only precise meaning (surface
E is sugar; Kernel-E is semantics), and giving Kernel-E a semantics suffices to
give all of E one. The kernel comprises roughly fifteen expression special forms
(literal, noun, slot, assign, seq, matchBind, define, hide, if, escape, try/catch,
try/finally, call `.`, send `<-`, object) and a handful of pattern forms
(final/var/ignore, suchThat, list, cdr); its semantics is specified by an
executable **meta-circular interpreter** that reifies `eval` and absorbs `apply`
plus capability security, leaving upgrade and debugging to be added as enhanced
meta-interpreters. Kernel-E is the E-language enactment of the "small trusted core,
sugar by translation" discipline that Hardened JavaScript reuses for the SES
intrinsics versus the surface language, and its `<-` eventual-send and slot/
reference model are kernel-level roots of Endo's `E()` and reference semantics.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [erights/elang-kernel/overview](../sections/erights--elang-kernel--overview.md) | Kernel-E as the bottom specification layer; semantics by meta-circular interpreter; reify-eval / absorb-apply staging that keeps enhanced (upgrade, debugging) interpreters analyzable against a secure base. |
| [erights/elang-kernel/expression-forms](../sections/erights--elang-kernel--expression-forms.md) | The eExpr quick-reference card: every kernel expression special form with its pseudo-BNF (literal, noun, slot, assign, seq, matchBind, define, hide, if, escape, catch, finally, call, send, object/methodical/plumbing). |
| [erights/elang-kernel/pattern-forms-and-helpers](../sections/erights--elang-kernel--pattern-forms-and-helpers.md) | The pattern forms (final/var/ignore, suchThat, list, cdr; the `: eExpr` guard hook), the helper productions (auditors, eMethod, matcher, eScript, behavior, docComment), and terminals. |
| [erights/elang-kernel/meta-interpreter-semantics](../sections/erights--elang-kernel--meta-interpreter-semantics.md) | The executable semantics: four name spaces, the four indirections (noun→pattern→slot→reference→object), eval's success/failure/escape outcomes, testMatch/mustMatch, and object state-nouns. |
| [erights/elang-grammar/grammar-and-kernel-e-expansion](../sections/erights--elang-grammar--grammar-and-kernel-e-expansion.md) | The grammar chapter's two-layer framing: surface E defined by canonical expansion to Kernel-E, the manual this concept's other sections detail. |

## See also

- [[e-language]] — Kernel-E is E's semantic core; the `e-language` concept covers the surface language and its lineage to Endo (this concept narrows its former "Kernel-E" alias).
- [[object-sameness]] — Miller's E equality taxonomy; Kernel-E notes that all inter-object interaction *except equality* is pure message-sending.
- [[eventual-send]] — Kernel-E's `sendExpr` (`<-`) and eventual cross-machine references are the kernel-level ancestor of `@endo/eventual-send` / `E()`.
- [[vat-and-compartment]] — the per-instance scope-as-state and near/eventual reference model Kernel-E specifies is the substrate of E's vat semantics.
