# Topic: capability-security

> Abstract: Object-capability security as practiced in the Endo / Agoric stack. A capability is an unforgeable reference; possession is permission. Code is confined to acting through the capability references it holds; ambient authority is eliminated. Related to but distinct from `hardened-javascript` (the substrate that makes ocap enforceable in JS) and `compartments` (the isolation mechanism).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--hiding-revealing-local-diagnostic](../sections/endo--docs-errors--hiding-revealing-local-diagnostic.md) | endo docs/errors.md | The in-band / out-of-band frame is itself an ocap distinction: console is meta-level and powerful. |
| [endo--docs-get-started--confining-node-applications](../sections/endo--docs-get-started--confining-node-applications.md) | endo docs/get-started.md | Tutorial walk-through of confining via explicit endowments. |
| [endo--docs-get-started--distributed-programming](../sections/endo--docs-get-started--distributed-programming.md) | endo docs/get-started.md | Capability-bearing remotables introduction. |
| [endo--docs-get-started--use-cases](../sections/endo--docs-get-started--use-cases.md) | endo docs/get-started.md | Motivating use cases for capability confinement. |
| [endo--pkg-marshal-readme--pass-by-presence-vs-copy](../sections/endo--pkg-marshal-readme--pass-by-presence-vs-copy.md) | endo packages/marshal/README.md | Distinguishing data values (pass-by-copy) from capability references (pass-by-presence). |
| [endo--pkg-pass-style-readme--far](../sections/endo--pkg-pass-style-readme--far.md) | endo packages/pass-style/README.md | Far(iface, methods): the recommended way to construct a capability-bearing remotable. |
| [endo--pkg-pass-style-readme--pass-by-copy-vs-presence](../sections/endo--pkg-pass-style-readme--pass-by-copy-vs-presence.md) | endo packages/pass-style/README.md | The pass-by-copy vs pass-by-presence distinction with capability identity. |
| [endo--pkg-exo-readme--why-exo](../sections/endo--pkg-exo-readme--why-exo.md) | endo packages/exo/README.md | Exo motivation: declarative guards and explicit state for capability discipline. |
| [endo--pkg-exo-readme--defineexoclasskit-multiple-facets](../sections/endo--pkg-exo-readme--defineexoclasskit-multiple-facets.md) | endo packages/exo/README.md | Multi-facet exos: the canonical attenuator pattern. |
| [endo--pkg-eventual-send-readme--why-eventual-send](../sections/endo--pkg-eventual-send-readme--why-eventual-send.md) | endo packages/eventual-send/README.md | Why E() over .then: uniform local/remote API for capability-bearing objects. |
| [endo--pkg-ses-readme--usage-core](../sections/endo--pkg-ses-readme--usage-core.md) | endo packages/ses/README.md | Core verbs (lockdown, harden, Compartment) underpinning capability discipline. |
| [endo--pkg-ses-readme--security-claims-and-caveats](../sections/endo--pkg-ses-readme--security-claims-and-caveats.md) | endo packages/ses/README.md | Endowment protection and trusted compute base analysis. |
| [endo--docs-message-passing--introduction](../sections/endo--docs-message-passing--introduction.md) | endo docs/message-passing.md | Framing for capability-bearing message exchange. |
| [endo--docs-message-passing--defensive-receive-protected-objects](../sections/endo--docs-message-passing--defensive-receive-protected-objects.md) | endo docs/message-passing.md | Building receiving objects that protect themselves: Exo, kits, attenuation. |
| [endo--docs-message-passing--digital-purse-example](../sections/endo--docs-message-passing--digital-purse-example.md) | endo docs/message-passing.md | Worked example of capability-discipline in action. |
| [endo--docs-message-passing--design-patterns-and-best-practices](../sections/endo--docs-message-passing--design-patterns-and-best-practices.md) | endo docs/message-passing.md | Idioms for capability-bearing code: revocation, state ownership, attenuation. |
| [endo--docs-guide--what-is-hardenedjs-ses-endo](../sections/endo--docs-guide--what-is-hardenedjs-ses-endo.md) | endo docs/guide.md | Definitions including the ocap discipline that HardenedJS realizes. |
| [endo--docs-guide--hardenedjs-story](../sections/endo--docs-guide--hardenedjs-story.md) | endo docs/guide.md | History from E and Joe-E to MetaMask: how ocap reached JS production. |
| [agoric-sdk--agents--coding-style-and-naming-conventions](../sections/agoric-sdk--agents--coding-style-and-naming-conventions.md) | agoric-sdk AGENTS.md | Ambient-authority discipline: keep process.env/console/fs/network in entrypoints; pass capabilities into modules. |

## See also

- [`hardened-javascript`](hardened-javascript.md): substrate that makes ocap discipline enforceable.
- [`compartments`](compartments.md): the isolation primitive.
- [`exo`](exo.md): the class API for capability-bearing objects.
- [`marshal`](marshal.md): how capabilities cross boundaries via pass-style.
