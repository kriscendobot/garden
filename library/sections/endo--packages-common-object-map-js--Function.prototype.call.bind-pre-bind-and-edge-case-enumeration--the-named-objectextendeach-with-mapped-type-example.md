---
title: §the-named-objectExtendEach-with-mapped-type-example
source: endo--packages-common-object-map-js
url: https://github.com/endojs/endo/blob/master/packages/common/object-map.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/common/object-map.js
total-lines: 126
ingest-cycle: 334
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-Function.prototype.call.bind-as-method-extraction
  - the-named-callable-form-of-prototype-method-via-bind-call
  - the-named-tamper-resistance-via-pre-bind-at-module-load
  - the-named-typed-re-export-of-native-method
  - the-named-five-named-edge-cases-in-JSDoc
  - the-named-edge-cases-enumerated-in-JSDoc-discipline
  - the-named-CopyRecord-result-IS-conditional-on-mapped-values-Passable
  - the-named-objectExtendEach-with-mapped-type-example
  - the-named-JSDoc-as-tutorial-not-just-reference
  - the-named-constraint-discipline
  - the-named-rest-spread-of-primitive-silently-yields-empty
  - the-named-harden-on-every-export
  - the-named-only-one-import
  - the-named-deprecation-canonical-source-arc-closure
  - twenty-five-cycles-with-named-pivot-domain-stay
  - seven-cycles-with-named-one-cycle-README-source-arc
  - forty-six-citation-arc-closures-in-pivot-now
parent: endo--packages-common-object-map-js--Function.prototype.call.bind-pre-bind-and-edge-case-enumeration
---

The `objectExtendEach` JSDoc (line 80-110) includes a *worked TypeScript example* showing the mapped-type behavior:

```js
const chains = {
  ethereum: { namespace: 'eip155', reference: '1' },
  solana: { namespace: 'solana', reference: 'mainnet' },
} as const;

const withChainId = objectExtendEach(chains, v => ({
  chainId: `${v.namespace}:${v.reference}`,
}));
// {
//   ethereum: { namespace: 'eip155'; reference: '1' } & { chainId: string };
//   solana:   { namespace: 'solana'; reference: 'mainnet' } & { chainId: string };
// }
```

**§the-named-JSDoc-as-tutorial-not-just-reference** — the JSDoc isn't just signature documentation; it's a worked example with expected type-level output shown in comment form. First-explicit-observation. Sibling to cycle 327 patterns README's Quick-Start-shows-error-output discipline.
