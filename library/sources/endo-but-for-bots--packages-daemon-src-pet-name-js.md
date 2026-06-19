---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/daemon/src/pet-name.js
source_line_range: 1-126
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 394 chat-lane ingest paired to cycle 393 designs-
  lane mailbox-durability plan. 126-line pet-name.js, the
  canonical implementation of the bot-fork's pet-name
  validation discipline. Forty-second AUTHORED conformant
  single-body section doc in post-refactor era. Eighty-
  fourth consecutive non-garden source after the pivot
  (310-394). §eighty-four-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  two-patterns-petName-and-specialName — lines 9-10 define
  TWO regex patterns that distinguish two namespaces by
  FIRST-CHARACTER CASE: `validPetNamePattern = /^[a-z0-9]
  [a-z0-9-]{0,127}$/` (lowercase-or-digit start; lowercase
  alphanumeric or hyphens; 128 chars max) and
  `validSpecialNamePattern = /^[A-Z][A-Z0-9-]{0,127}$/`
  (uppercase start; uppercase alphanumeric or hyphens; 128
  chars max). Same shape, different namespace via case.
  §the-named-case-as-namespace-distinguisher as tier-3
  meta-pattern; case is the namespace flag — simple,
  visual, unambiguous.

  §The-named-128-char-limit-matches-cycle-386 — the `{0,
  127}` quantifier matches cycle 386's @endo/chat petname-
  parser regex limit. Cross-package consistency: the
  daemon's pet-name validator and the chat's message-parser
  enforce the same 128-character limit. §the-named-cross-
  package-name-length-consistency as tier-3 meta-pattern.

  §The-named-PetName-and-SpecialName-as-branded-types —
  lines 14, 20, 26 use TypeScript type predicates with
  BRANDED types (`PetName`, `SpecialName`, `Name`). This is
  exactly what cycle 387 AGENTS.md named: "prefer a branded
  return type from the validator over raw string." The
  pet-name.js file is a canonical application of that
  discipline. §the-named-branded-types-from-validator as
  tier-3 meta-pattern.

  §The-named-three-isX-predicates — isPetName + isSpecialName
  + isName (union of the first two). The three-predicate
  shape mirrors the three branded-type shape. §the-named-
  is-predicate-trio-mirrors-branded-type-trio as tier-3
  meta-pattern.

  §The-named-three-assertX-functions — assertPetName +
  assertSpecialName + assertName. Each uses the `asserts X
  is Y` JSDoc signature to convert a string to a branded
  type via runtime check. §the-named-assert-trio-mirrors-
  predicate-trio as tier-3 meta-pattern.

  §The-named-NamePath-as-array-of-Name — line 5's @import
  brings in NamePath alongside Name + PetName + SpecialName.
  The NamePath is the path-shaped form. §the-named-name-
  path-as-array-of-names as tier-3 meta-pattern.

  §The-named-assertPetNamePath-returns-decomposition — lines
  100-115: returns `{ namePath, prefixPath, petName }`. The
  path is decomposed into THREE NAMED PARTS: full path +
  prefix (all-but-last) + final pet name. §the-named-three-
  named-parts-of-decomposed-path as tier-3 meta-pattern;
  sibling shape to cycle 386's three-parallel-arrays-strings-
  petNames-edgeNames.

  §The-named-namePathFrom-normalizes-string-or-array — lines
  122-126: a string becomes a single-element array; an array
  passes through; both validated. §the-named-flexible-input-
  strict-output as tier-3 meta-pattern; the caller can pass
  either form, but the output is always a validated array.

  §The-named-q-from-endo-errors-in-error-messages — line 7
  imports `q` from `@endo/errors`. Uses `q(petName)` in
  error messages to safely quote the invalid value (cycle
  392 CLAUDE.md sidebar: "use q() to safely quote values").
  §the-named-q-from-errors-as-quoting-discipline as tier-3
  meta-pattern.

  §The-named-references-types-d-ts-via-triple-slash — line
  3: `/// <reference types="./types.d.ts" />`. Uses
  TypeScript triple-slash directive to reference the .d.ts
  file. Sibling shape to cycle 376 JSDoc @import; here using
  triple-slash. §the-named-triple-slash-vs-jsdoc-import-as-
  two-shapes as tier-3 meta-pattern; same purpose
  (referencing types), different syntax.

  §The-named-126-line-canonical-name-validator — the entire
  pet-name validation discipline fits in 126 lines: two
  patterns + three predicates + three asserts + an array
  assert + a path assert + a decomposing path assert + a
  normalizer. The vocabulary surface is compact. §the-named-
  compact-vocabulary-via-trio-pattern as tier-3 meta-
  pattern.

  §The-named-special-name-vs-at-prefixed-name-distinction —
  this file's validSpecialNamePattern (UPPERCASE no prefix)
  differs from cycle 387/392 CLAUDE.md's `@`-prefixed names
  (`@agent`, `@self`, etc., matching `/^@[a-z][a-z0-9-]{0,
  127}$/`). The bot-fork has TWO categories of non-pet names:
  UPPERCASE-no-prefix (like HOST from cycle 374) and @-
  prefixed-lowercase (like @agent from CLAUDE.md). §the-
  named-three-name-namespaces-pet-uppercase-at-prefixed as
  tier-3 meta-pattern; three distinct naming conventions
  coexist in the bot-fork's daemon.

  Closes seven citation arcs: cycle 393 (1, adjacent
  forward; mailbox-durability used pet-store with naming
  convention; cycle 394 reveals the canonical name validator
  underneath) + cycle 386 (7, same 128-char limit; cross-
  package name length consistency) + cycle 387 (2, AGENTS.
  md branded-types-from-validators discipline canonically
  applied here) + cycle 374 (7, HOST vs alice-agent
  namespace distinction; cycle 394 names the case-as-
  namespace mechanism behind it) + cycle 326 (68, pure-
  naming-as-discipline) + cycle 322 (68, @endo/errors q()
  used here) + cycle 376 (3, JSDoc @import sibling shape;
  triple-slash here as alternative). Pushes citation-arc-
  closures-in-pivot to FOUR-HUNDRED-THIRTY-SEVEN (430 + 7
  net new).
