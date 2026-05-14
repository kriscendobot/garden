# Topic: eventual-send

> Abstract: Eventual-send is the `E()` and `E.when` family of operations for messaging an object that may be local or remote, sync or async. Backed by handled promises so an `E(target).method(...)` call can be pipelined across a network round-trip. The two operations (`E()` and `E.when`) are the safe alternative to `.then` because `Promise.prototype.then` is implicitly invoked by built-in operations in ways user code cannot override.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--hiding-revealing-async-diagnostic](../sections/endo--docs-errors--hiding-revealing-async-diagnostic.md) | endo docs/errors.md | Plans to instrument `E()` and `E.when` to build deep-stack causality chains. |
| [endo--docs-lockdown--unhandled-rejection-trapping](../sections/endo--docs-lockdown--unhandled-rejection-trapping.md) | endo docs/lockdown.md | The `unhandledRejectionTrapping` lockdown option chooses how finalized unhandled rejections are surfaced. |
| [endo--docs-get-started--distributed-programming](../sections/endo--docs-get-started--distributed-programming.md) | endo docs/get-started.md | Tutorial introduction to E() and E.when for distributed programming. |
| [endo--pkg-exo-readme--async-methods-callwhen](../sections/endo--pkg-exo-readme--async-methods-callwhen.md) | endo packages/exo/README.md | M.callWhen() for async methods that declare arg shapes on resolved promise values. |
| [endo--pkg-eventual-send-readme--overview](../sections/endo--pkg-eventual-send-readme--overview.md) | endo packages/eventual-send/README.md | The package frame: E() and E.when for messaging local-or-remote objects. |
| [endo--pkg-eventual-send-readme--shim](../sections/endo--pkg-eventual-send-readme--shim.md) | endo packages/eventual-send/README.md | The HandledPromise shim that adds eventual-send to all promises. |
| [endo--pkg-eventual-send-readme--importing](../sections/endo--pkg-eventual-send-readme--importing.md) | endo packages/eventual-send/README.md | Import patterns: import { E } from '@endo/eventual-send'. |
| [endo--pkg-eventual-send-readme--e-method-call](../sections/endo--pkg-eventual-send-readme--e-method-call.md) | endo packages/eventual-send/README.md | E(target).method(args): the primary eventual-send call form. |
| [endo--pkg-eventual-send-readme--e-get-and-sendonly](../sections/endo--pkg-eventual-send-readme--e-get-and-sendonly.md) | endo packages/eventual-send/README.md | E.get and E.sendOnly: less-common Core API operations. |
| [endo--pkg-eventual-send-readme--e-when](../sections/endo--pkg-eventual-send-readme--e-when.md) | endo packages/eventual-send/README.md | E.when: the safe analog of .then for the eventual-send model. |
| [endo--pkg-eventual-send-readme--e-resolve](../sections/endo--pkg-eventual-send-readme--e-resolve.md) | endo packages/eventual-send/README.md | E.resolve: wrap a local value in a promise-shaped wrapper. |
| [endo--pkg-eventual-send-readme--promise-pipelining](../sections/endo--pkg-eventual-send-readme--promise-pipelining.md) | endo packages/eventual-send/README.md | Cross-boundary pipelining of E() chains to avoid round-trip costs. |
| [endo--pkg-eventual-send-readme--why-eventual-send](../sections/endo--pkg-eventual-send-readme--why-eventual-send.md) | endo packages/eventual-send/README.md | Four reasons for E() over .then: uniform API, message ordering, pipelining, future-proof. |
| [endo--pkg-eventual-send-readme--integration-with-exo](../sections/endo--pkg-eventual-send-readme--integration-with-exo.md) | endo packages/eventual-send/README.md | E() composing with Exo classes; M.callWhen() bridges async method declarations. |
| [endo--pkg-eventual-send-readme--handled-promise](../sections/endo--pkg-eventual-send-readme--handled-promise.md) | endo packages/eventual-send/README.md | The HandledPromise primitive underlying E(). |
| [endo--pkg-eventual-send-readme--use-in-tests](../sections/endo--pkg-eventual-send-readme--use-in-tests.md) | endo packages/eventual-send/README.md | Testing patterns for eventually-sent code. |
| [endo--pkg-eventual-send-readme--integration-with-endo](../sections/endo--pkg-eventual-send-readme--integration-with-endo.md) | endo packages/eventual-send/README.md | Cross-cutting map: marshal, captp, exo, patterns. |
| [endo--pkg-eventual-send-readme--background-and-see-also](../sections/endo--pkg-eventual-send-readme--background-and-see-also.md) | endo packages/eventual-send/README.md | TC39 proposal background; pointers to sister packages. |

## See also

- [`captp`](captp.md): the transport that makes eventual-send work across processes.
- [`errors`](errors.md): deep-stack instrumentation feeds the error/console system.
- [`exo`](exo.md): the kind of remotable object you message via `E()`.
