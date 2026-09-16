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

## See also

- [[revocation-by-withdrawal]] — the Endo/Agoric fourth mechanism: removing a formula withdraws the recipe for constructing the capability (immediate, local, no distributed protocol).
- [[lazy-graph-revocation]] — reachability-based revocation over a share graph.
- [capability-security](capability-security.md) — the broad topic this specializes.
- [capability-theory](capability-theory.md) — the Irrevocability Myth (Capability Myths Demolished 2003) formalizes the forwarder/revoker construction.
