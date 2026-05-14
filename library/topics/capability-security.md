# Topic: capability-security

> Abstract: Object-capability security as practiced in the Endo / Agoric stack. A capability is an unforgeable reference; possession is permission. Code is confined to acting through the capability references it holds; ambient authority is eliminated. Related to but distinct from `hardened-javascript` (the substrate that makes ocap enforceable in JS) and `compartments` (the isolation mechanism).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--hiding-revealing-local-diagnostic](../sections/endo--docs-errors--hiding-revealing-local-diagnostic.md) | endo docs/errors.md | The in-band / out-of-band frame is itself an ocap distinction: console is meta-level and powerful. |
| [endo--docs-get-started--confining-node-applications](../sections/endo--docs-get-started--confining-node-applications.md) | endo docs/get-started.md | Tutorial walk-through of confining via explicit endowments. |
| [endo--docs-get-started--distributed-programming](../sections/endo--docs-get-started--distributed-programming.md) | endo docs/get-started.md | Capability-bearing remotables introduction. |
| [endo--docs-get-started--use-cases](../sections/endo--docs-get-started--use-cases.md) | endo docs/get-started.md | Motivating use cases for capability confinement. |

## See also

- [`hardened-javascript`](hardened-javascript.md): substrate that makes ocap discipline enforceable.
- [`compartments`](compartments.md): the isolation primitive.
- [`exo`](exo.md): the class API for capability-bearing objects.
- [`marshal`](marshal.md): how capabilities cross boundaries via pass-style.
