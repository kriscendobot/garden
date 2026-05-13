# Topic: compartments

> Abstract: SES compartments isolate guest code in a tree rooted at the start compartment. Each compartment has its own global scope and its own module map but shares the realm's intrinsics. Endowments (powerful objects like `console` or `assert`) cross compartment boundaries only when explicitly passed in. The compartment tree is the canonical structure for filtering consoles, scoping errors, and bounding effects.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--configuration-variations](../sections/endo--docs-errors--configuration-variations.md) | endo docs/errors.md | Created compartments share one safe `Error` and `assert`; each has its own filtering console in a tree. |
| [endo--docs-errors--hiding-revealing-local-diagnostic](../sections/endo--docs-errors--hiding-revealing-local-diagnostic.md) | endo docs/errors.md | Console-tree filtering uses the compartment tree as its topic axis. |

## See also

- [`hardened-javascript`](hardened-javascript.md): SES substrate underlying compartments.
- [`capability-security`](capability-security.md): why endowment-only authority matters.
- [`bundles`](bundles.md): how compartment-mapper assembles module graphs into compartments.
