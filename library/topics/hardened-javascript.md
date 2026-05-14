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
| [endo--pkg-ses-readme--overview](../sections/endo--pkg-ses-readme--overview.md) | endo packages/ses/README.md | The flagship @endo/ses overview: SES shim, lockdown/harden/Compartment verbs. |
| [endo--pkg-ses-readme--install](../sections/endo--pkg-ses-readme--install.md) | endo packages/ses/README.md | Install via npm/yarn; shim auto-loads on import. |
| [endo--pkg-ses-readme--usage-core](../sections/endo--pkg-ses-readme--usage-core.md) | endo packages/ses/README.md | Lockdown, Harden, Compartment usage consolidated. |
| [endo--pkg-ses-readme--usage-modules](../sections/endo--pkg-ses-readme--usage-modules.md) | endo packages/ses/README.md | Compartment module loading: descriptors, hooks, virtual sources, transforms. |
| [endo--pkg-ses-readme--usage-error-handling](../sections/endo--pkg-ses-readme--usage-error-handling.md) | endo packages/ses/README.md | Causal-console error logging and module-loading error policies. |
| [endo--pkg-ses-readme--security-claims-and-caveats](../sections/endo--pkg-ses-readme--security-claims-and-caveats.md) | endo packages/ses/README.md | Security analysis: isolation tiers, endowment protection, caveats, TCB. |
| [endo--pkg-ses-readme--audits](../sections/endo--pkg-ses-readme--audits.md) | endo packages/ses/README.md | Inventory of security audits SES has undergone. |
| [endo--pkg-ses-readme--bug-disclosure](../sections/endo--pkg-ses-readme--bug-disclosure.md) | endo packages/ses/README.md | Pointer to coordinated-disclosure protocol. |
| [endo--pkg-ses-readme--ecosystem-compatibility](../sections/endo--pkg-ses-readme--ecosystem-compatibility.md) | endo packages/ses/README.md | What works and what does not when SES is applied to common JS libraries. |
| [endo--docs-guide--what-is-hardenedjs-ses-endo](../sections/endo--docs-guide--what-is-hardenedjs-ses-endo.md) | endo docs/guide.md | Definitions: HardenedJS, SES, Endo. |
| [endo--docs-guide--hardenedjs-story](../sections/endo--docs-guide--hardenedjs-story.md) | endo docs/guide.md | Historical narrative for HardenedJS from E and Joe-E to MetaMask. |
| [endo--docs-guide--using-hardenedjs-with-your-code](../sections/endo--docs-guide--using-hardenedjs-with-your-code.md) | endo docs/guide.md | Guide-shaped onboarding (overlaps reference / get-started). |
| [endo--docs-guide--using-hardenedjs-with-vetted-shims](../sections/endo--docs-guide--using-hardenedjs-with-vetted-shims.md) | endo docs/guide.md | Vetted-shim pattern for constrained environments. |
| [endo--docs-guide--what-lockdown-does-removes-adds](../sections/endo--docs-guide--what-lockdown-does-removes-adds.md) | endo docs/guide.md | Guide-shaped account of lockdown's modifications (overlaps reference). |
| [endo--docs-guide--realms-and-compartments](../sections/endo--docs-guide--realms-and-compartments.md) | endo docs/guide.md | Realms and Compartments as related isolation primitives. |
| [endo--docs-guide--api-overview](../sections/endo--docs-guide--api-overview.md) | endo docs/guide.md | Guide-shaped overview of lockdown/repair/harden API verbs (overlaps reference). |
| [endo--docs-guide--library-compatibility](../sections/endo--docs-guide--library-compatibility.md) | endo docs/guide.md | Library compatibility under SES (overlaps pkg-ses-readme--ecosystem-compatibility). |
| [endo--docs-guide--html-comments](../sections/endo--docs-guide--html-comments.md) | endo docs/guide.md | HTML comments in JS source and SES taming. |
| [endo--docs-guide--direct-vs-indirect-eval](../sections/endo--docs-guide--direct-vs-indirect-eval.md) | endo docs/guide.md | Direct vs indirect eval semantics under SES. |

## See also

- [`compartments`](compartments.md): how SES isolates guest code.
- [`capability-security`](capability-security.md): the discipline SES is the substrate for.
- [`errors`](errors.md): the error/assert/console system on top of the substrate.
