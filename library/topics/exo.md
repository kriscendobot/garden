# Topic: exo

> Abstract: Exo (Exposed Object) is endo's class API for defining remotable objects (Far-like) with declarative method guards (patterns) and per-instance state. Three forms: `makeExo` (no state, single facet), `defineExoClass` (state via `init()`, single facet), `defineExoClassKit` (state via `init()`, multiple facets sharing the cohort).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--agents--exo-this-context](../sections/endo--agents--exo-this-context.md) | endo AGENTS.md | `this.self` vs `this.facets`; never mix `self` and `facets` in one `ThisType<>`. |
| [endo--pkg-pass-style-readme--far](../sections/endo--pkg-pass-style-readme--far.md) | endo packages/pass-style/README.md | Far(): a lighter-weight way to construct a remotable than the full Exo apparatus. |
| [endo--pkg-exo-readme--overview](../sections/endo--pkg-exo-readme--overview.md) | endo packages/exo/README.md | The exo package frame: three forms (makeExo, defineExoClass, defineExoClassKit). |
| [endo--pkg-exo-readme--why-exo](../sections/endo--pkg-exo-readme--why-exo.md) | endo packages/exo/README.md | Why exo over Far+closures: declarative guards, explicit state, multi-facet attenuators. |
| [endo--pkg-exo-readme--makeexo-single-instance](../sections/endo--pkg-exo-readme--makeexo-single-instance.md) | endo packages/exo/README.md | makeExo: single instance, no per-instance state. |
| [endo--pkg-exo-readme--defineexoclass-multiple-instances](../sections/endo--pkg-exo-readme--defineexoclass-multiple-instances.md) | endo packages/exo/README.md | defineExoClass: maker for many instances with state from init(). |
| [endo--pkg-exo-readme--defineexoclasskit-multiple-facets](../sections/endo--pkg-exo-readme--defineexoclasskit-multiple-facets.md) | endo packages/exo/README.md | defineExoClassKit: cohort of facets sharing one state; the attenuator pattern. |
| [endo--pkg-exo-readme--async-methods-callwhen](../sections/endo--pkg-exo-readme--async-methods-callwhen.md) | endo packages/exo/README.md | M.callWhen() converts async method declarations to declare arg shapes on resolved values. |
| [endo--pkg-exo-readme--state-management](../sections/endo--pkg-exo-readme--state-management.md) | endo packages/exo/README.md | State semantics across the three forms. |
| [endo--pkg-exo-readme--introspection-interface-guard](../sections/endo--pkg-exo-readme--introspection-interface-guard.md) | endo packages/exo/README.md | GET_INTERFACE_GUARD introspection of the methodsGuard pattern. |
| [endo--pkg-exo-readme--virtual-durable-exos](../sections/endo--pkg-exo-readme--virtual-durable-exos.md) | endo packages/exo/README.md | Virtual / durable exos: state in heap-managed or restart-surviving store. |
| [endo--pkg-exo-readme--integration-with-endo](../sections/endo--pkg-exo-readme--integration-with-endo.md) | endo packages/exo/README.md | How exo relates to patterns, pass-style, marshal, eventual-send, captp. |
| [endo--pkg-exo-readme--see-also](../sections/endo--pkg-exo-readme--see-also.md) | endo packages/exo/README.md | Pointers to packages/exo/docs/: exo-taxonomy and types. |
| [endo--pkg-patterns-readme--interface-guards](../sections/endo--pkg-patterns-readme--interface-guards.md) | endo packages/patterns/README.md | Interface guards as used by Exo: methodsGuard structure and integration. |
| [endo--pkg-eventual-send-readme--integration-with-exo](../sections/endo--pkg-eventual-send-readme--integration-with-exo.md) | endo packages/eventual-send/README.md | E() composing with Exo: standard call form, M.callWhen for arg shapes on resolved values. |
| [endo--docs-message-passing--defensive-receive-protected-objects](../sections/endo--docs-message-passing--defensive-receive-protected-objects.md) | endo docs/message-passing.md | Building defensive receivers with Exo + multi-facet kits. |
| [endo--docs-message-passing--digital-purse-example](../sections/endo--docs-message-passing--digital-purse-example.md) | endo docs/message-passing.md | Digital purse: an Exo class with mint/holder multi-facet attenuation. |
| [endo--docs-message-passing--design-patterns-and-best-practices](../sections/endo--docs-message-passing--design-patterns-and-best-practices.md) | endo docs/message-passing.md | When to use Far() vs full Exo; multi-facet patterns. |

## See also

- [`patterns`](patterns.md): the method-guard pattern language used in Exo declarations.
- [`marshal`](marshal.md): the pass-style system Exo's remotables flow through.
- [`capability-security`](capability-security.md): why exo's encapsulation matters.
