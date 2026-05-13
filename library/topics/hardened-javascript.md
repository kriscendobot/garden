# Topic: hardened-javascript

> Abstract: The Hardened JavaScript (SES) substrate: a frozen-intrinsics realm produced by calling `lockdown()`, on top of which all Endo-style ocap code runs. Tames the standard JavaScript globals so the surface available to guest code does not include authority-leaking footguns. Related but distinct from `compartments` (the isolation mechanism) and `capability-security` (the discipline).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--overview](../sections/endo--docs-errors--overview.md) | endo docs/errors.md | SES's tamed `Error` and tamed `console` are part of the hardened-JS substrate. |
| [endo--docs-errors--goals-non-goals](../sections/endo--docs-errors--goals-non-goals.md) | endo docs/errors.md | Why a hardened substrate preserves developer experience under secure/distributed/deterministic constraints. |
| [endo--docs-errors--configuration-variations](../sections/endo--docs-errors--configuration-variations.md) | endo docs/errors.md | Pre-lockdown and post-lockdown variants of the substrate; lockdown taming options. |
| [endo--docs-errors--hiding-revealing-local-diagnostic](../sections/endo--docs-errors--hiding-revealing-local-diagnostic.md) | endo docs/errors.md | Substrate-level mechanisms: per-realm side tables behind tamed globals. |
| [endo--docs-errors--unreal-logging](../sections/endo--docs-errors--unreal-logging.md) | endo docs/errors.md | A speculative variant of the substrate where logging is replay-only. |

## See also

- [`compartments`](compartments.md): how SES isolates guest code.
- [`capability-security`](capability-security.md): the discipline SES is the substrate for.
- [`errors`](errors.md): the error/assert/console system on top of the substrate.
