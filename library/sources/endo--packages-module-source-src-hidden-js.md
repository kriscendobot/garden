---
source_kind: source
source_repo: endojs/endo
source_path: packages/module-source/src/hidden.js
source_line_range: 1-20
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 376 chat-lane ingest paired to cycle 375 designs-lane
  @endo/module-source DESIGN.md. 20-line implementation of
  the invisible-joiner-character trick named in the DESIGN
  at lines 80-81. Twenty-fourth AUTHORED conformant single-
  body section doc in post-refactor era. Sixty-six consecutive
  non-garden sources after the pivot (310-376). §sixty-six-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-U-
  034f-as-combining-grapheme-joiner — line 1-2 use `͏`
  (Unicode COMBINING GRAPHEME JOINER, CGJ) embedded inside
  the generated-identifier prefix: `'$h͏_'` and
  `'$c͏_'`. CGJ is invisible (zero-width visually) and
  not allowed in identifier-start position, which means no
  sensibly-constructed module can produce an identifier
  matching these prefixes — collision avoidance via a
  character JS users will not type. §the-named-collision-
  avoidance-via-Unicode-character-users-cannot-type as
  tier-3 meta-pattern.

  §The-named-comment-explaining-meta-replacement-length —
  lines 8-9: "HIDDEN_META is used to replace `import.meta`.
  The value fits the original length so it doesn't displace
  the column number of following text." The cycle 375 DESIGN
  named §the-named-source-line-preservation-as-debug-
  affordance ("the transformation preserves line numbers");
  cycle 376 reveals the trick at column granularity:
  HIDDEN_META is sized to match `import.meta` so even
  COLUMN numbers in stack traces stay aligned. The discipline
  goes deeper than the DESIGN's headline. §the-named-column-
  number-preservation-via-equal-length-replacement as tier-3
  meta-pattern.

  §The-named-two-prefixes-for-two-binding-kinds — line 1
  uses `$h` (hidden) prefix; line 2 uses `$c` (const)
  prefix. Two prefixes match the liveExportMap (mutable) /
  fixedExportMap (immutable) distinction from cycle 375's
  DESIGN. §the-named-prefix-mirrors-binding-mutability as
  tier-3 meta-pattern; the source structure carries the
  semantic distinction in the identifier prefix.

  §The-named-seven-hidden-names-suffice-for-transform —
  HIDDEN_A + HIDDEN_IMPORT + HIDDEN_IMPORT_SELF +
  HIDDEN_IMPORTS + HIDDEN_ONCE + HIDDEN_META + HIDDEN_LIVE.
  Exactly seven internal identifiers are needed for the
  entire ESM-to-functor transformation. §the-named-finite-
  set-of-internal-names as tier-3 meta-pattern.

  §The-named-HIDDEN_IDENTIFIERS-array-as-introspection-
  surface — line 12-20 export the array of all seven names.
  Other code (presumably the transform analyzer) can iterate
  the list to filter or detect these identifiers. §the-named-
  enumeration-export-for-other-code-to-iterate as tier-3
  meta-pattern.

  §The-named-twenty-line-implementation-of-design-detail —
  the cycle 375 DESIGN's lines 80-81 ("names are obscured
  with invisible joiner characters") become 20 lines of
  concrete code here. Sibling shape to cycle 372 (22-line
  compartment-mapper extension utility from substantial
  package) and cycle 370 (23-line daemon utility from
  thousands of lines). §the-named-twenty-line-utility-as-
  recurring-substantial-package-decomposition as tier-3
  meta-pattern.

  §The-named-single-purpose-module-as-exported-constants-
  only — the file exports ONLY constants, no functions or
  classes. The module's job is to be the source of truth
  for the prefix and identifier list; consumed by transform
  code elsewhere. §the-named-constants-as-API-surface as
  tier-3 meta-pattern.

  Closes seven citation arcs: cycle 375 (1, adjacent forward
  pair DESIGN → implementation; DESIGN lines 80-81 reach
  their 20-line concrete realization) + cycle 372 (1, pure-
  utility-needs-no-powers + twenty-something-line-utility-
  from-substantial-package siblings; both extension.js and
  hidden.js are pure modules with no runtime imports) +
  cycle 370 (1, similar shape) + cycle 371 (1, compartment-
  mapper's caller-supplies-IO-powers consumes module-source
  outputs; hidden.js is one piece of that transformation
  primitive) + cycle 367 (1, exo's discipline composes with
  module-source's transform) + cycle 326 (49, pure-naming-
  as-discipline; hidden identifiers are pure naming) +
  cycle 322 (50, @endo/errors not used). Pushes citation-
  arc-closures-in-pivot to THREE-HUNDRED-FOUR (297 + 7
  net new) — citation-arc-closures-in-pivot crosses the
  three-hundred threshold.
---

20-line implementation of the invisible-joiner-character trick named in cycle 375 module-source DESIGN.md. Chat-lane after cycle 375 designs-lane DESIGN. §the-named-U-034f-as-combining-grapheme-joiner (single most structurally interesting move — Unicode CGJ in generated-identifier prefix; collision avoidance via character JS users will not type). §the-named-comment-explaining-meta-replacement-length (HIDDEN_META sized to match `import.meta` so column numbers stay aligned; discipline goes deeper than DESIGN's headline). §the-named-two-prefixes-for-two-binding-kinds (`$h` for hidden, `$c` for const; mirrors liveExportMap/fixedExportMap distinction). §the-named-seven-hidden-names-suffice-for-transform. §the-named-HIDDEN_IDENTIFIERS-array-as-introspection-surface. §the-named-twenty-line-implementation-of-design-detail (recurring substantial-package-decomposition shape). §the-named-single-purpose-module-as-exported-constants-only. Seven citation arcs closed. **Citation-arc-closures-in-pivot crosses 300.**
