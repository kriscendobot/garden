---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/exo/README.md
source_line_range: 1-365
ingested: 2026-06-21
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 425 designs-lane ingest. 365-line README.md for
  @endo/exo — the defensive-remotable discipline that
  combines Far + InterfaceGuard. Closes the marshal →
  pass-style → exo infrastructure picture. Seventy-third
  AUTHORED conformant single-body section doc in post-
  refactor era. One-hundred-and-fifteen consecutive non-
  garden sources after the pivot (310-425). §one-hundred-
  and-fifteen-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  three-ocap-patterns-now-named — defineExoClassKit is
  explicitly described (lines 132-136) as "the key
  pattern for **least authority**: give each client only
  the facet they need." Combined with cycle 409's
  capability-attenuation (define-endow) and cycle 423's
  rights-amplification (Far + WeakMap), the cluster's
  vocabulary now has THREE explicit ocap design patterns:
  1. ATTENUATION via define-endow (cycle 409): agent
     proposes code; user endows with strong cap; result
     is less-powerful capability for safe sharing.
  2. RIGHTS AMPLIFICATION via Far + WeakMap (cycle 423):
     empty Far marker objects as keys grant access to
     underlying state otherwise hidden.
  3. FACETS via defineExoClassKit (cycle 425): one
     underlying state, multiple typed views (up /
     down / reader); each client receives only the
     facet they need.
  §the-named-attenuation-amplification-facets-as-three-
  ocap-patterns as tier-3 meta-pattern; the cluster's
  ocap vocabulary is now a coherent triple. Three
  mechanisms for shaping authority through capabilities.

  §the-named-exo-as-far-plus-interface-guard — lines 3-4,
  8-10: "An Exo is a remotable object (created with Far
  from @endo/pass-style) protected by an InterfaceGuard
  (from @endo/patterns). The guard automatically
  validates all method arguments and return values."
  §the-named-defensive-remotable-via-guard as tier-3
  meta-pattern; cluster's accumulated makeExo framings
  (cycles 401, 409, 415) now have a clean structural
  definition.

  §the-named-three-exo-creation-patterns — lines 14-17,
  57-202: makeExo (single instance, minimal state) /
  defineExoClass (multiple instances, per-instance
  state) / defineExoClassKit (multiple facets, shared
  state). Three patterns for different cardinality and
  state-sharing requirements. §the-named-three-patterns-
  per-cardinality-and-sharing as tier-3 meta-pattern.

  §the-named-three-state-strategies-per-exo-pattern —
  lines 236-295: makeExo uses closure variables (no
  this.state); defineExoClass has per-instance
  this.state; defineExoClassKit has shared this.state
  across facets. Each pattern has its own state
  strategy. §the-named-state-strategy-axis as tier-3
  meta-pattern.

  §the-named-this-state-self-and-facets — lines 128-131,
  199-202: For defineExoClass, this.self references
  the exo itself; for ClassKit, this.facets provides
  inter-facet communication. The this binding gives
  typed access to state, self, and facets. §the-named-
  context-binding-via-this as tier-3 meta-pattern.

  §the-named-GET_INTERFACE_GUARD-as-introspection-meta-
  method — lines 297-326. Every exo exposes a meta-
  method to retrieve its interface at runtime. Enables
  runtime interface discovery, dynamic client
  generation, documentation generation, protocol
  negotiation. §the-named-runtime-interface-discovery-
  via-meta-method as tier-3 meta-pattern. Connects to
  cycle 401's mention of __getMethodNames__() for CapTP
  introspection.

  §the-named-callWhen-vs-call-as-async-vs-sync-validation
  — lines 203-233. M.callWhen() for async methods:
  validates argument pattern, awaits if promise,
  validates resolved value, then calls method. Cluster's
  first encounter with M.callWhen DSL element. §the-
  named-await-and-validate-then-call as tier-3 meta-
  pattern.

  §the-named-three-exo-lifetimes-heap-virtual-durable —
  lines 328-346. Three lifetime variants:
  - HEAP: doesn't survive vat termination (this package)
  - VIRTUAL: backed by virtual object storage (pageable;
    @agoric/vat-data)
  - DURABLE: survives vat upgrades (@agoric/vat-data)
  §the-named-three-lifetimes-for-three-cardinality-needs
  as tier-3 meta-pattern; the cluster's understanding of
  exo extends with lifetime variants.

  §the-named-make-vs-define-vs-prepare-as-API-naming-
  convention — make for heap-direct-instance; define for
  heap-class-factory; prepare for durable-class-factory.
  The PREFIX indicates LIFETIME plus PATTERN. §the-named-
  prefix-encodes-lifetime-and-pattern as tier-3 meta-
  pattern.

  §the-named-boundary-validation-via-interface-guard —
  lines 54-55: "The InterfaceGuard validates arguments
  **before** the method executes, catching errors at
  the boundary rather than deep in your logic." Sibling
  to cycle 416's trust-boundary-as-error-handling-
  asymmetry. The boundary is where validation happens.
  §the-named-validate-at-boundary-not-in-logic as tier-
  3 meta-pattern.

  §the-named-CounterI-as-I-suffix-naming-convention —
  lines 39, 67, 93, 142. Interface objects use `I`
  suffix (CounterI, GreeterI, CounterKitI). §the-named-
  interface-name-I-suffix-convention as tier-3 meta-
  pattern.

  §the-named-make-direct-vs-define-returns-factory —
  line 75 vs 117-118. makeExo returns the exo
  directly; defineExoClass returns a make* factory
  function. §the-named-direct-instance-vs-factory-
  return as tier-3 meta-pattern. The API shape
  reflects single-vs-multi cardinality.

  §the-named-counter-kit-as-canonical-facet-example —
  lines 138-191. The up/down/reader example shows the
  canonical facet pattern: separate write capabilities
  (increment-only, decrement-only) and a read
  capability. §the-named-up-down-reader-facet-canonical
  as tier-3 meta-pattern; cycle 411's read-only-as-
  canonical-attenuation-example sibling — here the
  least-authority pattern via facets.

  §the-named-exo-depends-on-three-packages — lines
  348-359: exo's three foundations: pass-style (Far),
  patterns (M.interface), eventual-send (E()).
  Cluster's package-dependency map: marshal → pass-
  style; exo → pass-style + patterns + eventual-send;
  fae → lal + conversation-tree + chat; lal → providers
  (Anthropic SDK, Ollama, OpenAI). Multi-layered
  dependency graph. §the-named-exo-three-foundations
  as tier-3 meta-pattern.

  §the-named-interface-caching-staleness-across-vat-
  upgrades — lines 324-325: "The interface can change
  across vat upgrades, so clients caching it may
  become stale." Real-world distributed-system
  consideration. §the-named-interface-evolution-across-
  upgrades as tier-3 meta-pattern; cluster's drift
  framings extend to runtime interface evolution.

  §the-named-Mint-Purse-Payment-as-canonical-facet-
  example — line 196-197: "Example: public/private
  interfaces, admin/user facets, mint/purse/payment
  patterns." The mint/purse/payment pattern is a deep
  ocap idiom from Agoric. §the-named-mint-purse-
  payment-as-deep-ocap-pattern as tier-3 meta-pattern.

  §the-named-defining-method-takes-init-then-methods
  — lines 98-115. defineExoClass takes (tag,
  interface, init, methods). The init function
  produces the per-instance state; methods are
  defined as plain methods (with this binding). Same
  shape for ClassKit. §the-named-define-pattern-shape-
  tag-interface-init-methods as tier-3 meta-pattern.

  §the-named-optional-and-rest-args-in-M-call —
  lines 94, 107: `M.call().optional(M.number())`
  declares an optional parameter; `increment(delta =
  1)` provides a default. The M DSL has structured
  argument descriptors. §the-named-M-DSL-supports-
  optional-arguments as tier-3 meta-pattern.

  §the-named-no-built-in-state-for-makeExo — line
  240-253. makeExo "has no built-in state management.
  Use closure variables." The simplest pattern has the
  thinnest API. §the-named-make-pattern-uses-closure-
  for-state as tier-3 meta-pattern.

  §the-named-seventy-three-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 424 (1, adjacent
  forward; two-phase-validation in pass-style parallels
  exo's boundary-validation via InterfaceGuard) + cycle
  423 (5, rights-amplification framing now joined by
  facets — THREE ocap patterns named) + cycle 415 (5,
  faetool-as-exo framing now grounded in exo source;
  M.interface and the FaeTool definition now explicit) +
  cycle 411 (3, read-only attenuation-example sibling
  to facet pattern's least-authority articulation) +
  cycle 409 (5, attenuation joined by rights-
  amplification and facets — cluster's ocap vocabulary
  is now coherent triple) + cycle 416 (3, boundary-
  validation parallels trust-boundary-as-error-
  handling-asymmetry) + cycle 326 (75) + cycle 322
  (75) + cycle 364 (4, shapes growing with three-
  patterns-three-lifetimes-three-states) + cycle 387
  (5, branded-types via InterfaceGuard). Pushes
  citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-
  THIRTEEN (703 + 10 net new).
---

365-line README.md for @endo/exo — the defensive-remotable discipline (Far + InterfaceGuard). Closes the marshal → pass-style → exo infrastructure picture. Designs-lane after cycle 424 chat-lane pass-style/src/copyRecord.js. **Single most structurally interesting move**: §the-named-three-ocap-patterns-now-named — *defineExoClassKit is explicitly described as "the key pattern for least authority" with facets. Combined with cycle 409's capability-attenuation (define-endow) and cycle 423's rights-amplification (Far + WeakMap), the cluster's vocabulary now has THREE explicit ocap design patterns: attenuation + amplification + facets. Three mechanisms for shaping authority through capabilities.* §the-named-attenuation-amplification-facets-as-three-ocap-patterns as tier-3 meta-pattern. §the-named-exo-as-far-plus-interface-guard (cluster's accumulated makeExo framings now grounded); §the-named-defensive-remotable-via-guard. §the-named-three-exo-creation-patterns (makeExo + defineExoClass + defineExoClassKit per cardinality and state-sharing); §the-named-three-patterns-per-cardinality-and-sharing. §the-named-three-state-strategies-per-exo-pattern (closure / per-instance / shared); §the-named-state-strategy-axis. §the-named-this-state-self-and-facets; §the-named-context-binding-via-this. §the-named-GET_INTERFACE_GUARD-as-introspection-meta-method (runtime interface discovery; connects to cycle 401's __getMethodNames__); §the-named-runtime-interface-discovery-via-meta-method. §the-named-callWhen-vs-call-as-async-vs-sync-validation (await-and-validate-then-call); §the-named-await-and-validate-then-call. §the-named-three-exo-lifetimes-heap-virtual-durable (this package = heap; @agoric/vat-data = virtual + durable); §the-named-three-lifetimes-for-three-cardinality-needs. §the-named-make-vs-define-vs-prepare-as-API-naming-convention (prefix encodes lifetime + pattern); §the-named-prefix-encodes-lifetime-and-pattern. §the-named-boundary-validation-via-interface-guard (sibling to cycle 416's trust-boundary); §the-named-validate-at-boundary-not-in-logic. §the-named-CounterI-as-I-suffix-naming-convention. §the-named-make-direct-vs-define-returns-factory (API shape reflects cardinality); §the-named-direct-instance-vs-factory-return. §the-named-counter-kit-as-canonical-facet-example; §the-named-up-down-reader-facet-canonical (cycle 411's ReadOnly attenuation-example sibling). §the-named-exo-depends-on-three-packages (pass-style + patterns + eventual-send); §the-named-exo-three-foundations. §the-named-interface-caching-staleness-across-vat-upgrades; §the-named-interface-evolution-across-upgrades. §the-named-Mint-Purse-Payment-as-canonical-facet-example (deep Agoric ocap idiom); §the-named-mint-purse-payment-as-deep-ocap-pattern. §the-named-defining-method-takes-init-then-methods; §the-named-define-pattern-shape-tag-interface-init-methods. §the-named-optional-and-rest-args-in-M-call; §the-named-M-DSL-supports-optional-arguments. §the-named-no-built-in-state-for-makeExo; §the-named-make-pattern-uses-closure-for-state. §the-named-seventy-three-conformant-cycles-and-counting. **Cluster's ocap vocabulary is now a coherent triple of design patterns.** Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-THIRTEEN.
