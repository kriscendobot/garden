# Topic: errors

> Abstract: How SES handles errors: a three-piece system of tamed `Error` constructor + `assert` global + causal `console`. Hidden diagnostic information (stacks, detailed message data, error annotations) flows through per-realm side tables so the console can produce informative logs without exposing the data to in-band code. Distinct from log-aggregation frameworks (which produce symbolic records for post-processing); this system targets the developer's direct debugging experience.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [agoric-sdk--docs-env--all-vars](../sections/agoric-sdk--docs-env--all-vars.md) | agoric-sdk docs/env.md | All 25 agoric-sdk environment variables, alphabetical. |
| [endo--docs-errors--configuration-variations](../sections/endo--docs-errors--configuration-variations.md) | endo docs/errors.md | The error/assert/console system runs across multiple configurations: pre-repair, post-repair start compartment (with all `errorTaming` and `consoleTaming` combinations), and created compartments. |
| [endo--docs-errors--goals-non-goals](../sections/endo--docs-errors--goals-non-goals.md) | endo docs/errors.md | The three building blocks of JS developer debugging (thrown errors with stack traces, `assert` convenience, built-in `console`) must be preserved under the constraints of a secure, distributed, deterministic blockchain system. |
| [endo--docs-errors--hiding-revealing-async-diagnostic](../sections/endo--docs-errors--hiding-revealing-async-diagnostic.md) | endo docs/errors.md | Plans (not implemented) for "deep asynchronous stacks." |
| [endo--docs-errors--hiding-revealing-distributed-diagnostic](../sections/endo--docs-errors--hiding-revealing-distributed-diagnostic.md) | endo docs/errors.md | Plans (not implemented) for distributed error diagnostics across mutually suspicious platforms. |
| [endo--docs-errors--hiding-revealing-local-diagnostic](../sections/endo--docs-errors--hiding-revealing-local-diagnostic.md) | endo docs/errors.md | Three categories of diagnostic info are hidden from in-band code but available to the causal console via per-realm side tables: error stack traces, detailed error message data (via `assert`'s `details` template tag), and error annotations (added by higher-level catch clauses). |
| [endo--docs-errors--overview](../sections/endo--docs-errors--overview.md) | endo docs/errors.md | Summary of how SES handles error-related diagnostic information: an `assert` global adds hidden-from-callers annotations, the global `Error` is tamed to hide stacks, and the global `console` (the "causal console") reveals annotations and stacks back to the real console. |
| [endo--docs-errors--unreal-logging](../sections/endo--docs-errors--unreal-logging.md) | endo docs/errors.md | A speculative model where "real" computation never logs; logging happens only under instrumented deterministic replay of recorded traces. |
| [endo--docs-lockdown--console-taming](../sections/endo--docs-lockdown--console-taming.md) | endo docs/lockdown.md | Controls whether the global console is virtualized during lockdown. |
| [endo--docs-lockdown--error-taming](../sections/endo--docs-lockdown--error-taming.md) | endo docs/lockdown.md | Controls Error.stack visibility and the Error constructor taming. |
| [endo--docs-lockdown--error-trapping](../sections/endo--docs-lockdown--error-trapping.md) | endo docs/lockdown.md | Controls handling of uncaught exceptions. |
| [endo--docs-lockdown--reporting](../sections/endo--docs-lockdown--reporting.md) | endo docs/lockdown.md | Controls where SES sends its own diagnostic warnings (distinct from the tamed console). |
| [endo--docs-lockdown--stack-filtering](../sections/endo--docs-lockdown--stack-filtering.md) | endo docs/lockdown.md | Controls signal-to-noise filtering of stack traces in the causal console. |
| [endo--docs-lockdown--unhandled-rejection-trapping](../sections/endo--docs-lockdown--unhandled-rejection-trapping.md) | endo docs/lockdown.md | Controls handling of finalized unhandled promise rejections. |
| [endo--pkg-errors-readme--overview](../sections/endo--pkg-errors-readme--overview.md) | endo packages/errors/README.md | @endo/errors: package-level interface for the assert and error utilities described in docs/errors.md. |
| [endo--pkg-eventual-send-readme--e-when](../sections/endo--pkg-eventual-send-readme--e-when.md) | endo packages/eventual-send/README.md | The eventual-send analog of .then: schedules onFulfilled/onRejected callbacks against a promise or local value, but does so in a future turn. |
| [endo--pkg-ses-readme--usage-error-handling](../sections/endo--pkg-ses-readme--usage-error-handling.md) | endo packages/ses/README.md | Two error-handling sub-sections under Usage: Logging Errors describes how the tamed causal console interacts with thrown errors; Controlling Module-Loading Errors covers Compartment-level error policies for failed module resolution. |
| [ocapn--draft-specifications-model--error](../sections/ocapn--draft-specifications-model--error.md) | upstream protocol draft-specifications/Model.md | OCapN Error: an error value sent by copy. |

## See also

- [`hardened-javascript`](hardened-javascript.md): the SES taming layer this system runs on top of.
- [`compartments`](compartments.md): the console-filter tree maps onto the compartment tree.
- [`capability-security`](capability-security.md): the asymmetric in-band / out-of-band frame is a capability-discipline question.
- [`eventual-send`](eventual-send.md): the `E()` / `E.when` operations the async deep-stack plan instruments.
- [`captp`](captp.md): the transport-level error-by-copy plumbing the distributed plan relies on.
- [`marshal`](marshal.md): serialization of errors across compartment and process boundaries.
