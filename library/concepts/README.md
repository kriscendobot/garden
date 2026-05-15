# Concepts

Per-concept lookup pages. An agent reaching the library with a *specific term* in mind (a code symbol, a domain phrase, a proper name) arrives here via [`keywords.md`](../keywords.md): a keyword resolves to a concept-id, and this directory holds one short page per concept.

Each page contains:

- A one-paragraph definition of the concept.
- A `Sections that touch this concept` table with the relevant section files and one-line summaries of what each one contributes.
- A `See also` list of adjacent concept-ids.

This index is a third axis next to [`sources/`](../sources/README.md) (by provenance) and [`topics/`](../topics/README.md) (by broad subject taxonomy). Use it when:

- You know the **exact term** but not which source or topic owns it.
- You want **all the angles** on one concept (a concept page is allowed to point at multiple sources and at sibling concepts, including ones that *abandon* the concept — see [[crdt-in-formula-persistence]] for the canonical worked example).
- You need to **disambiguate** — concept pages collect "this is not that" notes so the next reader's search succeeds where yours did.

## Seed inventory (bootstrap, 2026-05-14)

Bootstrapped from the daemon design cluster and the structural principles in `conventions.md`. Extended cycle 50 with `delegates-and-epithets`, `caretaker-pattern`, and `pass-invariant-handle-equality` from the `daemon-capability-persona` ingest:

- [caretaker-pattern](caretaker-pattern.md) — split one capability into action and control facets.
- [cohort-destruction](cohort-destruction.md) — partition response: destroy the dependent live-reference subgraph, rebuild from formulas on demand.
- [crdt-in-formula-persistence](crdt-in-formula-persistence.md) — where CRDT shape is used; where a bidirectional CRDT was rejected.
- [dehydrate-hydrate](dehydrate-hydrate.md) — stable formula keys vs. ephemeral connection hints.
- [delegates-and-epithets](delegates-and-epithets.md) — agent identity that carries verifiable + deniable claims about its relationship to a principal.
- [formula-graph](formula-graph.md) — the daemon's durable substrate; acyclic + locally refcounted.
- [formula-persistence-thesis](formula-persistence-thesis.md) — the design's core thesis (endojs/endo#3121 draft).
- [four-tables-coordinated-retention](four-tables-coordinated-retention.md) — cross-peer retention data model.
- [local-node-sentinel](local-node-sentinel.md) — `LOCAL_NODE = '0'.repeat(64)`; the `0.0.0.0`-of-Ed25519.
- [pass-invariant-handle-equality](pass-invariant-handle-equality.md) — connector guarantee: same backing identity → same formula identifier.
- [per-agent-keypair](per-agent-keypair.md) — `@keypair`, `KeypairFormula`, agent identity as a formula.
- [permits-buckets](permits-buckets.md) — SES's three-bucket framework for vetted-shim placement: `universal` / `initial` / `shared` global property names.
- [producer-typed-shape-consumer-rendering](producer-typed-shape-consumer-rendering.md) — daemon-wide convention: typed values from producers, rendering from consumers.
- [retention-accumulator](retention-accumulator.md) — microtask-coalesced retention-delta batching primitive.
- [revocation-by-withdrawal](revocation-by-withdrawal.md) — the fourth revocation mechanism.
- [sentinel-with-rationale](sentinel-with-rationale.md) — the pattern: deliberately-unreachable value + why-it-cannot-collide.
- [shape-not-content](shape-not-content.md) — capture upstream meta-table shape, not its rows.
- [space](space.md) — Familiar Chat's bookmark into the daemon's capability graph; `SpaceConfig` shape, home (Space 0) vs user spaces, Cmd+N keyboard mapping.
- [syrup-record-positionality](syrup-record-positionality.md) — Syrup record field names are positional bindings, not on-the-wire; renames are wire-compatible.
- [six-aspects-of-sharing](six-aspects-of-sharing.md) — Karp/Stiegler/Close 6/7 taxonomy.
- [throwaway-instance-prototype-walk](throwaway-instance-prototype-walk.md) — SES taming for return-value prototypes.
- [token-chip](token-chip.md) — Familiar Chat's visual representation of a pet-name reference: styled `@`-prefix chip backed by a formula identifier; clickable, removable, autocompleted.

This index grows as agents using the [`library-lookup`](../../../skills/library-lookup/SKILL.md) skill encounter terms that lead them down circuitous routes — see that skill's *Indexing on the fly* section.
