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
| [endo--pkg-captp-readme--overview](../sections/endo--pkg-captp-readme--overview.md) | endo packages/captp/README.md | The @endo/captp package: JS implementation of CapTP. |
| [endo--pkg-captp-readme--usage](../sections/endo--pkg-captp-readme--usage.md) | endo packages/captp/README.md | makeCapTP API: {dispatch, getBootstrap, abort}. |
| [endo--pkg-captp-readme--loopback](../sections/endo--pkg-captp-readme--loopback.md) | endo packages/captp/README.md | In-process CapTP loopback pair for testing and vat isolation. |
| [endo--pkg-captp-readme--trapcaps](../sections/endo--pkg-captp-readme--trapcaps.md) | endo packages/captp/README.md | TrapCaps: synchronous trapping mechanism for debugging. |
| [ocapn--implementation-guide--stage-0-foundation](../sections/ocapn--implementation-guide--stage-0-foundation.md) | upstream protocol Implementation Guide | Connection bootstrap, op:start-session, op:abort, crossed-hellos mitigation. |
| [ocapn--implementation-guide--stage-1-deliver-only](../sections/ocapn--implementation-guide--stage-1-deliver-only.md) | upstream protocol Implementation Guide | op:deliver, import/export descriptors, bootstrap object at position 0. |
| [ocapn--implementation-guide--stage-2-promises](../sections/ocapn--implementation-guide--stage-2-promises.md) | upstream protocol Implementation Guide | op:deliver with replies, op:listen, vow + resolver, desc:import-promise. |
| [ocapn--implementation-guide--stage-3-import-export-gc](../sections/ocapn--implementation-guide--stage-3-import-export-gc.md) | upstream protocol Implementation Guide | op:gc-exports + wire-delta for race-safe distributed reference counting. |
| [ocapn--implementation-guide--stage-4-promise-pipelining](../sections/ocapn--implementation-guide--stage-4-promise-pipelining.md) | upstream protocol Implementation Guide | desc:answer + answer-pos pipelining. |
| [ocapn--implementation-guide--stage-5-question-answer-gc](../sections/ocapn--implementation-guide--stage-5-question-answer-gc.md) | upstream protocol Implementation Guide | op:gc-answers. |
| [ocapn--implementation-guide--stage-6-handoffs](../sections/ocapn--implementation-guide--stage-6-handoffs.md) | upstream protocol Implementation Guide | desc:handoff-give + desc:handoff-receive certificates; replay protection. |
| [ocapn--implementation-guide--appendix-vats](../sections/ocapn--implementation-guide--appendix-vats.md) | upstream protocol Implementation Guide | Vat substrate beneath CapTP delivery. |

> Note: this topic page is incomplete (35 sections claim `captp` but ~12 are listed here as of 2026-05-14). Pending a dedicated topic-page refresh cycle.

## See also

- [`eventual-send`](eventual-send.md): the application-level abstraction CapTP serves.
- [`marshal`](marshal.md): the pass-style serialization CapTP rides on.
- [`ocapn`](ocapn.md): the OCapN family of protocols extending the same model.
