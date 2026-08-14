# Topic: effect-and-coeffect-systems

> Abstract: The dual program-analysis frameworks that reason about how a computation *modifies* its environment (effects: `Γ ⊢ t : T effect`, refining the result type — monadic, algebraic, graded) and how it *depends on* its environment (coeffects: `Γ coeffect ⊢ t : T`, enriching the context — comonadic, graded). Classically these are static, compile-time instruments over lexically fixed scopes. Seeded 2026-08-14 from Shi-Zhang-Cui's *Spatiotemporal Composability*, whose central move is to *lift* both to runtime mechanisms — *revertible effects* (each effect carries an explicit inverse the runtime tracks) and *reactive coeffects* (each context change is classified against a dependency specification) — turning static guarantees into dynamic ones for components that arrive and depart at runtime. Filed alongside [`dynamic-composition`](dynamic-composition.md) (the application) and distinct from [`hardened-javascript`](hardened-javascript.md) (SES taming is a different notion of controlling effects, by removing ambient authority rather than by tracking-and-reverting).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [papers--shi-spatiotemporal-composability-2026--overview](../sections/papers--shi-spatiotemporal-composability-2026--overview.md) | Shi et al. 2026 | Effects formalize environmental modification, coeffects environmental requirement; both are classically static, motivating the lift to runtime revertible/reactive mechanisms. |
| [papers--shi-spatiotemporal-composability-2026--revertible-effects](../sections/papers--shi-spatiotemporal-composability-2026--revertible-effects.md) | Shi et al. 2026 | Effect as `Γ → Γ × (Γ→Γ)`, the twisted-composition monoid, the accumulator, track/recover, and the independence condition for commuting inverses. |
| [papers--shi-spatiotemporal-composability-2026--reactive-coeffects](../sections/papers--shi-spatiotemporal-composability-2026--reactive-coeffects.md) | Shi et al. 2026 | Coeffect context as a typed dependency table; get/set (set *is* a revertible effect); satisfaction and activating/deactivating/neutral notification; isolation and interception. |
| [papers--shi-spatiotemporal-composability-2026--context-paradigm-and-calculus](../sections/papers--shi-spatiotemporal-composability-2026--context-paradigm-and-calculus.md) | Shi et al. 2026 | Unifying effect and coeffect contexts into one context type; observational equivalence on coeffects supplying effects with independence. |

## Concepts

- [[spatiotemporal-composability]] — the runtime lifting of effects and coeffects into a single composition paradigm.

## See also

- [`dynamic-composition`](dynamic-composition.md): the runtime capability the lifted effect/coeffect systems deliver.
- [`change-propagation`](change-propagation.md): reactive coeffects at component granularity — how a dependency change drives activation/deactivation.
- [`capability-theory`](capability-theory.md): a different formal lens on authority; coeffect declaration overlaps with capability request (Shi et al. §6.3).
