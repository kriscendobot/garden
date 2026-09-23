---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/exo/src/get-interface.js
source_line_range: 1-28
ingested: 2026-06-21
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 426 chat-lane ingest. 28-line get-interface.js
  from @endo/exo/src — the definition of the
  GET_INTERFACE_GUARD meta-method symbol. Companion to
  cycle 425's exo README. Seventy-fourth AUTHORED
  conformant single-body section doc in post-refactor
  era. One-hundred-and-sixteen consecutive non-garden
  sources after the pivot (310-426). §one-hundred-and-
  sixteen-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  two-meta-methods-getInterfaceGuard-and-getMethodNames-
  as-sibling-pair — line 11's comment: "Intended to be
  similar to `GET_METHOD_NAMES` from `@endo/pass-style`."
  Cycle 401's LAL-ARCHITECTURE.md mentioned `__
  getMethodNames__()` for CapTP introspection. Cycle 425's
  exo README named GET_INTERFACE_GUARD but did not name
  GET_METHOD_NAMES. Cycle 426 surfaces the SIBLING PAIR:
  TWO meta-methods named in the cluster:
  - GET_INTERFACE_GUARD: '__getInterfaceGuard__' (exo,
    returns InterfaceGuard with MethodGuards)
  - GET_METHOD_NAMES: from pass-style, returns method
    names array (per cycle 401's __getMethodNames__()
    framing)
  §the-named-introspection-meta-method-sibling-pair as
  tier-3 meta-pattern; the cluster's introspection
  vocabulary is now a pair (names vs guards).

  §the-named-GET_INTERFACE_GUARD-as-double-underscore-
  string-not-symbol — line 18: `export const
  GET_INTERFACE_GUARD = '__getInterfaceGuard__'`. The
  runtime symbol name is a STRING (not a Symbol). Uses
  double-underscore-prefixed name — a convention for
  meta-methods. Strings work across SES realms; Symbols
  require registry Symbols. §the-named-portable-string-
  symbol-for-cross-realm as tier-3 meta-pattern.

  §the-named-staleness-warning-co-located-with-constant
  — lines 15-16: "Beware that an exo's interface can
  change across an upgrade, so remotes that cache it
  can become stale." Cycle 425's exo README contained
  this warning; cycle 426 finds it RESTATED at the
  source level. §the-named-warning-restated-at-symbol-
  definition-site as tier-3 meta-pattern; the warning
  about caching pitfalls is placed at the definition
  site, not just in the README.

  §the-named-PR-discussion-link-as-design-rationale —
  line 13: "See https://github.com/endojs/endo/pull/
  1809#discussion_r1388052454." The codebase contains
  DESIGN-DECISION REFERENCES embedded in comments —
  links to specific PR discussion threads where the
  design was decided. §the-named-design-decision-link-
  in-comment as tier-3 meta-pattern.

  §the-named-template-type-with-indexed-mapping — lines
  20-28: typescript TEMPLATE TYPE that captures what
  the meta-method returns. Uses `@template {Record
  <RemotableMethodName, CallableFunction>} M` plus an
  INDEXED TYPE expression `{ [K in keyof M]: ... }`.
  Sophisticated type-level programming inside JSDoc
  comments. §the-named-typescript-via-JSDoc-with-
  template-types as tier-3 meta-pattern.

  §the-named-interface-guard-optional-on-exo — line
  23: `[GET_INTERFACE_GUARD]?: () => ...` — the meta-
  method is OPTIONAL. Cycle 425's exo README said
  "Every exo with an InterfaceGuard"; cycle 426
  confirms the optionality at the type level. Not all
  exos have guards; the meta-method is conditional.
  §the-named-meta-method-optionality-at-type-level as
  tier-3 meta-pattern.

  §the-named-meta-method-can-return-undefined —
  lines 23-27: return type is `InterfaceGuard<...> |
  undefined`. Even when the method exists, it can
  return undefined. THREE states: method-doesn't-
  exist OR method-exists-and-returns-undefined OR
  method-exists-and-returns-interface. §the-named-
  three-states-of-meta-method-presence as tier-3
  meta-pattern.

  §the-named-RemotableMethodName-as-typed-method-name
  — lines 4, 21: method names are typed via
  RemotableMethodName from @endo/pass-style.
  Connection to pass-style's branded types. §the-
  named-method-name-as-branded-type-from-pass-style
  as tier-3 meta-pattern.

  §the-named-MethodGuard-per-method-name-in-
  InterfaceGuard — lines 24-26: the InterfaceGuard's
  methodGuards object has one MethodGuard per method
  name. The mapping is 1-to-1 by key. Cycle 425's
  M.interface examples had this shape; cycle 426
  sees the type. §the-named-one-MethodGuard-per-
  method as tier-3 meta-pattern.

  §the-named-symbol-defined-separately-from-
  implementation — the file defines the constant
  string + typedef ONLY. The actual method addition
  happens elsewhere (presumably exo-makers.js or
  exo-tools.js). §the-named-constant-defined-
  separately-from-use-site as tier-3 meta-pattern.

  §the-named-if-it-has-one-qualifier — line 9: "the
  automatically added default meta-method for
  obtaining an exo's interface, **if it has one**."
  Confirms cycle 425's framing that exos may or may
  not have an interface guard. §the-named-conditional-
  meta-method-presence as tier-3 meta-pattern.

  §the-named-seventy-four-conformant-cycles-and-
  counting.

  Closes nine citation arcs: cycle 425 (1, adjacent
  forward; exo README's GET_INTERFACE_GUARD framing
  now grounded in source; sibling-pair revealed) +
  cycle 424 (3, types-only file like pass-style/
  copyRecord.js — both have minimal-source-high-
  information density) + cycle 421 (3, types-only-
  module-marker echo; export-empty similar to no-
  runtime-export here) + cycle 401 (5,
  __getMethodNames__ from cycle 401 now joined by
  __getInterfaceGuard__ as sibling) + cycle 387 (3,
  branded-types via RemotableMethodName) + cycle 326
  (75) + cycle 322 (75) + cycle 364 (4, shapes
  growing with type-template framings) + cycle 318
  (3, Endo idiom). Pushes citation-arc-closures-in-
  pivot to SEVEN-HUNDRED-AND-TWENTY-TWO (713 + 9 net
  new).
---

28-line get-interface.js from @endo/exo/src — the definition of the GET_INTERFACE_GUARD meta-method symbol. Companion to cycle 425's exo README. Chat-lane after cycle 425 designs-lane exo/README.md. **Single most structurally interesting move**: §the-named-two-meta-methods-getInterfaceGuard-and-getMethodNames-as-sibling-pair — *line 11's comment names a SIBLING: "Intended to be similar to GET_METHOD_NAMES from @endo/pass-style." Cycle 401 mentioned `__getMethodNames__()`; cycle 425 named GET_INTERFACE_GUARD; cycle 426 surfaces the PAIR. Two meta-methods for introspection: names vs guards.* §the-named-introspection-meta-method-sibling-pair as tier-3 meta-pattern. §the-named-GET_INTERFACE_GUARD-as-double-underscore-string-not-symbol (string for SES-realm portability); §the-named-portable-string-symbol-for-cross-realm. §the-named-staleness-warning-co-located-with-constant (warning restated at source, not just in README); §the-named-warning-restated-at-symbol-definition-site. §the-named-PR-discussion-link-as-design-rationale (link to GitHub PR discussion embedded in comment); §the-named-design-decision-link-in-comment. §the-named-template-type-with-indexed-mapping (sophisticated TypeScript-via-JSDoc); §the-named-typescript-via-JSDoc-with-template-types. §the-named-interface-guard-optional-on-exo (cycle 425's "Every exo with an InterfaceGuard" qualifier confirmed at type level); §the-named-meta-method-optionality-at-type-level. §the-named-meta-method-can-return-undefined (THREE states: missing / present-but-undefined / present-with-interface); §the-named-three-states-of-meta-method-presence. §the-named-RemotableMethodName-as-typed-method-name (branded type from pass-style); §the-named-method-name-as-branded-type-from-pass-style. §the-named-MethodGuard-per-method-name-in-InterfaceGuard; §the-named-one-MethodGuard-per-method. §the-named-symbol-defined-separately-from-implementation; §the-named-constant-defined-separately-from-use-site. §the-named-if-it-has-one-qualifier; §the-named-conditional-meta-method-presence. §the-named-seventy-four-conformant-cycles-and-counting. Nine citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-TWENTY-TWO.
