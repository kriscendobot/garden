# Topic: captp

> Abstract: CapTP (Capability Transport Protocol) is the network protocol that lets eventual-send work across processes and networks. Errors are sent by copy, not by reference; the comm system on each side handles serialization, identity assignment, and (in plans) log-correlation identifiers so a remote error can be traced back to the sender's local logs.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--hiding-revealing-distributed-diagnostic](../sections/endo--docs-errors--hiding-revealing-distributed-diagnostic.md) | endo docs/errors.md | Plans for cross-machine error correlation via comm-side identifiers (not implemented). |
| [endo--docs-get-started--distributed-programming](../sections/endo--docs-get-started--distributed-programming.md) | endo docs/get-started.md | Tutorial introduction to the CapTP / OCapN transport family. |

## See also

- [`eventual-send`](eventual-send.md): the application-level abstraction CapTP serves.
- [`marshal`](marshal.md): the pass-style serialization CapTP rides on.
- [`ocapn`](ocapn.md): the OCapN family of protocols extending the same model.
