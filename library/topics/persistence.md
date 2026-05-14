# Topic: persistence

> Abstract: How values, state, and capabilities survive across vat incarnations, vat upgrades, daemon restarts, and process boundaries. Three persistence regimes (heap / virtual / durable) anchor the taxonomy. Cross-cuts with `exo` (durable Exo classes, the `prepare*` lifecycle) and `capability-security` (the discipline that makes durable replay safe). Distinct from `bundles` (which is module-graph packaging at start) and from `marshal` (which is the serialization layer used at boundaries).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [agoric-sdk--agents--async-flow-model-notes](../sections/agoric-sdk--agents--async-flow-model-notes.md) | agoric-sdk AGENTS.md | agoric-sdk's async-flow model runs each invocation as an activation with durable lifecycle states: `Running`, `Sleeping`, `Replaying`, `Failed`, `Done`. |
| [agoric-sdk--pkg-async-flow-docs-async-flow-states--overview](../sections/agoric-sdk--pkg-async-flow-docs-async-flow-states--overview.md) | agoric-sdk packages/async-flow/docs/async-flow-states.md | A prepared guest async function is internally an exoClass; each `wrapperFunc(.. |
| [agoric-sdk--pkg-async-flow-readme--loopholes-for-purely-diagnostic-information](../sections/agoric-sdk--pkg-async-flow-readme--loopholes-for-purely-diagnostic-information.md) | agoric-sdk packages/async-flow/README.md | Explicit exceptions to the closed-function rule. |
| [agoric-sdk--pkg-async-flow-readme--overview](../sections/agoric-sdk--pkg-async-flow-readme--overview.md) | agoric-sdk packages/async-flow/README.md | The core `asyncFlow(zone, name, asyncFn)` API. |
| [agoric-sdk--pkg-base-zone-readme--overview](../sections/agoric-sdk--pkg-base-zone-readme--overview.md) | agoric-sdk packages/base-zone/README.md | A Zone provides an API for allocating Exo objects and Stores under one of three persistence regimes — heap (ephemeral, lost on vat termination), virtual (pageable to disk, lost on termination), durable (pageable AND revivable after a vat upgrade). |
| [agoric-sdk--pkg-inter-protocol-readme--persistence](../sections/agoric-sdk--pkg-inter-protocol-readme--persistence.md) | agoric-sdk packages/inter-protocol/README.md | A one-line note. |
| [agoric-sdk--pkg-store-readme--overview](../sections/agoric-sdk--pkg-store-readme--overview.md) | agoric-sdk packages/store/README.md | A wrapper around JavaScript Map with two specific improvements: (1) explicit `init` (set-new-key) vs `set` (update-existing-key) distinction — the caller marks the intent and the Store enforces correct usage, removing the need for "check if key exists first" patterns; (2) functional API — `Store.get` can be passed to `myArray.map(Store.get)` etc., |
| [agoric-sdk--pkg-vat-data-readme--overview](../sections/agoric-sdk--pkg-vat-data-readme--overview.md) | agoric-sdk packages/vat-data/README.md | Defines key vocabulary. |
| [agoric-sdk--pkg-vat-data-readme--tips-synchronous-makers](../sections/agoric-sdk--pkg-vat-data-readme--tips-synchronous-makers.md) | agoric-sdk packages/vat-data/README.md | Durable-kind maker functions are **synchronous**. |
| [agoric-sdk--pkg-zoe-readme--upgrade](../sections/agoric-sdk--pkg-zoe-readme--upgrade.md) | agoric-sdk packages/zoe/README.md | A contract instance can be upgraded to a new source-code bundle via `E(instanceAdminFacet).upgradeContract(newBundleID)`. |
| [endo-but-for-bots--llm-designs-trust-on-first-bind--policy-storage-and-revocation](../sections/endo-but-for-bots--llm-designs-trust-on-first-bind--policy-storage-and-revocation.md) | endo-but-for-bots designs/trust-on-first-bind.md | **Policy storage**: the controller's `control` facet exposes the policy table. |
| [endo--pkg-exo-docs-exo-taxonomy--heap-virtual-durable](../sections/endo--pkg-exo-docs-exo-taxonomy--heap-virtual-durable.md) | endo packages/exo/docs/exo-taxonomy.md | The second axis. |
| [endo--pkg-exo-docs-exo-taxonomy--make-vs-prepare](../sections/endo--pkg-exo-docs-exo-taxonomy--make-vs-prepare.md) | endo packages/exo/docs/exo-taxonomy.md | The third axis (durable-variant only). |
| [endo--pkg-exo-readme--state-management](../sections/endo--pkg-exo-readme--state-management.md) | endo packages/exo/README.md | How state is provided and accessed across the three forms: makeExo has no state (this.state is empty); defineExoClass provides state from init() to each method via this.state; defineExoClassKit provides one state from init() shared across all facets in the cohort. |
| [endo--pkg-exo-readme--virtual-durable-exos](../sections/endo--pkg-exo-readme--virtual-durable-exos.md) | endo packages/exo/README.md | Exos can be virtual (state lives in a heap-managed store, not as a JS heap object) or durable (state survives across vat or daemon restarts). |
| [endo--pkg-ses-docs-preparing-for-stabilize--how-passable-objects-should-prepare](../sections/endo--pkg-ses-docs-preparing-for-stabilize--how-passable-objects-should-prepare.md) | endo packages/ses/docs/preparing-for-stabilize.md | Specific guidance for code that constructs passable objects (copyArrays, copyRecords, Far-built remotables): how the new integrity-trait will affect these and what to change ahead of time. |
| [endo--pkg-ses-docs-preparing-for-stabilize--how-proxy-code-should-prepare](../sections/endo--pkg-ses-docs-preparing-for-stabilize--how-proxy-code-should-prepare.md) | endo packages/ses/docs/preparing-for-stabilize.md | Specific guidance for code that wraps values in Proxy objects: which traps need to be aware of the new integrity-trait semantics, and what changes to make ahead of the language change. |
| [endo--pkg-ses-docs-preparing-for-stabilize--overview](../sections/endo--pkg-ses-docs-preparing-for-stabilize--overview.md) | endo packages/ses/docs/preparing-for-stabilize.md | Mark Miller's note on the upcoming non-trapping integrity trait. |

## See also

- [`exo`](exo.md): the Exo class API whose `prepare*` family realizes durable kinds.
- [`async-flow`](async-flow.md): the durable-replay async-function abstraction; a specialized persistence-bearing surface.
- [`capability-security`](capability-security.md): the discipline that makes durable replay sound (closed-function rule, ambient-authority confinement).
- [`hardened-javascript`](hardened-javascript.md): the substrate; `lockdown()` is the gate.
- [`daemon`](daemon.md): the host that orchestrates vat incarnations.
