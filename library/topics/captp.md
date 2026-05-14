# Topic: captp

> Abstract: CapTP (Capability Transport Protocol) is the network protocol that lets eventual-send work across processes and networks. Errors are sent by copy, not by reference; the comm system on each side handles serialization, identity assignment, and (in plans) log-correlation identifiers so a remote error can be traced back to the sender's local logs.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--hiding-revealing-distributed-diagnostic](../sections/endo--docs-errors--hiding-revealing-distributed-diagnostic.md) | endo docs/errors.md | Plans for cross-machine error correlation via comm-side identifiers (not implemented). |
| [endo--docs-get-started--distributed-programming](../sections/endo--docs-get-started--distributed-programming.md) | endo docs/get-started.md | Tutorial introduction to the CapTP / OCapN transport family. |
| [endo--pkg-daemon-readme--overview](../sections/endo--pkg-daemon-readme--overview.md) | endo packages/daemon/README.md | The Endo daemon speaks CapTP over netstring envelopes. |
| [endo--pkg-marshal-readme--convert-val-slot](../sections/endo--pkg-marshal-readme--convert-val-slot.md) | endo packages/marshal/README.md | CapTP plugs in its own convertValToSlot/convertSlotToVal for capability identity across the wire. |
| [endo--pkg-eventual-send-readme--e-method-call](../sections/endo--pkg-eventual-send-readme--e-method-call.md) | endo packages/eventual-send/README.md | E(target).method as the primary cross-boundary call. |
| [endo--pkg-eventual-send-readme--e-get-and-sendonly](../sections/endo--pkg-eventual-send-readme--e-get-and-sendonly.md) | endo packages/eventual-send/README.md | E.get / E.sendOnly across the wire. |
| [endo--pkg-eventual-send-readme--promise-pipelining](../sections/endo--pkg-eventual-send-readme--promise-pipelining.md) | endo packages/eventual-send/README.md | Cross-boundary E() pipelining for round-trip elimination. |
| [endo--docs-message-passing--eventual-send-async-messaging](../sections/endo--docs-message-passing--eventual-send-async-messaging.md) | endo docs/message-passing.md | E() across CapTP boundaries: turn model, error propagation, pipelining. |

## See also

- [`eventual-send`](eventual-send.md): the application-level abstraction CapTP serves.
- [`marshal`](marshal.md): the pass-style serialization CapTP rides on.
- [`ocapn`](ocapn.md): the OCapN family of protocols extending the same model.
