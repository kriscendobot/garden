# Topic: daemon

> Abstract: The Endo daemon (capability bank): a per-user persistent host for hardened-JavaScript worker processes, reached over a Unix-domain-socket or named-pipe channel, communicating in CapTP framed over netstring envelopes. The user-agent bootstrap object provides facets for guest agents. The controller manages daemon lifecycle. Distinct from `captp` (which is the application protocol the daemon uses) and from `capability-security` (the underlying discipline).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--pkg-daemon-readme--overview](../sections/endo--pkg-daemon-readme--overview.md) | endo packages/daemon/README.md | Per-user persistent host for HardenedJS workers; CapTP-over-netstring; user-agent bootstrap. |
| [endo--pkg-exo-readme--virtual-durable-exos](../sections/endo--pkg-exo-readme--virtual-durable-exos.md) | endo packages/exo/README.md | Virtual and durable exos for daemon-persisted state across restarts. |

## See also

- [`captp`](captp.md): the application protocol the daemon speaks.
- [`capability-security`](capability-security.md): the discipline the daemon enforces.
- [`hardened-javascript`](hardened-javascript.md): the substrate the daemon's worker processes run on.
- [`ocapn`](ocapn.md): the broader transport family.
