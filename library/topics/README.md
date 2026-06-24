# Topics

Concept-keyed taxonomy of the library's section files. An agent looking for material on a concept arrives here, scans the abstracts, and follows the matching topic page to its section table. Each topic page lists the sections currently filed under it with a one-line abstract per row.

The taxonomy below is the **seed** from the pilot ingestion (2026-05-13). It will grow and refactor as the corpus expands. The `conventions.md` document on `journal/library/` describes when to add a new topic, when to split, and when to merge.

## Index

| Topic | Abstract | Sections |
|-------|----------|----------|
| [agent-conventions](agent-conventions.md) | Repository-specific instructions written for AI agents working in a project; agent-security threat-class definitions; business-agent + reputation-system foundations. | 56 |
| [chat-ui](chat-ui.md) | Familiar Chat — the web-based keyboard-first UI for the Endo daemon; UI invariants, principles, and component designs. | 58 |
| [repository-governance](repository-governance.md) | Contribution rules, security policy, commit conventions, repository structure. | 49 |
| [typescript-conventions](typescript-conventions.md) | TypeScript rules in a `.js`-runtime + `.ts`-consumer repository. | 12 |
| [exo](exo.md) | The Exo class API: `makeExo`, `defineExoClass`, `defineExoClassKit`. | 40 |
| [testing](testing.md) | How to run and write tests in endo. | 20 |
| [security-disclosure](security-disclosure.md) | Vulnerability reporting channels and timelines. | 9 |
| [errors](errors.md) | SES's tamed `Error` + `assert` + causal `console` system. | 33 |
| [hardened-javascript](hardened-javascript.md) | SES substrate: frozen intrinsics, lockdown, taming. | 107 |
| [capability-security](capability-security.md) | Object-capability discipline as practiced in Endo / Agoric; agent-runtime applications of capability discipline. | 164 |
| [capability-theory](capability-theory.md) | Theoretical foundations of object-capability security: four models, seven properties, POLA, confused deputies, eventual-send / vat / promise-pipelining / partial-failure / when-catch lineage, structure-of-authority + multiplicative-attack-surface arguments; sleeper-channel taxonomy + provenance-gate soundness theorem; permission-vs-authority + abstraction-as-protection + arena framework; Granovetter Operator + capability-based money + subjective aggregation + rights taxonomy + smart contracts; agoric-systems vision + competence-vs-performance modularity + marketplace-of-mind; **`obeys` + `MayAccess` + `MayAffect` as hypothetical trust + risk predicates, `Focal` + `Chainmail` formal model, Hoare four-tuple logic with code-agnostic inference rules**; **access-matrix-terminology formalization of the Confused Deputy attack (Tyler Close ~2009) — CSRF + clickjacking + click-fraud as worked Web examples, web-key fix, no-infrastructure-change migration claim**; **the runtime sending-event-causes-receiving-events causal-event-DAG (Mark S. Miller, `track-turns.js`) — the operational counterpart to *only-connectivity-begets-connectivity***; **SES_light formal foundation with Datalog points-to + soundness theorem + ENCAP tool finding Yahoo! ADSafe vulnerability + verifying conservation-of-currency Mint (Taly-Erlingsson-Mitchell-Miller-Nagra 2011)**; **OCPL formal foundation with Iris concurrent separation logic + low-integrity values + RobustSafety meta-theorem + Coq-mechanized verification of dynamic sealing + caretaker + membrane patterns (Swasey-Garg-Dreyer OOPSLA 2017)**. Distinct from `capability-security` (which catalogs Endo/Agoric *practice*); this topic catalogs the *papers* arguing for and naming the discipline. | 39 |
| [compartments](compartments.md) | SES compartments: isolated guest-code subtrees in a realm. | 26 |
| [eventual-send](eventual-send.md) | `E()` and `E.when` for messaging local or remote objects. | 65 |
| [captp](captp.md) | Capability Transport Protocol: cross-process eventual-send. | 48 |
| [ocapn](ocapn.md) | The OCapN protocol family: CapTP + marshal + transports. | 75 |
| [marshal](marshal.md) | Pass-style serialization layer; smallcaps wire format; encodePassable rank-order-preserving format; rankOrder in-memory comparator. | 69 |
| [streams](streams.md) | Async-iterator-based stream abstraction; transport substrate. | 13 |
| [pass-style](pass-style.md) | Marshal's classification system for how values cross a serialization boundary. | 55 |
| [daemon](daemon.md) | The Endo daemon: per-user persistent host for HardenedJS workers. | 55 |
| [persistence](persistence.md) | How values, state, and capabilities survive vat incarnations, upgrades, daemon restarts; the heap/virtual/durable zones. | 34 |
| [async-flow](async-flow.md) | The `@agoric/async-flow` durable-replay async-function infrastructure; closed-function discipline. | 7 |
| [patterns](patterns.md) | The @endo/patterns shape-matching language; method guards. | 52 |
| [getting-started](getting-started.md) | The on-ramp into Endo: install, first encounters, confinement walk-through. | 18 |
| [tooling](tooling.md) | Endo's developer-facing tooling and assorted single-purpose packages. | 64 |
| [bundles](bundles.md) | Module bundling, Compartment module loading, bundle-source / compartment-mapper family. | 29 |
| [spec-to-implementation](spec-to-implementation.md) | Cross-cutting concordance: OCapN spec sections ↔ Endo realizations. | (meta) |
| [cloud-marketplace](cloud-marketplace.md) | AWS Marketplace and equivalent cloud vendor distribution channels: seller requirements, AMI and container product technical constraints, pricing models, and listing lifecycle. | 3 |
| [tls-provisioning](tls-provisioning.md) | TLS certificate acquisition and first-boot provisioning patterns for self-custodial nodes: ACME challenge types, vendor-delegated subdomains, TOFU self-signed, renewal automation. | 2 |
| [signed-updates](signed-updates.md) | Cryptographically signed software update channels for always-online nodes: TUF role hierarchy, online/offline key discipline, rollback-attack defense, deployment pattern. | 1 |
| [node-packaging](node-packaging.md) | OS packaging and marketplace distribution of the Endo gateway: aggregated external constraints on Phase 11 covering marketplace requirements, TLS provisioning, and signed update channels. | 6 |
| [data-structures](data-structures.md) | General-purpose data structures and the interfaces over them: kriskowal/collections (idiomatic uniform JS collection interfaces) and cask's columnar parallel-array pattern (deepened from cask's parallel-arrays design doc, with the on-disk allocator and Robin-Hood hash table from caskdbstore). Cross-cutting, independent of the capability-security corpus. | 33 |
| [reactive-bindings](reactive-bindings.md) | Synchronous, incremental binding of object properties and collection contents (kriskowal/frb): one- and two-way bindings, incremental query chains, the small binding query language, and the grammar/compiler source behind it. | 31 |
| [change-propagation](change-propagation.md) | How a change in one place is incrementally and reliably reflected elsewhere, between data structures and between agents: the cross-cutting *theory* (gtor's reactivity taxonomy) that FRB observers, @endo/pubsub topics (#513), and propagators instantiate. The changes-vs-latest duality and ordered-collection-windows-as-derived-topics threads. Distinct from `reactive-bindings` (FRB specifically) and `streams` (the @endo/stream transport). | 5 |
| [content-addressed-storage](content-addressed-storage.md) | Storing data as content-addressed Merkle trees of fixed-size 1KB blocks (kriskowal/cask): block format, blobs/dirs/arrays/maps as block trees, content-agnostic GC (the pinned/deadline retention regimes, snapshot+quarantine concurrent GC, store-wrapper mark/sweep, and caskdbstore's WAL-quarantine GC), cells, reducer-style persistent structures, schema hashes. | 30 |
| [networking](networking.md) | Transport-layer design (kriskowal/cask): UDP block transfer reacting against TCP's limits, the layered casknet protocol stack, Noise-IK/PSK encryption (with the cryptography.md design proposal behind it), 256-bit priority load shedding, casktel telemetry. | 18 |

## Seed-but-not-yet-populated topics

The taxonomy in `conventions.md` lists additional topics expected to fill in as more of the endo corpus is ingested:

(no remaining seed-but-empty topics — streams is now populated by the stream + stream-node ingestion)

These will appear when the next ingestion batches (the flagship package READMEs queued in the inbox) create sections that file under them.
