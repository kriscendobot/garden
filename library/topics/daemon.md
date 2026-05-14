# Topic: daemon

> Abstract: The Endo daemon (capability bank): a per-user persistent host for hardened-JavaScript worker processes, reached over a Unix-domain-socket or named-pipe channel, communicating in CapTP framed over netstring envelopes. The user-agent bootstrap object provides facets for guest agents. The controller manages daemon lifecycle. Distinct from `captp` (which is the application protocol the daemon uses) and from `capability-security` (the underlying discipline).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions](../sections/endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions.md) | endo-but-for-bots designs/retention-path-notation.md | **Alternatives considered**: (1) formula id `{number}:{node}` — unambiguous + type-able but two 64-char hex strings; carries no "why is this alive" info; rejected as primary surface, retained as `--full-ids` secondary form. |
| [endo-but-for-bots--llm-designs-rpn--cli-string-notation](../sections/endo-but-for-bots--llm-designs-rpn--cli-string-notation.md) | endo-but-for-bots designs/retention-path-notation.md | **Goals**: unambiguous, type-able with no modifier keys, monospace-renderable, compact for pet-name-only paths, distinguishable per edge kind without color. |
| [endo-but-for-bots--llm-designs-rpn--host-method-api-and-best-path](../sections/endo-but-for-bots--llm-designs-rpn--host-method-api-and-best-path.md) | endo-but-for-bots designs/retention-path-notation.md | **One method added to `EndoHost`** (and the corresponding `Mail` interface). |
| [endo-but-for-bots--llm-designs-rpn--integration-and-phased-implementation](../sections/endo-but-for-bots--llm-designs-rpn--integration-and-phased-implementation.md) | endo-but-for-bots designs/retention-path-notation.md | **Fast collection**: the existing `listRetentionPaths(targetId)` in `graph.js` is BFS upstream through `groupInEdges`; cost linear in path count × average path length. |
| [endo-but-for-bots--llm-designs-rpn--problem-and-status-quo](../sections/endo-but-for-bots--llm-designs-rpn--problem-and-status-quo.md) | endo-but-for-bots designs/retention-path-notation.md | PR #151's `endo workers` surfaces `listWorkerTenants(workerName)` returning `{name, type}` per tenant, but **two gaps**: (1) no reverse lookup that tells the operator *where* in the host namespace the tenant lives — `name` is the first pet name discovered, but a tenant may be reachable under several names, under nested directories, or only via retention edges with no pet name at all; (2) no syntactic convention for unambiguously rendering a retention path on a CLI line. |
| [endo-but-for-bots--llm-designs-rpn--retention-path-model](../sections/endo-but-for-bots--llm-designs-rpn--retention-path-model.md) | endo-but-for-bots designs/retention-path-notation.md | Refines the segment shape from `daemon-retention-paths.md` so each component carries its own locator and so the union-find merge kind is explicit on segments representing merged groups. |
| [endo--pkg-daemon-readme--overview](../sections/endo--pkg-daemon-readme--overview.md) | endo packages/daemon/README.md | The Endo daemon is a persistent host for hardened-JavaScript worker processes, owned per-user and reached over a Unix domain socket or named pipe. |
| [endo--pkg-exo-docs-exo-taxonomy--heap-virtual-durable](../sections/endo--pkg-exo-docs-exo-taxonomy--heap-virtual-durable.md) | endo packages/exo/docs/exo-taxonomy.md | The second axis. |
| [endo--pkg-exo-docs-exo-taxonomy--make-vs-prepare](../sections/endo--pkg-exo-docs-exo-taxonomy--make-vs-prepare.md) | endo packages/exo/docs/exo-taxonomy.md | The third axis (durable-variant only). |
| [endo--pkg-exo-readme--virtual-durable-exos](../sections/endo--pkg-exo-readme--virtual-durable-exos.md) | endo packages/exo/README.md | Exos can be virtual (state lives in a heap-managed store, not as a JS heap object) or durable (state survives across vat or daemon restarts). |

## See also

- [`captp`](captp.md): the application protocol the daemon speaks.
- [`capability-security`](capability-security.md): the discipline the daemon enforces.
- [`hardened-javascript`](hardened-javascript.md): the substrate the daemon's worker processes run on.
- [`ocapn`](ocapn.md): the broader transport family.
