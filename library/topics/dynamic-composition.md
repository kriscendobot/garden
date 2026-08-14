# Topic: dynamic-composition

> Abstract: Loading, unloading, and reconfiguring software components at *runtime* — as opposed to static composition (function calls, imports, inheritance) resolved at compile time — with two guarantees the static setting gives for free: complete reversal of a removed component's side effects, and structured, reactive management of inter-component dependencies. Seeded 2026-08-14 from Shi-Zhang-Cui's *A Programming Paradigm for Spatiotemporal Composability* (the Cordis meta-framework), which formalizes these as *temporal* and *spatial* composability and realizes them by lifting effect and coeffect systems to runtime mechanisms. The paper's own motivating instances are plugin systems and self-evolving agent harnesses; the corpus files the theoretical machinery under [`effect-and-coeffect-systems`](effect-and-coeffect-systems.md) and the loader/HMR mechanics under [`module-loader`](module-loader.md).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [papers--shi-spatiotemporal-composability-2026--overview](../sections/papers--shi-spatiotemporal-composability-2026--overview.md) | Shi et al. 2026 | The two orthogonal dimensions of dynamic composition (temporal + spatial), the plugin-system and self-evolving-agent-harness motivating examples, and the coarse-grained process/container workaround. |
| [papers--shi-spatiotemporal-composability-2026--revertible-effects](../sections/papers--shi-spatiotemporal-composability-2026--revertible-effects.md) | Shi et al. 2026 | Effects as forward-transformation-plus-inverse pairs; the accumulator that recovers the pre-composition state; independence for out-of-order reversal — local temporal composability. |
| [papers--shi-spatiotemporal-composability-2026--context-paradigm-and-calculus](../sections/papers--shi-spatiotemporal-composability-2026--context-paradigm-and-calculus.md) | Shi et al. 2026 | The unified context type, the component/fiber lifecycle (Inactive/Reloading/Active/Unloading), the withdrawal guard, and the metatheory carrying composability system-wide. |
| [papers--shi-spatiotemporal-composability-2026--cordis-implementation-and-koishi](../sections/papers--shi-spatiotemporal-composability-2026--cordis-implementation-and-koishi.md) | Shi et al. 2026 | Cordis (the TypeScript meta-framework): one `ctx.effect` mutation primitive returning a `dispose` closure, the declarative loader with HMR, and the Koishi 4000-plugin case study. |
| [papers--shi-spatiotemporal-composability-2026--boundaries-security-and-codesign](../sections/papers--shi-spatiotemporal-composability-2026--boundaries-security-and-codesign.md) | Shi et al. 2026 | System boundary (inside/outside, acquisition/emission, compensation), service multiplexing (broker, rolling updates, cross-process), capability-based access control, sandboxing, and language/OS co-design. |

## Concepts

- [[spatiotemporal-composability]] — the paradigm as a whole: revertible effects + reactive coeffects unified into one context type.

## See also

- [`effect-and-coeffect-systems`](effect-and-coeffect-systems.md): the theoretical machinery (effects/coeffects, revertible/reactive liftings) this composition is built from.
- [`module-loader`](module-loader.md): the declarative-configuration and hot-module-replacement layer that drives the composition.
- [`change-propagation`](change-propagation.md): the reactive notification (activating/deactivating/neutral) that re-evaluates dependents when the context changes.
- [`capability-security`](capability-security.md): dependency declaration as structurally capability-based access control (Shi et al. §6.3).
- [`sandbox-platforms`](sandbox-platforms.md): sandboxing untrusted components behind an attenuated bridge.
- [`agent-fleet-orchestration`](agent-fleet-orchestration.md): the garden's own runtime composition of a worker fleet — the self-evolving-harness setting the paper names as its future-validation target.
