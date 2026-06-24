---
role: designer-protocol
status: seed
authored: 2026-05-15
---

# Designer landing: protocol engineering

## When this landing is your starting point

You are designing changes to the OCapN family of wire formats, the
CapTP session model, the daemon's retention or persistence protocols,
the formula identifier scheme, or any adjacent code-level interface
between peers. If the question is *"how should two peers talk to each
other?"* or *"how should two halves of one peer agree on shared
state?"*, the material below is your corner of the library.

## Start here (read first, in this order)

1. **[formula-persistence-thesis](../concepts/formula-persistence-thesis.md)** — the thesis that grounds everything daemon-side: petname graph IS the persistence root; persist construction not content; destruction by cohort + reconstruction on demand. Read this before anything else if you're new to the cluster.
2. **[formula-graph](../concepts/formula-graph.md)** — the durable substrate. The storage-substrate subsection distinguishes the JSON formula store from the SQLite retention table — a distinction even ingested designs sometimes blur.
3. **[crdt-in-formula-persistence](../concepts/crdt-in-formula-persistence.md)** — where CRDT shapes show up *and* where a bidirectional CRDT was deliberately rejected. The canonical concept-page-with-contradiction; read it to internalize *asymmetry of authority* before you propose a synchronization protocol.
4. **[`captp`](../topics/captp.md)** topic page — the application-protocol layer; cross-process eventual-send.
5. **[`ocapn`](../topics/ocapn.md)** topic page — the protocol family the daemon embeds in.

## Topics in scope

- **[`ocapn`](../topics/ocapn.md)** — protocol family: CapTP + marshal + transports.
- **[`captp`](../topics/captp.md)** — capability transport protocol details.
- **[`daemon`](../topics/daemon.md)** — the daemon implementation that hosts the protocol.
- **[`persistence`](../topics/persistence.md)** — formula store, retention table, durable zones.
- **[`marshal`](../topics/marshal.md)** — pass-style serialization; smallcaps wire format.
- **[`pass-style`](../topics/pass-style.md)** — how values cross a serialization boundary.
- **[`streams`](../topics/streams.md)** — async-iterator framing substrate.

## Concepts in scope

- [formula-persistence-thesis](../concepts/formula-persistence-thesis.md) — the Endo Daemon's persistence strategy named by endojs/endo#3121 (draft).
- [formula-graph](../concepts/formula-graph.md) — acyclic, locally refcounted; JSON store + SQLite retention shadow.
- [cohort-destruction](../concepts/cohort-destruction.md) — partition response: destroy + reconstruct, not patch.
- [revocation-by-withdrawal](../concepts/revocation-by-withdrawal.md) — the fourth revocation mechanism distinct from caretakers / lists / expiry.
- [four-tables-coordinated-retention](../concepts/four-tables-coordinated-retention.md) — local + remote × inviter + accepter; local agency authoritative.
- [crdt-in-formula-persistence](../concepts/crdt-in-formula-persistence.md) — CRDT shape vs. bidirectional CRDT rejection.
- [retention-accumulator](../concepts/retention-accumulator.md) — microtask-coalesced retention deltas; daemon-wide async-flow convention.
- [local-node-sentinel](../concepts/local-node-sentinel.md) — `LOCAL_NODE = '0' × 64`; `0.0.0.0` of Ed25519.
- [dehydrate-hydrate](../concepts/dehydrate-hydrate.md) — stable formula keys vs ephemeral connection hints.
- [per-agent-keypair](../concepts/per-agent-keypair.md) — `@keypair`; each host/guest has its own Ed25519 keypair as a formula.
- [delegates-and-epithets](../concepts/delegates-and-epithets.md) — verifiable + deniable identity-relationship claims on Handles.
- [caretaker-pattern](../concepts/caretaker-pattern.md) — Handle / HandleControl split; identity / action facets.
- [pass-invariant-handle-equality](../concepts/pass-invariant-handle-equality.md) — connector identity guarantee.
- [syrup-record-positionality](../concepts/syrup-record-positionality.md) — JS field names in Syrup record codecs are positional bindings, not on-the-wire. *Critical correction to a common misreading.*
- [producer-typed-shape-consumer-rendering](../concepts/producer-typed-shape-consumer-rendering.md) — daemon-wide API design convention.

