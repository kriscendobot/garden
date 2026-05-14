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
| [endo--docs-lockdown--overview](../sections/endo--docs-lockdown--overview.md) | endo docs/lockdown.md | The lockdown() API and option taxonomy: 14 safety-vs-compatibility options with `LOCKDOWN_*` env-var fallthroughs. |
| [endo--docs-lockdown--regexp-taming](../sections/endo--docs-lockdown--regexp-taming.md) | endo docs/lockdown.md | Delete `RegExp.prototype.compile` (default) or preserve it (unsafe); legacy RegExp static methods are removed under all settings. |
| [endo--docs-lockdown--locale-taming](../sections/endo--docs-lockdown--locale-taming.md) | endo docs/lockdown.md | Alias locale-sensitive methods to non-locale equivalents (default) or preserve original behavior (unsafe). |
| [endo--docs-lockdown--console-taming](../sections/endo--docs-lockdown--console-taming.md) | endo docs/lockdown.md | Wrap the global console (default) or leave platform console in place (unsafe). |
| [endo--docs-lockdown--error-taming](../sections/endo--docs-lockdown--error-taming.md) | endo docs/lockdown.md | Hide error stacks from in-band code (default); the longest option section. |
| [endo--docs-lockdown--error-trapping](../sections/endo--docs-lockdown--error-trapping.md) | endo docs/lockdown.md | Uncaught-exception handling: platform/exit/abort/report/none. |
| [endo--docs-lockdown--reporting](../sections/endo--docs-lockdown--reporting.md) | endo docs/lockdown.md | Where SES sends its own diagnostic warnings: platform/console/none. |
| [endo--docs-lockdown--unhandled-rejection-trapping](../sections/endo--docs-lockdown--unhandled-rejection-trapping.md) | endo docs/lockdown.md | Finalized unhandled rejections: report (default) or none. |
| [endo--docs-lockdown--eval-taming](../sections/endo--docs-lockdown--eval-taming.md) | endo docs/lockdown.md | eval/Function in the start compartment: safe-eval (default), unsafe-eval, or no-eval. |
| [endo--docs-lockdown--stack-filtering](../sections/endo--docs-lockdown--stack-filtering.md) | endo docs/lockdown.md | Stack-trace filtering: concise (default), omit-frames, shorten-paths, verbose. |
| [endo--docs-lockdown--override-taming](../sections/endo--docs-lockdown--override-taming.md) | endo docs/lockdown.md | Override-mistake antidote: min, moderate (default), severe. |
| [endo--docs-lockdown--override-debug](../sections/endo--docs-lockdown--override-debug.md) | endo docs/lockdown.md | Array of property names to actively detect override-mistake violations against. |
| [endo--docs-lockdown--domain-taming](../sections/endo--docs-lockdown--domain-taming.md) | endo docs/lockdown.md | Node's deprecated `domain` module: safe (remove) or unsafe (preserve). |
| [endo--docs-lockdown--legacy-regenerator-runtime-taming](../sections/endo--docs-lockdown--legacy-regenerator-runtime-taming.md) | endo docs/lockdown.md | regenerator-runtime (Babel transpiler output) taming. |
| [endo--docs-lockdown--harden-taming](../sections/endo--docs-lockdown--harden-taming.md) | endo docs/lockdown.md | Make `harden()` a no-op for performance in trusted environments. |
| [endo--docs-get-started--first-steps-hardened-js](../sections/endo--docs-get-started--first-steps-hardened-js.md) | endo docs/get-started.md | Tutorial first encounter with lockdown, harden, Compartment. |
| [endo--docs-get-started--confining-node-applications](../sections/endo--docs-get-started--confining-node-applications.md) | endo docs/get-started.md | Walk-through of confining a Node app inside a Compartment. |
| [endo--pkg-marshal-readme--frozen-objects-only](../sections/endo--pkg-marshal-readme--frozen-objects-only.md) | endo packages/marshal/README.md | Marshal requires harden()ed values; depends on the hardened-JS substrate. |
| [endo--docs-reference--overview](../sections/endo--docs-reference--overview.md) | endo docs/reference.md | Programmer's reference frame for SES + Endo. |
| [endo--docs-reference--using-ses-with-your-code](../sections/endo--docs-reference--using-ses-with-your-code.md) | endo docs/reference.md | How to add SES to a JS project: install, call lockdown, pitfalls. |
| [endo--docs-reference--removed-by-hardened-js](../sections/endo--docs-reference--removed-by-hardened-js.md) | endo docs/reference.md | Summary of JS globals SES removes/restricts. |
| [endo--docs-reference--added-changed-by-hardened-js](../sections/endo--docs-reference--added-changed-by-hardened-js.md) | endo docs/reference.md | Summary of what SES adds: Compartment, causal console, assert. |
| [endo--docs-reference--lockdown-api](../sections/endo--docs-reference--lockdown-api.md) | endo docs/reference.md | lockdown(options) API signature and idempotency. |
| [endo--docs-reference--repair-intrinsics-api](../sections/endo--docs-reference--repair-intrinsics-api.md) | endo docs/reference.md | repairIntrinsics(options) API: first phase of lockdown. |
| [endo--docs-reference--harden-intrinsics-api](../sections/endo--docs-reference--harden-intrinsics-api.md) | endo docs/reference.md | hardenIntrinsics() API: second phase of lockdown. |
| [endo--docs-reference--lockdown-and-harden](../sections/endo--docs-reference--lockdown-and-harden.md) | endo docs/reference.md | How the two main SES verbs relate. |
| [endo--docs-reference--lockdown-options-summary](../sections/endo--docs-reference--lockdown-options-summary.md) | endo docs/reference.md | Summary of lockdown options; overlaps with docs/lockdown.md per-option detail. |

## See also

- [`compartments`](compartments.md): how SES isolates guest code.
- [`capability-security`](capability-security.md): the discipline SES is the substrate for.
- [`errors`](errors.md): the error/assert/console system on top of the substrate.
