---
id: spatiotemporal-composability
aliases: ["spatiotemporal composability", "dynamic composability", "dynamic composition", "temporal composability", "spatial composability", "revertible effect", "revertible effects", "reactive coeffect", "reactive coeffects", "coeffect", "coeffect system", "effect system", "Cordis", "Koishi", "hot module replacement", "HMR", "component loader", "context paradigm", "effect context", "coeffect context", "accumulator", "twisted composition", "isolation realm", "coeffect interception"]
topics: [dynamic-composition, effect-and-coeffect-systems]
status: current
---

# spatiotemporal-composability

The programming paradigm of Shi-Zhang-Cui's *A Programming Paradigm for Spatiotemporal Composability* (the Cordis meta-framework): a formal foundation for *dynamic composition* — loading, unloading, and reconfiguring components at runtime — built by lifting classical effect and coeffect systems from compile-time annotations to runtime mechanisms. **Temporal composability** (revert a component's side effects completely on removal) is delivered by *revertible effects*: an effect is a forward context-transformation paired with an explicit inverse `Γ → Γ × (Γ → Γ)`, and a runtime *accumulator* composes those inverses so unloading a component just applies the accumulator. **Spatial composability** (declare and reactively resolve inter-component dependencies) is delivered by *reactive coeffects*: a component declares required keys as a specification, and every change to the shared dependency table is classified against it as *activating*, *deactivating*, or *neutral*. The two are unified into a single *context type* and combined into a *component* with a lifecycle calculus (Inactive/Reloading/Active/Unloading) whose metatheory carries the local guarantees to a whole system of interleaved components. Realized in TypeScript as Cordis (one `ctx.effect` primitive returning a `dispose` closure; a declarative loader with hot module replacement) and validated on Koishi's 4000+ community plugins.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers--shi-spatiotemporal-composability-2026--overview](../sections/papers--shi-spatiotemporal-composability-2026--overview.md) | The two dimensions, the plugin-system and self-evolving-agent-harness motivations, and the coarse-grained workaround. |
| [papers--shi-spatiotemporal-composability-2026--revertible-effects](../sections/papers--shi-spatiotemporal-composability-2026--revertible-effects.md) | Revertible effects, the accumulator, and independence — local temporal composability. |
| [papers--shi-spatiotemporal-composability-2026--reactive-coeffects](../sections/papers--shi-spatiotemporal-composability-2026--reactive-coeffects.md) | Reactive coeffects, satisfaction/notification, isolation, interception — local spatial composability. |
| [papers--shi-spatiotemporal-composability-2026--context-paradigm-and-calculus](../sections/papers--shi-spatiotemporal-composability-2026--context-paradigm-and-calculus.md) | The unified context type and the calculus of dynamic composition with system-wide metatheory. |
| [papers--shi-spatiotemporal-composability-2026--cordis-implementation-and-koishi](../sections/papers--shi-spatiotemporal-composability-2026--cordis-implementation-and-koishi.md) | Cordis and the Koishi case study. |
| [papers--shi-spatiotemporal-composability-2026--boundaries-security-and-codesign](../sections/papers--shi-spatiotemporal-composability-2026--boundaries-security-and-codesign.md) | System boundary, service multiplexing, capability-based access control, sandboxing, co-design. |

## See also

- [[object-capability]] — Shi et al. §6.3 independently frames dependency declaration (`inject`) as a capability request and the context proxy as a capability mediator; authority by possession of a reference, not ambient authority.
- [dynamic-composition](../topics/dynamic-composition.md) — the topic page for the runtime-composition domain this concept anchors.
- [effect-and-coeffect-systems](../topics/effect-and-coeffect-systems.md) — the theory the paradigm lifts to runtime.
- [agent-fleet-orchestration](../topics/agent-fleet-orchestration.md) — the garden's own dynamic composition of a worker fleet; the paper names self-evolving agent harnesses as its future-validation target.

## Common confusions

- Cordis's *revertible effects* track-and-undo a component's effects; SES/`hardened-javascript` *removes ambient authority* so effects cannot happen unbidden. Both concern controlling effects, but one reverts, the other prevents — they are complementary, not the same mechanism.
- The paper's "context" (`Γ`, a runtime-operable state carrying effects and coeffects) is unrelated to LLM "context" (`context-engineering`) despite the shared word.
