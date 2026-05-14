# Topic: ocapn

> Abstract: The OCapN (Object Capabilities Network) protocol family: a set of layered transports and wire formats for capability-bearing distributed objects. Includes CapTP at the application layer, marshal for serialization, netstring for framing, noise for encryption, and assorted codecs. Distinct from `captp` (which is the application-protocol topic specifically); ocapn groups the family while individual layers may warrant their own topics as the corpus grows.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-get-started--distributed-programming](../sections/endo--docs-get-started--distributed-programming.md) | endo docs/get-started.md | Tutorial introduction to OCapN family, eventual-send, daemon. |

## See also

- [`captp`](captp.md): the application-layer protocol in the OCapN family.
- [`marshal`](marshal.md): the serialization layer.
- [`eventual-send`](eventual-send.md): the application-level abstraction OCapN serves.
- [`capability-security`](capability-security.md): the underlying discipline.
