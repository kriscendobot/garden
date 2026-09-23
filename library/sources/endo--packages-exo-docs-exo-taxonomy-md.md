---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/exo/docs/exo-taxonomy.md
source_line_range: 1-53
ingested: 2026-06-16
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 368 chat-lane ingest paired to cycle 367 designs-lane
  @endo/exo README re-ingest. 53-line taxonomy doc that the
  cycle 367 README explicitly referenced via "Complete API
  reference and make/define/prepare patterns" pointer.
  Sixteenth AUTHORED conformant single-body section doc in
  post-refactor era. Fifty-eight consecutive non-garden
  sources after the pivot (310-368). §fifty-eight-cycles-
  with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  cross-product-taxonomy-with-named-omissions — the document
  organizes the entire @endo/exo + @agoric/vat-data exo-
  creation API surface as a CARTESIAN PRODUCT of TWO
  CROSS-CUTTING AXES: cardinality (make vs define vs
  define-kit) × storage (heap vs virtual vs durable). The
  cross product gives nine nominal cells (3×3); but reality
  has fewer because some combinations don't exist. The
  taxonomy doc EXPLICITLY NAMES the omissions: "there is no
  `makeVirtualExo`" (line 26); "there is no `makeDurableExo`"
  (line 29). The reason is given in both cases: high
  cardinality is the only purpose of virtual/durable, so
  single-instance variants aren't useful. §the-named-
  omission-with-reason-not-just-omission as tier-3 meta-
  pattern; the design discipline is to NAME the omissions
  AND state WHY they don't exist.

  §The-named-double-etymology-of-exo — lines 3-5 explain
  "exo" means "outside" (reachable-from-outside-vat =
  capability-style) AND alludes to "ExoSkeleton" (protective-
  outside-layer = defensive-validation). Two readings of the
  name, both load-bearing. §the-named-exo-and-endo-pair —
  line 7: "Exo also forms a nice pairing with Endo itself."
  Endo = inside, Exo = outside. The package family's name
  carries the inside/outside duality. §the-named-naming-as-
  conceptual-pairing as tier-3 meta-pattern.

  §The-named-prepare-as-fourth-verb-pattern — line 36
  introduces "prepare" as a different verb pattern entirely
  (alongside make/define/defineKit). prepareExo /
  prepareExoClass / prepareExoClassKit are durable variants
  that return existing-from-baggage if found, else create
  and register. The cycle 367 README named the three-verb
  trio (make + define + defineKit); cycle 368 reveals the
  FOURTH verb (prepare). §the-named-four-verb-pattern-of-
  exo-creation as tier-3 meta-pattern. The four verbs
  correspond to four lifecycle stances: fresh-singleton,
  fresh-factory, fresh-multi-facet-factory, and durable-
  restore-or-create.

  §The-named-state-code-separation-across-vat-upgrades —
  line 36: "What is passed in baggage is only the state of
  the durable objects. Only the `prepare*` calls associate
  that state with code, giving it behavior." State and
  behavior are SEPARATED across vat upgrades; baggage
  carries data; the prepare* call REUNITES them. §the-
  named-state-as-data-behavior-as-code-reunion-at-vat-
  start as tier-3 meta-pattern. The persistence design
  presumes that state survives but code is replaceable
  across upgrades — a vat-upgrade-aware persistence model.

  §The-named-first-crank-discipline — line 36: prepare*
  calls must happen on the FIRST CRANK of the vat
  incarnation, because the state in baggage must be
  associated with behavior BEFORE any messages arrive. §the-
  named-crank-as-vat-lifecycle-unit; §the-named-must-be-
  prepared-before-any-message-arrives as tier-3 meta-
  pattern.

  §The-named-class-cardinality-must-stay-low — line 32:
  "The total number of exo classes must be low cardinality,
  regardless of virtual/durable status. Being virtual or
  durable only enables class *instances* to be high
  cardinality." Class definitions live in heap; only
  instances scale via virtual/durable storage. §the-named-
  definitions-in-heap-instances-elsewhere as tier-3 meta-
  pattern.

  §The-named-bad-message-not-bad-input — line 5: "many
  kinds of bad messages" (not "bad input"). The vocabulary
  is OBJECT-CAPABILITY style: things are messages between
  objects, not inputs to functions. §the-named-message-
  vocabulary-as-OCAP-stance as tier-3 meta-pattern.

  §The-named-tool-as-defensive-aid-not-defensive-guarantee
  — line 5: the exo provides "an effective first defense
  against many threats" but "The programmer's remaining
  burden to make the exo objects fully defensive thus
  becomes easier." Partial defense by tool, full defense by
  programmer. §the-named-honest-acknowledgment-of-remaining-
  burden as tier-3 meta-pattern.

  §The-named-package-organization-as-layer — lines 47-53:
  "This `@endo/exo` package itself exports only the heap
  variants. The virtual and durable variants are contributed
  by higher layer packages that build upon it, such as
  `@agoric/vat-data`." §the-named-explicit-layering-of-
  package-boundary as tier-3 meta-pattern; the lower layer
  is generic; the higher layer is Agoric-specific. Pairs
  with cycle 331's §the-named-cross-org-pointer-to-Agoric
  but at a finer-grained level (which verbs go in which
  package).

  §The-named-pattern-based-input-validation — line 5:
  "type-like ([pattern](https://github.com/endojs/endo/
  tree/master/packages/patterns)-based) input validation".
  Pattern is the formal mechanism; interface-guard is the
  concrete use. §the-named-patterns-as-type-like-validation
  as tier-3 meta-pattern. Closes cycle 327's @endo/patterns
  README arc with the concrete naming.

  Closes seven citation arcs: cycle 367 (1, adjacent
  forward pair exo README re-ingest → exo taxonomy doc; the
  cycle 367 README pointed at this doc via "Complete API
  reference") + cycle 331 (1, cycle 331 named three-runtime-
  backing-tiers; cycle 368 reveals the FULL grid with named
  omissions, deepening cycle 331's tier-naming into a two-
  axis-with-omissions framing) + cycle 322 (10, exo-makers.js
  implements the trio; cycle 368 reveals the prepare verb
  pattern is in a different package) + cycle 327 (4,
  patterns README pattern-based validation named explicitly)
  + cycle 325 (4, pass-style README Far for remotable) +
  cycle 326 (41, pure-naming-as-discipline sibling) + cycle
  321 (6, eventual-send README; the exo abstraction is the
  validated-OCAP layer above eventual-send's promise
  pipelining). Pushes citation-arc-closures-in-pivot to
  TWO-HUNDRED-FORTY-FOUR (237 + 7 net new).
---

53-line taxonomy doc for @endo/exo's full creation grammar; pointed to by cycle 367 README. Chat-lane after cycle 367 designs-lane re-ingest. §the-named-cross-product-taxonomy-with-named-omissions (single most structurally interesting move — two-axis grid cardinality × storage; named omissions with reasons). §the-named-double-etymology-of-exo (outside + ExoSkeleton); §the-named-exo-and-endo-pair. §the-named-prepare-as-fourth-verb-pattern (extends cycle 367's trio to a quartet). §the-named-state-code-separation-across-vat-upgrades. §the-named-first-crank-discipline. §the-named-class-cardinality-must-stay-low. §the-named-bad-message-not-bad-input (OCAP vocabulary). §the-named-tool-as-defensive-aid-not-defensive-guarantee. §the-named-package-organization-as-layer (Endo/Agoric boundary at verb level). §the-named-pattern-based-input-validation. Seven citation arcs closed.
