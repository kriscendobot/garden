# Topic: getting-started

> Abstract: The on-ramp into Endo: install commands, first encounters with Hardened JavaScript and Compartments, walk-through of confining a Node.js-style application, and the bridge into distributed programming via eventual-send and OCapN. Tutorial-shaped content, distinct from reference-shaped per-option or per-API material elsewhere in the library.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-get-started--installing](../sections/endo--docs-get-started--installing.md) | endo docs/get-started.md | Node.js + npm/yarn prerequisites; install command pointers. |
| [endo--docs-get-started--first-steps-hardened-js](../sections/endo--docs-get-started--first-steps-hardened-js.md) | endo docs/get-started.md | First encounter with lockdown, harden, Compartment. |
| [endo--docs-get-started--confining-node-applications](../sections/endo--docs-get-started--confining-node-applications.md) | endo docs/get-started.md | Confining a normal Node.js app inside a Compartment with explicit endowments. |
| [endo--docs-get-started--distributed-programming](../sections/endo--docs-get-started--distributed-programming.md) | endo docs/get-started.md | Eventual-send, CapTP, OCapN, daemon model. |
| [endo--docs-get-started--use-cases](../sections/endo--docs-get-started--use-cases.md) | endo docs/get-started.md | Motivating examples: AI agents, supply-chain, plugins, smart contracts, dev tools. |
| [endo--docs-get-started--resources-next-steps](../sections/endo--docs-get-started--resources-next-steps.md) | endo docs/get-started.md | Pointers to the docs/ tree, key package READMEs, SES spec, talks, issue filing. |
| [endo--docs-reference--using-ses-with-your-code](../sections/endo--docs-reference--using-ses-with-your-code.md) | endo docs/reference.md | Reference-shaped onboarding for adding SES to a JS project. |

## See also

- [`hardened-javascript`](hardened-javascript.md): the substrate the tutorial introduces.
- [`compartments`](compartments.md): the isolation primitive the tutorial demonstrates.
- [`capability-security`](capability-security.md): the underlying discipline.
- [`eventual-send`](eventual-send.md): the distributed-programming primitive.
- [`captp`](captp.md), [`ocapn`](ocapn.md): the transports the tutorial points at.
