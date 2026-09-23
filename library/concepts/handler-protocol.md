---
id: handler-protocol
aliases: ["handler protocol", "HandledPromise handler", "dispatchToHandler", "minimal handler surface", "handler interface", "SendOnly substitution", "applyMethod reduction", "forwardingHandler"]
topics: [eventual-send, captp]
---

# handler-protocol

The interface a `HandledPromise` handler implements, and the reductions the `@endo/eventual-send` shim applies so a handler does not have to implement all of it. The protocol nominally exposes **six operations**: `get`, `applyFunction`, `applyMethod`, and a `SendOnly` variant of each (`getSendOnly`, `applyFunctionSendOnly`, `applyMethodSendOnly`). The shim's `dispatchToHandler` collapses this surface so that a **minimum viable handler** needs only two methods, `get` and `applyMethod`; the shim composes the other four. This is why the upstream `Handler` typedef marks every field optional, and it is the contract a CapTP or OCapN handler relies on.

The three reductions, all in `dispatchToHandler`:

- **SendOnly substitution.** A `*SendOnly` operation the handler does not implement falls through to the non-SendOnly version and discards the returned promise. A handler implements a SendOnly variant explicitly only when there is a genuine optimisation (a remote round-trip to skip); a local handler usually does not bother.
- **`applyMethod` as `get` + `applyFunction`.** When the handler omits `applyMethod`, the shim fetches the property (`get`) then applies the result (`applyFunction`). The intermediate `getResultP` is itself a `HandledPromise`, so the second sub-operation pipelines against a not-yet-resolved target. This is the implementation-side point at which [[promise-pipelining]] emerges from the shim, even when the handler does not know it is being pipelined.
- **`applyFunction` as `applyMethod` with an undefined method name.** When the handler implements only `applyMethod`, the shim downlevels `applyFunction` to `applyMethod(target, undefined, [args], returnedP)`, signalling "apply this presence directly as if it were a function."

The terminal failure case is a `throw assert.fail(...)`: if the handler implements none of the methods needed after every reduction has been tried, the shim throws a `TypeError` quoting the handler's method names. This is a programmer-error case; production handlers do not reach it. The default `forwardingHandler` near the end of the file is more aggressive, implementing all six against the local fallbacks in `local.js`, but that is a specialisation choice, not a protocol requirement.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly](../sections/endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) | The canonical reference: how `dispatchToHandler` reduces the six-operation API to a three-method minimum, the SendOnly substitution, and why `applyMethod` decomposition is where pipelining emerges. |

## See also

- [[promise-pipelining]] — the user-facing story (`E(E(x).foo()).bar()` over one round-trip) whose implementation anchor is the `applyMethod` reduction this protocol describes.
- [[caretaker-pattern]] — another decomposition of a capability call; both rely on the same `HandledPromise` substrate.

## Common confusions

- **"A handler must implement all six operations."** No: `get` and `applyMethod` suffice; the shim composes `getSendOnly`, `applyFunction`, `applyFunctionSendOnly`, and `applyMethodSendOnly` from those two. The SendOnly variants are an optimisation lever a remote handler reaches for when its wire protocol has a fire-and-forget primitive, not a baseline requirement.
