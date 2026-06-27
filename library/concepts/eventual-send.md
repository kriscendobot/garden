---
id: eventual-send
aliases: ["eventual send", "eventual-send", "E()", "E(target)", "E.when", "E.sendOnly", "tilde-dot", "~.", "infix bang", "<-", "eventually send a message", "HandledPromise", "delivered eventually not immediately", "async message passing"]
topics: [eventual-send, captp, capability-security]
---

# eventual-send

**Eventual send** is the discipline of messaging an object *eventually* rather
than *immediately*: instead of an immediate (synchronous) method call
`target.method(args)`, you write `E(target).method(args)`, which schedules the
message to be delivered on a later turn and returns a promise for the result.
The target may be local or remote, already-resolved or still a promise, in this
vat or across a CapTP session — eventual send is the *single uniform operation*
that works in all those cases, which is exactly what lets the same program span
a network without rewriting its call sites. In E-language lineage the operator
is the infix bang (`bob <- foo(carol)`, historically `~.`); in
`@endo/eventual-send` it is the `E()` proxy. The companion `E.when(p, …)` is the
safe replacement for `.then` (because `Promise.prototype.then` is invoked
implicitly by host operations in ways user code cannot override), and
`E.sendOnly(target).method(args)` sends without retaining a result promise.

Mechanically, `E()` is a Proxy whose traps reduce a method send into the
`HandledPromise` handler protocol (`get` / `applyFunction` / `applyMethod` and
their `SendOnly` variants). `HandledPromise` is the primitive that carries a
*handler* for a not-yet-resolved (or remote) reference, so a send against an
unresolved promise is queued against that promise's pending handler rather than
blocked on local resolution. From this single substrate two higher properties
*emerge* rather than being separately implemented: **promise pipelining**
(`E(E(x).foo()).bar()` collapses to one network round-trip) and the safe,
defensive integration with untrusted promises (the `isSafePromise` guard). The
theoretical motivation is latency, not bandwidth: in *Concurrency Among
Strangers*, an eventual-send returns a promise that is an *eventual reference*
to the result, messages may be eventually-sent to it before it resolves, and
the event-loop / vat model makes the whole thing data-race-free by construction.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [endo/docs-message-passing/eventual-send-async-messaging](../sections/endo--docs-message-passing--eventual-send-async-messaging.md) | **User-facing definition.** `E()` / `E.when` as the safe async-messaging family; why they are preferred over `.then`; local-or-remote, sync-or-async uniformity. |
| [endo/pkg-eventual-send-readme/handled-promise](../sections/endo--pkg-eventual-send-readme--handled-promise.md) | The `HandledPromise` primitive eventual send rides on; the handler that carries a pending or remote reference. |
| [endo/packages-eventual-send-src-E-js/E-proxy-handler-trio](../sections/endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets.md) | **The `E()` proxy implementation.** The three-handler proxy trio, the `this`-receiver check, the freezable-not-hardened proxy targets, and the `makeE` factory (`E` as a callable with extra methods). |
| [endo/packages-eventual-send-src-handled-promise-js/operation-reduction-and-sendonly](../sections/endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) | How `dispatchToHandler` reduces `applyMethod` into `get` + `applyFunction` and substitutes the `SendOnly` variants — the mechanism a minimum-viable handler implements. |
| [endo/packages-eventual-send-README/four-target-cartesian-product](../sections/endo--packages-eventual-send-README-md--four-target-cartesian-product-and-mark-miller-thesis-citation--mark-miller-s-thesis-cited-as-original-source.md) | The README's four-target cartesian product (function/object × call/send) and its citation of Mark Miller's thesis as the original source of the eventual-send model. |
| [papers/cas/vat-and-event-loop-model](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model--body.md) | **Theoretical model.** The vat / event-loop substrate that makes eventual send data-race-free: turns, the message queue, and why shared-state concurrency is rejected. |

## See also

- [[promise-pipelining]] — the most important property that *emerges* from eventual send; `E(E(x).foo()).bar()` over the wire is one round-trip. Eventual send is the operation; pipelining is what chaining it across a boundary buys.
- [[handler-protocol]] — the `HandledPromise` handler interface (`get` / `applyFunction` / `applyMethod` + `SendOnly`) and the `dispatchToHandler` reductions; the mechanism this concept's *send* rides on.
- [[granovetter-operator]] — `E(bob).foo(carol)` is the eventual-send form of the Granovetter step; eventual send is how introductions cross a network without changing the call shape.
- [[three-party-handoff]] — when an eventual send carries a reference imported from another session, the handoff protocol is what delivers that argument securely.
- [[vat-and-compartment]] — the unit eventual send crosses (and stays within); a send is delivered on a turn of the target's vat event loop.
- [[object-capability]] — eventual send is capability-safe: the only thing you can do with a reference is send it messages, and the only way it reaches a new holder is as a message argument.

## Common confusions

- **"`E(x).foo()` is just `Promise.resolve(x).then(o => o.foo())`."** No — `E` queues the message against `x`'s *handler* (which may route it to a remote vat and pipeline it) before any local resolution, and avoids `.then`'s implicit-invocation hazards. The `.then` form forces a local round-trip and exposes the untrusted-promise attack surface.
- **"Eventual send is only for remote objects."** It is *uniform*: `E()` works on a local object too (delivering on a later turn). The point is that the *same* call site works whether the target turns out to be local or remote, which is what lets code be written once and distributed later.
- **"`~.` / infix-bang is a different feature."** They are surface syntaxes for the same operation: the E-language infix bang (`<-` / `~.`) and `@endo/eventual-send`'s `E()` both denote eventual message send backed by `HandledPromise`.
- **"Eventual send improves throughput."** The motivation is *latency* (round-trip elimination via pipelining), not bandwidth. *Concurrency Among Strangers* is explicit that latency is the win.
