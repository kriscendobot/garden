---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/marshal/README.md
source_line_range: 1-188
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 423 designs-lane ingest. 188-line README.md for
  @endo/marshal — the FIRST non-agent-package ingest in
  the cluster's broadening. Grounds the cluster's
  accumulated framings about CapTP, SmallCaps, Justin
  serialization, and pass-by-presence. Seventy-first
  AUTHORED conformant single-body section doc in post-
  refactor era. One-hundred-and-thirteen consecutive non-
  garden sources after the pivot (310-423). §one-hundred-
  and-thirteen-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  pass-by-presence-vs-pass-by-copy-as-marshal-
  classification — lines 91-110: marshal classifies all
  marshalable objects into TWO categories. Pass-by-
  presence: "all properties of an object (and of all
  objects in its inheritance hierarchy) must be methods,
  not data. Pass-by-presence objects are usually treated
  as having identity." Pass-by-copy: "all properties of
  an object must be string-named and enumerable and not
  accessors and not methods... it must inherit directly
  from Object.prototype. Pass-by-copy objects are not
  treated as having identity." Mixed objects (methods +
  data) are REJECTED. Empty objects default to pass-by-
  copy. This is the FUNDAMENTAL classification underlying
  every cluster framing about CapTP serialization. §the-
  named-two-category-marshal-classification-with-rejection
  as tier-3 meta-pattern; the marshal system's
  structural constraint that distinguishes capability-
  bearing from data-bearing objects.

  §the-named-mixed-objects-rejected — line 110: "Mixed
  objects having both methods and data properties are
  rejected." A categorical constraint. §the-named-no-
  mixed-objects-as-marshal-constraint as tier-3 meta-
  pattern.

  §the-named-empty-objects-as-pass-by-copy-default —
  lines 112-116: empty objects default to pass-by-copy,
  "although it is also possible to use Far (from @endo/
  far) for creating empty marker objects which can be
  compared for identity." §the-named-empty-object-
  default-but-Far-for-identity as tier-3 meta-pattern.

  §the-named-rights-amplification-via-Far-WeakMap-key
  — lines 114-116: "empty marker objects... are
  especially useful as WeakMap keys in the 'rights
  amplification' pattern." First reference to rights-
  amplification in the cluster. §the-named-rights-
  amplification-as-ocap-pattern as tier-3 meta-pattern;
  another ocap pattern beyond the cluster's existing
  attenuation framing (cycle 409).

  §the-named-CapData-as-body-plus-slots-shape — lines
  9-11: `{ body: string, slots: array }`. The protocol
  shape for capability-bearing serialization. Body is
  the JSON-like serialization; slots holds slot
  identifiers for pass-by-presence objects. §the-named-
  body-plus-slots-as-CapData-protocol as tier-3 meta-
  pattern; the cluster's first explicit encounter with
  CapData shape.

  §the-named-two-marshal-encodings-smallcaps-vs-
  original — lines 80-89: smallcaps encoding uses
  string prefixes (NaN → `'#"#NaN"'`); original
  encoding uses objects with `@qclass` property (NaN
  → `'{"@qclass":"NaN"}'`). Two protocols for the
  same conceptual representation. §the-named-smallcaps-
  string-prefixes-vs-original-qclass-objects as tier-3
  meta-pattern.

  §the-named-smallcaps-prefix-vocabulary — completing
  the cluster's SmallCaps picture from cycles 401, 413.
  FIVE single-character prefixes:
  - `+` for BigInt
  - `#` for undefined, NaN, Infinity (and stand-alone
    encodings)
  - `r` for Remotable
  - `?` for Promise
  - `!` for Error
  §the-named-smallcaps-five-prefix-discipline as tier-3
  meta-pattern.

  §the-named-smallcaps-body-prefix-as-format-
  discriminator — line 82: `'#"#NaN"'` — outer `#"..."`
  marks smallcaps body; inner is the encoded value.
  Body format is self-describing. §the-named-self-
  describing-body-format as tier-3 meta-pattern.

  §the-named-marshal-requires-frozen-input — lines
  64-67: "The entire object graph must be 'hardened'
  (recursively frozen)... toCapData will refuse to
  marshal any object graph that contains a non-frozen
  object." Hardening is a RUNTIME CONTRACT, not just
  a convention. §the-named-harden-as-marshal-precondition
  as tier-3 meta-pattern; cluster's accumulated harden
  framings now connect to a structural runtime
  enforcement.

  §the-named-convertValToSlot-and-convertSlotToVal-as-
  callback-pair — lines 13-15, 118-156: the two
  callbacks that bridge between pass-by-presence
  objects and slot identifiers. Different deployments
  use different slot conventions. §the-named-marshal-
  parameterized-by-callback-pair as tier-3 meta-
  pattern.

  §the-named-makePassableKit-as-direct-format —
  lines 44-62. Alternative API for direct serialization
  where "string comparison corresponds with arbitrary
  value comparison." Two variants: "legacyOrdered"
  (default for historical reasons) and "compactOrdered"
  (preferred for deep structure). NOT cross-comparable.
  §the-named-rank-order-via-string-compare as tier-3
  meta-pattern.

  §the-named-legacyOrdered-vs-compactOrdered-as-two-
  variants — two format options for makePassableKit.
  §the-named-historical-default-vs-preferred-current
  as tier-3 meta-pattern.

  §the-named-marshal-stringify-as-JSON-superset-and-
  subset — lines 158-188: marshal's stringify is BOTH
  more permissive AND more restrictive than JSON.
  More tolerant: encodes NaN, Infinity, bigints,
  undefined. Less tolerant: requires pass-by-copy
  frozen objects, no methods, only enumerable string-
  named data; throws on unencodable data (JSON
  skips). §the-named-bidirectional-asymmetry-vs-JSON
  as tier-3 meta-pattern; same operation, different
  constraints in each direction.

  §the-named-stringify-no-capabilities-CapData-with-
  capabilities — lines 178-183: stringify is only for
  pure data (no remotables/promises); CapData handles
  capabilities. TWO API levels in marshal. §the-named-
  two-API-levels-pure-data-vs-capabilities as tier-3
  meta-pattern.

  §the-named-at-qclass-as-original-discriminator —
  lines 73-74, 187-188. The original encoding uses
  objects with `@qclass` property; preserved for
  stringify even when not for smallcaps. §the-named-
  qclass-property-as-original-encoding-marker as tier-
  3 meta-pattern.

  §the-named-marshal-depends-on-pass-style — line 93:
  "marshal relies upon @endo/pass-style to distinguish
  between objects that are pass-by-presence and those
  that are pass-by-copy." Marshal is LAYERED on pass-
  style. §the-named-pass-style-as-marshal-substrate as
  tier-3 meta-pattern.

  §the-named-marshalling-definition — lines 3-5:
  "'Marshalling' refers to the conversion of structured
  data (a tree or graph of objects) into a string, and
  back again." Core definition. §the-named-marshalling-
  as-tree-to-string-conversion as tier-3 meta-pattern.

  §the-named-slot-identifiers-as-opaque-strings — lines
  130-137: slot identifiers are arbitrary opaque
  strings ("id1:a", "id1:b", etc.). The convention is
  caller-defined. §the-named-opaque-slot-identifier-
  string as tier-3 meta-pattern.

  §the-named-distributed-object-model-semantics-via-
  Passable-type — line 169: "the semantics of our
  distributed object model, as enforced by marshal —
  the Passable type exported by the marshal package."
  Marshal's classification IS the type for the
  distributed object model. §the-named-Passable-type-
  as-distributed-object-model-shape as tier-3 meta-
  pattern.

  §the-named-seventy-one-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 422 (1, adjacent
  forward; cluster broadens from agent packages to
  underlying capability infrastructure) + cycle 408
  (5, role-cardinality-reduction at provider boundary
  now contextualized within marshal's pass-by-
  presence-vs-copy classification) + cycle 409 (3,
  capability-attenuation framing extends to rights-
  amplification — TWO ocap design patterns now in
  the cluster vocabulary) + cycle 413 (3, SmallCaps
  encoding from messaging primer now grounded in
  marshal source) + cycle 401 (5, SmallCaps "+5"
  BigInt and "#undefined" framings now expanded with
  complete five-prefix vocabulary; @qclass discriminator
  named) + cycle 414 (3, harden discipline now
  understood as marshal runtime contract) + cycle
  326 (75) + cycle 322 (75) + cycle 387 (3, branded-
  types analogy: Passable type as marshal-enforced
  branding) + cycle 364 (4, shapes count growing with
  pass-style classification). Pushes citation-arc-
  closures-in-pivot to SIX-HUNDRED-AND-NINETY-THREE
  (683 + 10 net new).