## Cluster overviews

### Daemon cluster (9 sources, ~45 sections)

The thesis (`endo--designs-dp--*`, on endojs/endo PR #3121 draft) sits at the centre; six implementation designs operate within it. Read in approximate dependency order:

- **`d256` daemon-256-bit-identifiers** — primitives: 256-bit IDs aligned with Ed25519; per-agent keypair formula.
- **`dani` daemon-agent-network-identity** — identity / network integration; per-agent NETS; network registration; origin of LOCAL_NODE.
- **`dlt` daemon-locator-terminology** — locator URL format; landed the LOCAL_NODE sentinel; dehydrate/hydrate boundary.
- **`dcpg` daemon-cross-peer-gc** — cross-peer retention protocol; retention-accumulator; replaced an abandoned bidirectional CRDT.
- **`dcp` daemon-capability-persona** — *Delegates and Epithets*: identity-relationship claims; caretaker pattern.
- **`drp` daemon-retention-paths** + **`rpn` retention-path-notation** — local retention-path graph + CLI rendering convention.
- **`daemon-content-store-gc`** — sweep-time refcount for content-addressed blobs.
- **`dp` daemon-persistence** (PR #3121, **draft**) — the thesis document.

### OCapN protocol family (sources via topic `ocapn`)

- **`ntsep` ocapn-network-transport-separation** — four-layer OCapN hierarchy; the network/transport split.
- **`ocapn-noise-network`** — OCapN-Noise as a proper network; Noise XX handshake replaces `op:start-session`.
- **`cbors`** — CBOR byte-string framing; sibling of @endo/netstring and @endo/syrups.
- **`tofb` trust-on-first-bind** — capability-policy pattern; state machine + decision modes.

### Implementation infrastructure (auxiliary)

- **`gbta` gateway-bearer-token-auth** — agent ID as bearer token via CapTP; per-IP rate limiting.

## Conventions and constraints

- **OCapN engagement (per `garden/CLAUDE.md`)**: refer to the upstream protocol obliquely (*"the upstream protocol"*, *"the OCapN-family protocol"*, *"the spec"*); no direct comments or cross-references to `ocapn/ocapn` in outward-facing artifacts; the bot fork `kriscendobot/ocapn` is the right citation when internal indexing is needed.
- **Wire-compat assumptions**: see [syrup-record-positionality](../concepts/syrup-record-positionality.md) before claiming any field rename is wire-breaking — it almost certainly isn't.
- **Producers own typed shape; consumers own rendering** — when you propose a new daemon API, the daemon returns typed values; CLI, chat, and JSON renderers each handle their own surface. See the [producer-typed-shape-consumer-rendering](../concepts/producer-typed-shape-consumer-rendering.md) concept page.
- **Shape, not content** — when an upstream design document is a meta-table of other items, the library captures the shape, not the rows; the same discipline applies when you're documenting a registry or a state-machine table in a new design.
- **Sentinel-with-rationale** — when you reach for a magic value (`LOCAL_NODE`, end-of-stream marker, etc.), record *why* it cannot collide with a valid value. See [sentinel-with-rationale](../concepts/sentinel-with-rationale.md).

## Adjacent landings

- *(pending)* `designer-security` — capability-security policy + threat modelling; the trust-on-first-bind cluster and the caretaker pattern overlap with this landing.
- *(pending)* `designer-exo-captp-api` — Exo class design and CapTP API surface; overlaps on the `captp` and `marshal` topics.
- *(pending)* `designer-language` — language and DSL design; overlaps on `hardened-javascript` and `compartments`.

## Notes

- This landing is the **proof of concept** for the role-landing axis. Shape is open; if anything reads wrong, adjust the structure and the README's *Landing shape* section together.
- The daemon cluster is denser than any other corner of the library (cycles 46–53 built it). A landing for `designer-frontend` or `designer-ux` will be much thinner until the chat cluster expands beyond cycle-54's first ingest.
