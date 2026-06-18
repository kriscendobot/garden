---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/chat/message-parse.js
source_line_range: 1-30
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 386 chat-lane ingest paired to cycle 385 designs-lane
  @endo/chat README. 30-line implementation of the petname
  parser used by the chat web UI (and likely shared with the
  CLI). Thirty-fourth AUTHORED conformant single-body section
  doc in post-refactor era. Seventy-sixth consecutive non-
  garden source after the pivot (310-386). §seventy-six-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  petname-regex-as-validation-and-extraction — line 3's
  single regex `/@([a-z][a-z0-9-]{0,127})(?::([a-z][a-z0-9-]
  {0,127}))?/g` does TWO jobs: validates the petname syntax
  AND extracts the components for further processing. The
  petname must start with `@`, lowercase-ASCII-alpha-start,
  then up to 128 characters of `[a-z0-9-]`, with an optional
  colon-separated second identifier of the same shape. §the-
  named-single-regex-validates-and-extracts as tier-3 meta-
  pattern; one source-of-truth for both syntax legality and
  component extraction.

  §The-named-128-character-petname-length-limit — the regex
  enforces `{0,127}` (so up to 128 characters total per
  identifier, with the first character being separately
  required as `[a-z]`). Concrete numeric constraint not
  visible in cycle 385's README or DESIGN. §the-named-
  numeric-constraint-in-code-not-in-docs as tier-3 meta-
  pattern; the implementation specifies precisely what the
  documentation only sketched.

  §The-named-strict-lowercase-alpha-start-petname-rule —
  first character must match `[a-z]`. No digits, no caps, no
  underscores. Disciplined namespace. §the-named-lowercase-
  alpha-start-as-namespace-discipline as tier-3 meta-
  pattern; the constraint excludes ambiguous starts
  (digits could look like numbers; caps could conflict with
  proper-name conventions).

  §The-named-hyphens-but-not-underscores-in-petnames — the
  character class `[a-z0-9-]` allows hyphens but not
  underscores. Aligns with kebab-case identifier convention
  used elsewhere in the cluster (memory_get/memory_search
  in cycle 384 tools are exceptions because they're tool-
  catalog names, not petnames). §the-named-kebab-case-only-
  for-petnames as tier-3 meta-pattern.

  §The-named-petname-vs-edgename-variable-naming-question —
  the code names capture group 1 `edgeName` (the pre-colon
  identifier) and capture group 2 `petName` (the optional
  post-colon identifier). Cycle 385 README said the format
  is `@pet-name:edge-name` (pet-name first). The CODE's
  variable naming reads `@edge-name:pet-name` (edge-name
  first). Either the README's documentation is reversed
  from the code's variable names, or the code's variable
  names mislead about which is which. The OUTPUT field
  `petNames` is filled by `petName ?? edgeName` (line 21),
  so the OUTPUT pet-name is the LAST identifier (post-colon
  if present, pre-colon otherwise). §the-named-petname-
  edgename-naming-inversion-between-README-and-CODE as
  tier-3 meta-pattern; the documentation drift here is
  sibling shape to cycle 384's §the-named-design-doc-trails-
  code — except this one is the OPPOSITE direction
  (README's vocabulary inverts code's naming). The reader
  must consult both to understand the convention.

  §The-named-three-parallel-arrays-strings-petNames-
  edgeNames — line 25-29 returns `{ strings, petNames,
  edgeNames }`. Three arrays the consumer can interleave:
  strings[0] + petname-ref[0] + strings[1] + petname-ref[1]
  + ... + strings[n]. §the-named-text-and-references-as-
  parallel-arrays-not-tagged-union as tier-3 meta-pattern;
  the output is a flat-arrays shape, not an array of
  variant-tagged tokens.

  §The-named-fallback-via-nullish-coalescing — line 21
  `petNames.push(petName ?? edgeName)` uses `??` (nullish
  coalescing) to fall back from petName to edgeName when
  petName is undefined. §the-named-nullish-coalescing-for-
  optional-capture-group as tier-3 meta-pattern; concise
  fallback when an optional regex capture might be
  undefined.

  §The-named-replace-with-side-effect-callback — the
  function uses `message.replace(pattern, (...) => '')`
  with a callback that pushes into the arrays (side
  effects), returning an empty string each time. The
  replace's return value is discarded. §the-named-replace-
  as-iteration-with-side-effects as tier-3 meta-pattern;
  using `replace` not for replacement but for iterating
  matches with side effects on captured groups.

  §The-named-start-tracking-for-text-between-references —
  line 15 `let start = 0` and lines 17-18 track where each
  text-between-references slice begins and ends. The text-
  before-first-reference, text-between-references, and
  text-after-last-reference are all captured in `strings[]`.
  §the-named-cursor-pattern-for-tokenization as tier-3
  meta-pattern.

  §The-named-thirty-line-single-function-parser — the
  entire parser is one exported function plus a module-
  scope regex constant. Sibling shape to cycle 372's
  extension.js (22-line URL extension parser) — both are
  small single-purpose parsing utilities. §the-named-
  parsing-utility-as-tiny-module as tier-3 meta-pattern.

  §The-named-ts-check-pragma-as-opt-in-checking — line 1
  `// @ts-check` continues the cluster convention.

  Closes seven citation arcs: cycle 385 (1, adjacent
  forward; chat README → its petname-parser implementation)
  + cycle 384 (1, design-doc-trails-code framing; cycle
  386 reveals a documentation-trails-code instance: README
  vocabulary inverts code's naming) + cycle 374 (5, same
  petname syntax demonstrated in CLI demo; cycle 386 shows
  the literal regex parsing it) + cycle 367 (7, exo's
  validated-OCAP composes with petname-as-capability-
  reference; the parser is the gate that turns a string
  into a capability reference candidate) + cycle 326 (60,
  pure-naming-as-discipline; petname syntax is pure
  naming made into a regex constraint) + cycle 372 (2,
  parsing-utility-as-tiny-module sibling) + cycle 322
  (60). Pushes citation-arc-closures-in-pivot to THREE-
  HUNDRED-EIGHTY-ONE (374 + 7 net new).
---

30-line implementation of the petname parser used by the chat web UI. §the-named-petname-regex-as-validation-and-extraction (single most structurally interesting move; one regex does both validation and component extraction). §the-named-128-character-petname-length-limit (numeric constraint in code not in docs). §the-named-strict-lowercase-alpha-start-petname-rule. §the-named-hyphens-but-not-underscores-in-petnames (kebab-case discipline). §the-named-petname-vs-edgename-variable-naming-question (code's variable names invert README's vocabulary; sibling to cycle 384 documentation-drift framing but pointing the opposite direction). §the-named-three-parallel-arrays-strings-petNames-edgeNames; §the-named-text-and-references-as-parallel-arrays-not-tagged-union. §the-named-fallback-via-nullish-coalescing. §the-named-replace-with-side-effect-callback (replace as iteration). §the-named-start-tracking-for-text-between-references (cursor pattern for tokenization). §the-named-thirty-line-single-function-parser (sibling shape to cycle 372 extension.js). §the-named-ts-check-pragma-as-opt-in-checking. Seven citation arcs closed.