---

188-line README.md for @endo/marshal — the cluster's FIRST non-agent-package ingest, grounding accumulated framings about CapTP, SmallCaps, Justin serialization, and pass-by-presence. Designs-lane after cycle 422 chat-lane fae/setup.js. **Single most structurally interesting move**: §the-named-pass-by-presence-vs-pass-by-copy-as-marshal-classification — *marshal classifies all marshalable objects into TWO categories. Pass-by-presence: all properties are methods, treated as identity. Pass-by-copy: only data properties, no identity. Mixed objects REJECTED. Empty objects default to pass-by-copy. This is the FUNDAMENTAL classification underlying every cluster framing about CapTP serialization.* §the-named-two-category-marshal-classification-with-rejection as tier-3 meta-pattern. §the-named-mixed-objects-rejected; §the-named-no-mixed-objects-as-marshal-constraint. §the-named-empty-objects-as-pass-by-copy-default; §the-named-empty-object-default-but-Far-for-identity. §the-named-rights-amplification-via-Far-WeakMap-key (FIRST reference to rights-amplification in cluster); §the-named-rights-amplification-as-ocap-pattern (joins attenuation from cycle 409 — TWO ocap design patterns now named). §the-named-CapData-as-body-plus-slots-shape; §the-named-body-plus-slots-as-CapData-protocol. §the-named-two-marshal-encodings-smallcaps-vs-original; §the-named-smallcaps-string-prefixes-vs-original-qclass-objects. §the-named-smallcaps-prefix-vocabulary (FIVE prefixes: `+` BigInt, `#` undefined/NaN/Infinity, `r` Remotable, `?` Promise, `!` Error); §the-named-smallcaps-five-prefix-discipline. §the-named-smallcaps-body-prefix-as-format-discriminator; §the-named-self-describing-body-format. §the-named-marshal-requires-frozen-input (hardening is a RUNTIME CONTRACT, not just convention); §the-named-harden-as-marshal-precondition. §the-named-convertValToSlot-and-convertSlotToVal-as-callback-pair; §the-named-marshal-parameterized-by-callback-pair. §the-named-makePassableKit-as-direct-format; §the-named-rank-order-via-string-compare. §the-named-legacyOrdered-vs-compactOrdered-as-two-variants; §the-named-historical-default-vs-preferred-current. §the-named-marshal-stringify-as-JSON-superset-and-subset (more permissive AND more restrictive than JSON); §the-named-bidirectional-asymmetry-vs-JSON. §the-named-stringify-no-capabilities-CapData-with-capabilities; §the-named-two-API-levels-pure-data-vs-capabilities. §the-named-at-qclass-as-original-discriminator; §the-named-qclass-property-as-original-encoding-marker. §the-named-marshal-depends-on-pass-style; §the-named-pass-style-as-marshal-substrate. §the-named-marshalling-definition; §the-named-marshalling-as-tree-to-string-conversion. §the-named-slot-identifiers-as-opaque-strings; §the-named-opaque-slot-identifier-string. §the-named-distributed-object-model-semantics-via-Passable-type; §the-named-Passable-type-as-distributed-object-model-shape. §the-named-seventy-one-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SIX-HUNDRED-AND-NINETY-THREE.
