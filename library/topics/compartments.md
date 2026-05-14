# Topic: compartments

> Abstract: SES compartments isolate guest code in a tree rooted at the start compartment. Each compartment has its own global scope and its own module map but shares the realm's intrinsics. Endowments (powerful objects like `console` or `assert`) cross compartment boundaries only when explicitly passed in. The compartment tree is the canonical structure for filtering consoles, scoping errors, and bounding effects.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--configuration-variations](../sections/endo--docs-errors--configuration-variations.md) | endo docs/errors.md | Created compartments share one safe `Error` and `assert`; each has its own filtering console in a tree. |
| [endo--docs-errors--hiding-revealing-local-diagnostic](../sections/endo--docs-errors--hiding-revealing-local-diagnostic.md) | endo docs/errors.md | Console-tree filtering uses the compartment tree as its topic axis. |
| [endo--docs-lockdown--eval-taming](../sections/endo--docs-lockdown--eval-taming.md) | endo docs/lockdown.md | The `evalTaming` lockdown option controls eval and Function in the start compartment. |
| [endo--docs-get-started--first-steps-hardened-js](../sections/endo--docs-get-started--first-steps-hardened-js.md) | endo docs/get-started.md | Tutorial use of Compartment to isolate guest code with explicit endowments. |
| [endo--docs-get-started--confining-node-applications](../sections/endo--docs-get-started--confining-node-applications.md) | endo docs/get-started.md | Confining a Node.js app inside a Compartment. |
| [endo--pkg-ses-readme--usage-core](../sections/endo--pkg-ses-readme--usage-core.md) | endo packages/ses/README.md | Compartment as one of the SES core verbs alongside lockdown and harden. |
| [endo--pkg-ses-readme--usage-modules](../sections/endo--pkg-ses-readme--usage-modules.md) | endo packages/ses/README.md | Compartment module loading internals. |
| [endo--pkg-ses-readme--security-claims-and-caveats](../sections/endo--pkg-ses-readme--security-claims-and-caveats.md) | endo packages/ses/README.md | Compartment isolation tiers and security caveats. |

## See also

- [`hardened-javascript`](hardened-javascript.md): SES substrate underlying compartments.
- [`capability-security`](capability-security.md): why endowment-only authority matters.
- [`bundles`](bundles.md): how compartment-mapper assembles module graphs into compartments.
