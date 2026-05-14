# Topic: getting-started

> Abstract: The on-ramp into Endo: install commands, first encounters with Hardened JavaScript and Compartments, walk-through of confining a Node.js-style application, and the bridge into distributed programming via eventual-send and OCapN. Tutorial-shaped content, distinct from reference-shaped per-option or per-API material elsewhere in the library.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [agoric-sdk--contributing--overview-platforms-and-toolchain](../sections/agoric-sdk--contributing--overview-platforms-and-toolchain.md) | agoric-sdk CONTRIBUTING.md | Frame and toolchain prerequisites. |
| [agoric-sdk--docs-node-version--overview](../sections/agoric-sdk--docs-node-version--overview.md) | agoric-sdk docs/node-version.md | Agoric-sdk's supported Node.js version. |
| [agoric-sdk--pkg-inter-protocol-readme--demo](../sections/agoric-sdk--pkg-inter-protocol-readme--demo.md) | agoric-sdk packages/inter-protocol/README.md | The demo procedure spans three terminals. |
| [agoric-sdk--pkg-orchestration-readme--overview](../sections/agoric-sdk--pkg-orchestration-readme--overview.md) | agoric-sdk packages/orchestration/README.md | One-line frame plus a pointer at `src/examples`. |
| [agoric-sdk--pkg-zoe-readme--what-is-zoe](../sections/agoric-sdk--pkg-zoe-readme--what-is-zoe.md) | agoric-sdk packages/zoe/README.md | Zoe is a framework for building smart contracts (auctions, swaps, decentralized exchanges, …). |
| [agoric-sdk--readme--overview](../sections/agoric-sdk--readme--overview.md) | agoric-sdk README.md | The Agoric Platform SDK repo contains most of the packages making up the upper layers of the Agoric platform. |
| [agoric-sdk--readme--prerequisites](../sections/agoric-sdk--readme--prerequisites.md) | agoric-sdk README.md | agoric-sdk's toolchain prerequisites: Git, Go ^1.24.1, Node.js ^20.9 or ^22.11 (latest LTS recommended via nvm), Yarn (any version — `.yarnrc` pins the checked-in `.yarn/releases/` version), gcc ≥10 / clang ≥10 / another compiler with `__has_builtin()`. |
| [agoric-sdk--readme--run-the-larger-demo](../sections/agoric-sdk--readme--run-the-larger-demo.md) | agoric-sdk README.md | Quick-start demo recipe pointing at docs.agoric.com getting-started. |
| [endo--docs-get-started--confining-node-applications](../sections/endo--docs-get-started--confining-node-applications.md) | endo docs/get-started.md | Walk-through of taking a normal Node.js application and confining it inside a Compartment, addressing how to provide bounded access to filesystem, network, and process resources via explicit endowments. |
| [endo--docs-get-started--distributed-programming](../sections/endo--docs-get-started--distributed-programming.md) | endo docs/get-started.md | Distributed programming concepts via Endo: eventual-send (E() / E.when), capability-bearing remotables, the OCapN family of transport protocols (CapTP, marshal, netstring), and the daemon model. |
| [endo--docs-get-started--first-steps-hardened-js](../sections/endo--docs-get-started--first-steps-hardened-js.md) | endo docs/get-started.md | Hands-on introduction to Hardened JavaScript: calling lockdown(), demonstrating frozen intrinsics, the harden() pattern, and using a Compartment to isolate guest code with explicit endowments. |
| [endo--docs-get-started--installing](../sections/endo--docs-get-started--installing.md) | endo docs/get-started.md | Endo requires a supported version of Node.js and a package manager (npm or yarn; inside the Endo project specifically yarn). |
| [endo--docs-get-started--resources-next-steps](../sections/endo--docs-get-started--resources-next-steps.md) | endo docs/get-started.md | Pointers to further reading: the docs/ tree (lockdown, errors, message-passing, security), key package READMEs (ses, eventual-send, marshal), the SES specification, talks, and how to file issues. |
| [endo--docs-get-started--use-cases](../sections/endo--docs-get-started--use-cases.md) | endo docs/get-started.md | Short enumeration of categories where Endo confinement is useful: AI agent sandboxes, supply-chain protection, plugin systems, blockchain smart contracts, and developer tools. |
| [endo--docs-guide--using-hardenedjs-with-your-code](../sections/endo--docs-guide--using-hardenedjs-with-your-code.md) | endo docs/guide.md | Practical onboarding for adding HardenedJS to a JS project. |
| [endo--docs-message-passing--next-steps](../sections/endo--docs-message-passing--next-steps.md) | endo docs/message-passing.md | Pointers to deeper material: per-package READMEs (marshal, patterns, eventual-send, exo), the SES specification, Agoric documentation for blockchain-side use, and community discussion channels. |
| [endo--docs-reference--using-ses-with-your-code](../sections/endo--docs-reference--using-ses-with-your-code.md) | endo docs/reference.md | How to add SES to an existing JS project: install the @endo/lockdown package, call lockdown() once at program start before any other module loads, then proceed normally. |
| [endo--readme--overview](../sections/endo--readme--overview.md) | endo README.md | The repository's top-level README. |

## See also

- [`hardened-javascript`](hardened-javascript.md): the substrate the tutorial introduces.
- [`compartments`](compartments.md): the isolation primitive the tutorial demonstrates.
- [`capability-security`](capability-security.md): the underlying discipline.
- [`eventual-send`](eventual-send.md): the distributed-programming primitive.
- [`captp`](captp.md), [`ocapn`](ocapn.md): the transports the tutorial points at.
