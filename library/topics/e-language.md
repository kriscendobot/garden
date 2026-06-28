# Topic: e-language

> Abstract: E is Mark Miller's capability-secure distributed programming language (object capabilities, vats, the event loop, eventual-send, and the Pluribus cryptographic protocol) and the direct intellectual ancestor of Hardened JavaScript / SES / Endo. This topic collects library sections drawn from the erights.org E-language documentation itself (its concrete syntax and semantics: sameness, selfless/selfish objects, the doc-tree map), as distinct from the capability-theory *papers* (filed under `capability-theory` / `capability-security`) that argue the underlying discipline. Use this topic when looking up how E itself worked at the language level and how a given E construct maps to its Endo equivalent.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [erights--elang-index--overview](../sections/erights--elang-index--overview.md) | erights.org elang/index.html | The E documentation tree (tutorial, grammar, Kernel-E, sameness, data types, concurrency), E's "Cryptographic Capabilities for Distributed Smart Contracting" self-description, and the E-to-Endo translation. |
| [erights--elang-same-ref--synchronous-sameness-and-reflexivity](../sections/erights--elang-same-ref--synchronous-sameness-and-reflexivity.md) | erights.org elang/same-ref.html | E's `==` synchronous sameness defined by substitutability; reflexive even for NaN (unlike IEEE); `<=>` for magnitude; scalar same-type-and-value rule. |
| [erights--elang-same-ref--selfish-and-selfless-objects](../sections/erights--elang-same-ref--selfish-and-selfless-objects.md) | erights.org elang/same-ref.html | Selfish (identity-compared) vs selfless (contents-compared, transparent, pass-by-copy between vats) objects and the three conditions for selflessness; ancestor of Endo pass-style. |

## See also

- [`pass-style`](pass-style.md): Endo's descendant of E's selfless/selfish split (pass-by-copy data vs pass-by-reference Remotables).
- [`capability-theory`](capability-theory.md): the papers that argue the discipline E embodies (Granovetter operator, POLA, object-capability model).
- [`capability-security`](capability-security.md): the Endo-side practice of the same discipline.
- [`eventual-send`](eventual-send.md): E's eventual-send / vat model, descended into `@endo/eventual-send` and `E()`.
