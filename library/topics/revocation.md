# Topic: revocation

> Abstract: How to take back an authority that was granted — the mechanisms, guarantees, and design tensions of revoking a capability. Collects sections on the classic mechanisms (destroyable indirection objects / forwarders / caretakers, revocation lists, expiry) and their properties (immediacy, locality, whether a rescinded reference is distinguishable from a live one), from the cap-talk primary sources through the Endo/Agoric revocation-by-withdrawal and lazy-graph-revocation designs. Distinct from the broad `capability-security` topic: this topic is specifically about *un-granting*. For the deeper per-mechanism definitions see the concept pages [revocation-by-withdrawal](../concepts/revocation-by-withdrawal.md) and [lazy-graph-revocation](../concepts/lazy-graph-revocation.md).

## Sections

| Section | Topics | One-line abstract |
|---------|--------|-------------------|
| [cap-talk-1998--capability-ids-and-indirection-revocation](../sections/cap-talk-1998--capability-ids-and-indirection-revocation.md) | capability-security, revocation | EROS revocation primitive: a holder is given a capability to a *destroyable indirection object* rather than to the target, so destroying the indirection rescinds access without disturbing any other key. |
| [cap-talk-1998--rescinded-keys](../sections/cap-talk-1998--rescinded-keys.md) | revocation, capability-security | A rescinded key must return a message just like any other key — revocation must be *indistinguishable* from a live-but-unhelpful object (KeyKOS/EROS `DK(0)` overloading). |
| [cap-talk-1998--dead-object-sameness](../sections/cap-talk-1998--dead-object-sameness.md) | capability-theory, revocation | Invocation failure and reference equality after destruction are separate design choices. |
| [keykos-eros-practical-model-for-a-newcomer](../sections/cap-talk-2000-2001--keykos-eros-practical-model-for-a-newcomer.md) | capability-security, revocation | Capabilities are copied not delegated, so revocation is a deliberately interposed nullifiable indirection (Hardy's version-B / Rescind); antecedent of the caretaker. |
| [one-shot-capabilities-cannot-constrain-delegation](../sections/cap-talk-2000-2001--one-shot-capabilities-cannot-constrain-delegation.md) | capability-theory, capability-security, revocation | Use-once and null-use revocation do not constrain delegation of effective authority. |
| [paradigm-regained-permission-authority-and-abstraction](../sections/cap-talk-2002-2003--paradigm-regained-permission-authority-and-abstraction.md) | capability-theory, capability-security, revocation | Caretaker behavior makes revocation visible only when security-enforcing abstraction is part of the model. |
| [object-capability-patterns-historical-inventory](../sections/cap-talk-2004-2008--object-capability-patterns-historical-inventory.md) | cap-talk 2008-March | The revocable-forwarder lineage distinguishes forwarding from brokenness-reporting facets. |
| [filesystem-redirect-revocation-paths](../sections/cap-talk-2013-2016--filesystem-redirect-revocation-paths.md) | revocation, capability-security, distributed-objects | A revocable filesystem redirect must propagate its cut through every descendant facet derived through that path. |
| [google-docs-share-links-as-webkeys](../sections/cap-talk-2013-2016--google-docs-share-links-as-webkeys.md) | capability-security, revocation | Google Docs “anyone with the link” sharing demonstrates that users value bearer-style delegation even when a product did not set out to build an object-capability system. |
| [joining-references-across-membranes](../sections/cap-talk-2013-2016--joining-references-across-membranes.md) | revocation, distributed-objects, capability-security, cap-talk-open-questions | Two references may ultimately route to one endpoint yet carry different attenuation and revocation paths. |
| [reactive-expiry-versus-stateful-membranes](../sections/cap-talk-2013-2016--reactive-expiry-versus-stateful-membranes.md) | revocation, capability-security, cap-talk-open-questions | Barbour contrasts the classic explicit revoker or membrane — mutable forwarding state that must be installed with foresight and recursively wraps capabilities crossing the boundary — with a reactive model in which grants expire and are continuously replaced. |
| [substructural-reactive-capabilities](../sections/cap-talk-2013-2016--substructural-reactive-capabilities.md) | capability-theory, revocation, cap-talk-open-questions | Barbour's Awelon proposal combines reactive dataflow with affine, relevant, and linear types. |

## See also

- [[revocation-by-withdrawal]] — the Endo/Agoric fourth mechanism: removing a formula withdraws the recipe for constructing the capability (immediate, local, no distributed protocol).
- [[lazy-graph-revocation]] — reachability-based revocation over a share graph.
- [capability-security](capability-security.md) — the broad topic this specializes.
- [capability-theory](capability-theory.md) — the Irrevocability Myth (Capability Myths Demolished 2003) formalizes the forwarder/revoker construction.
