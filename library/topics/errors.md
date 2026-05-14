# Topic: errors

> Abstract: How SES handles errors: a three-piece system of tamed `Error` constructor + `assert` global + causal `console`. Hidden diagnostic information (stacks, detailed message data, error annotations) flows through per-realm side tables so the console can produce informative logs without exposing the data to in-band code. Distinct from log-aggregation frameworks (which produce symbolic records for post-processing); this system targets the developer's direct debugging experience.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--overview](../sections/endo--docs-errors--overview.md) | endo docs/errors.md | Summary of the three-piece system and the `TRACK_TURNS` deep-stack toggle. |
| [endo--docs-errors--goals-non-goals](../sections/endo--docs-errors--goals-non-goals.md) | endo docs/errors.md | Preserve JS developer experience under secure / distributed / deterministic constraints. |
| [endo--docs-errors--configuration-variations](../sections/endo--docs-errors--configuration-variations.md) | endo docs/errors.md | Pre-lockdown / post-lockdown / created compartments; recommended endowment pattern. |
| [endo--docs-errors--hiding-revealing-local-diagnostic](../sections/endo--docs-errors--hiding-revealing-local-diagnostic.md) | endo docs/errors.md | Side tables and console-tree filtering for local diagnostics. |
| [endo--docs-errors--hiding-revealing-distributed-diagnostic](../sections/endo--docs-errors--hiding-revealing-distributed-diagnostic.md) | endo docs/errors.md | Plans for distributed log correlation via comm-side identifiers (not implemented). |
| [endo--docs-errors--hiding-revealing-async-diagnostic](../sections/endo--docs-errors--hiding-revealing-async-diagnostic.md) | endo docs/errors.md | Plans for `E()` and `E.when` instrumentation building deep-stack chains (not implemented). |
| [endo--docs-errors--unreal-logging](../sections/endo--docs-errors--unreal-logging.md) | endo docs/errors.md | Speculative no-real-logging model that lifts memory and channel concerns. |
| [endo--docs-lockdown--console-taming](../sections/endo--docs-lockdown--console-taming.md) | endo docs/lockdown.md | The `consoleTaming` lockdown option configures whether the global console is replaced by the causal console. |
| [endo--docs-lockdown--error-taming](../sections/endo--docs-lockdown--error-taming.md) | endo docs/lockdown.md | The `errorTaming` lockdown option hides Error.stack from in-band code by default. |
| [endo--docs-lockdown--error-trapping](../sections/endo--docs-lockdown--error-trapping.md) | endo docs/lockdown.md | The `errorTrapping` lockdown option chooses how uncaught exceptions are handled. |
| [endo--docs-lockdown--reporting](../sections/endo--docs-lockdown--reporting.md) | endo docs/lockdown.md | The `reporting` lockdown option chooses where SES's own warnings go. |
| [endo--docs-lockdown--unhandled-rejection-trapping](../sections/endo--docs-lockdown--unhandled-rejection-trapping.md) | endo docs/lockdown.md | The `unhandledRejectionTrapping` lockdown option chooses how finalized unhandled rejections are reported. |
| [endo--docs-lockdown--stack-filtering](../sections/endo--docs-lockdown--stack-filtering.md) | endo docs/lockdown.md | The `stackFiltering` lockdown option chooses signal-to-noise for stack traces. |
| [endo--pkg-eventual-send-readme--e-when](../sections/endo--pkg-eventual-send-readme--e-when.md) | endo packages/eventual-send/README.md | E.when: safe SES-compatible analog of .then for promise resolution. |
| [endo--pkg-ses-readme--usage-error-handling](../sections/endo--pkg-ses-readme--usage-error-handling.md) | endo packages/ses/README.md | Causal-console error logging and module-loading error policies in SES. |

## See also

- [`hardened-javascript`](hardened-javascript.md): the SES taming layer this system runs on top of.
- [`compartments`](compartments.md): the console-filter tree maps onto the compartment tree.
- [`capability-security`](capability-security.md): the asymmetric in-band / out-of-band frame is a capability-discipline question.
- [`eventual-send`](eventual-send.md): the `E()` / `E.when` operations the async deep-stack plan instruments.
- [`captp`](captp.md): the transport-level error-by-copy plumbing the distributed plan relies on.
- [`marshal`](marshal.md): serialization of errors across compartment and process boundaries.