---

126-line pet-name.js, the canonical implementation of the bot-fork's pet-name validation discipline. §the-named-two-patterns-petName-and-specialName (single most structurally interesting move; case-as-namespace-distinguisher); §the-named-case-as-namespace-distinguisher. §the-named-128-char-limit-matches-cycle-386 (cross-package name-length consistency); §the-named-cross-package-name-length-consistency. §the-named-PetName-and-SpecialName-as-branded-types (canonical application of cycle 387 AGENTS.md branded-types discipline); §the-named-branded-types-from-validator. §the-named-three-isX-predicates; §the-named-is-predicate-trio-mirrors-branded-type-trio. §the-named-three-assertX-functions; §the-named-assert-trio-mirrors-predicate-trio. §the-named-NamePath-as-array-of-Name. §the-named-assertPetNamePath-returns-decomposition (three named parts: namePath + prefixPath + petName; sibling to cycle 386 three-parallel-arrays); §the-named-three-named-parts-of-decomposed-path. §the-named-namePathFrom-normalizes-string-or-array; §the-named-flexible-input-strict-output. §the-named-q-from-endo-errors-in-error-messages; §the-named-q-from-errors-as-quoting-discipline. §the-named-references-types-d-ts-via-triple-slash; §the-named-triple-slash-vs-jsdoc-import-as-two-shapes (cycle 376 JSDoc @import sibling). §the-named-126-line-canonical-name-validator; §the-named-compact-vocabulary-via-trio-pattern. §the-named-special-name-vs-at-prefixed-name-distinction; §the-named-three-name-namespaces-pet-uppercase-at-prefixed (three coexisting naming conventions). Seven citation arcs closed.
