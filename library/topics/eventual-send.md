# Topic: eventual-send

> Abstract: Eventual-send is the `E()` and `E.when` family of operations for messaging an object that may be local or remote, sync or async. Backed by handled promises so an `E(target).method(...)` call can be pipelined across a network round-trip. The two operations (`E()` and `E.when`) are the safe alternative to `.then` because `Promise.prototype.then` is implicitly invoked by built-in operations in ways user code cannot override.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--hiding-revealing-async-diagnostic](../sections/endo--docs-errors--hiding-revealing-async-diagnostic.md) | endo docs/errors.md | Plans to instrument `E()` and `E.when` to build deep-stack causality chains. |
| [endo--docs-lockdown--unhandled-rejection-trapping](../sections/endo--docs-lockdown--unhandled-rejection-trapping.md) | endo docs/lockdown.md | The `unhandledRejectionTrapping` lockdown option chooses how finalized unhandled rejections are surfaced. |

## See also

- [`captp`](captp.md): the transport that makes eventual-send work across processes.
- [`errors`](errors.md): deep-stack instrumentation feeds the error/console system.
- [`exo`](exo.md): the kind of remotable object you message via `E()`.
