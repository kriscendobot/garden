---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/smallcaps.md
source_line_range: 1-26
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 449 designs-lane ingest. 25-line
  primer/smallcaps.md from @endo/lal's agent-facing
  primer. Eleventh lal-package artifact in the cluster.
  Ninety-seventh AUTHORED conformant single-body
  section doc in post-refactor era. One-hundred-
  thirty-ninth consecutive non-garden source after
  the pivot (310-449). §one-hundred-thirty-nine-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-
  named-escape-set-covers-all-seven-prefixes-
  including-undisclosed-three — the primer's encoding
  vocabulary explains only FIVE of SmallCaps' seven
  active special characters (BigInt +/-, manifest
  constants #, escape !), but the escape-prefix rule
  (lines 20-24) lists SEVEN characters requiring !-
  escape: !, #, $, %, &, +, -. The $  (remotable), %
  (symbol), and & (promise) prefixes appear in the
  escape table without being explained. The escape
  rule is complete; the encoding vocabulary
  description is filtered. §the-named-escape-set-
  covers-all-seven-prefixes-including-undisclosed-
  three as tier-3 meta-pattern.

  §the-named-primer-smallcaps-as-filtered-subset-of-
  full-smallcaps-vocabulary — same subset-filter
  pattern as tool catalog level (15 of 22 methods in
  tools.md, cycle 407) now at encoding layer: LLM
  sees subset of encoding vocabulary needed for its
  role (five types it produces/receives) but escape
  rule must be complete (all seven characters that
  could appear in passing). §the-named-filtering-for-
  LLM-role-discipline-at-encoding-layer.

  §the-named-escape-hatch-discloses-undisclosed-types
  — the escape table is a window into the full
  SmallCaps alphabet via its negative space: a reader
  who knows SmallCaps can infer $ + % + & encode
  something from their presence in the escape list.
  The silence about three types teaches through what
  must be avoided. §the-named-negative-space-reveals-
  full-alphabet as tier-3 meta-pattern.

  §the-named-bigint-as-primary-smallcaps-use-in-lal
  — BigInt messageNumber is the dominant use case
  ("+N"/"-N" for BigInt; example: `{"messageNumber":
  "+5"}`). Every tool that takes a messageNumber
  requires SmallCaps BigInt encoding. §the-named-
  bigint-as-dominant-encoding-in-lal-tools.

  §the-named-manifest-constants-cover-four-special-
  float-values — four #-prefixed encodings cover
  four JSON-inexpressible values: undefined, Infinity,
  -Infinity, NaN. Set is exhaustive for the JSON gap.
  §the-named-four-manifest-constants-as-json-gap-
  closure.

  §the-named-escape-prefix-applies-to-any-special-
  first-character — escape rule is uniform: ANY
  string whose first character is one of the seven
  special characters requires !-prefix. Not a per-
  type exception; a uniform rule. §the-named-uniform-
  escape-rule-over-entire-special-character-set.

  §the-named-most-tool-arguments-regular-json —
  lines 25-26: "Most tool arguments are regular
  JSON values and don't need special encoding."
  SmallCaps is the exception, not the rule. §the-
  named-smallcaps-as-exceptional-case-not-default.

  §the-named-five-row-encoding-table — three-column
  five-row table: BigInt (two sign rows) + undefined
  + Infinity + -Infinity + NaN. Covers all non-JSON
  types the LLM might encounter or produce. §the-
  named-five-row-table-covers-five-non-json-types.

  Closes seven citation arcs: cycle 448 (1, adjacent
  forward; ws-relay.js uses SmallCaps at the CapTP
  framing layer; smallcaps.md is the LLM-facing spec
  for the same encoding) + cycle 407 (3, tools.md
  tool signatures require SmallCaps BigInt for
  messageNumber; smallcaps.md is the wire-format
  spec) + cycle 423 (3, marshal README named two-
  encoding-systems; smallcaps.md shows filtered LLM
  subset of seven-prefix vocab) + cycle 405 (3,
  primer-vs-no-dynamic-context tension; smallcaps.md
  confirms primer as encoding-reference component
  of the primer corpus) + cycle 402 (5, agent.types.
  d.ts revealed messageNumber as BigInt in
  TranscriptNode; smallcaps.md explains the +N
  encoding that carries BigInt across tool-call
  boundary) + cycle 326 (75) + cycle 322 (75).
  Pushes citation-arc-closures-in-pivot to NINE-
  HUNDRED-AND-TWENTY-EIGHT (921 + 7 net new).
---

25-line `packages/lal/primer/smallcaps.md` — the LLM-facing SmallCaps encoding spec for @endo/lal tool call arguments. Eleventh lal-package artifact in the cluster. Designs-lane after cycle 448 chat-lane ws-relay.js. **Single most structurally interesting move**: §the-named-escape-set-covers-all-seven-prefixes-including-undisclosed-three — *the primer's encoding vocabulary explains only FIVE of SmallCaps' seven active special characters, but the escape rule lists all SEVEN: `!, #, $, %, &, +, -`. The `$` (remotable), `%` (symbol), and `&` (promise) prefixes appear in the escape table without being explained; the escape rule is complete, the encoding vocabulary description is filtered.* §the-named-primer-smallcaps-as-filtered-subset-of-full-smallcaps-vocabulary (same subset-filter pattern as tool catalog: 15 of 22 methods in tools.md, now appearing at the encoding layer); §the-named-filtering-for-LLM-role-discipline-at-encoding-layer. §the-named-escape-hatch-discloses-undisclosed-types; §the-named-negative-space-reveals-full-alphabet (the escape table is a window into the full SmallCaps alphabet via its negative space). §the-named-bigint-as-primary-smallcaps-use-in-lal; §the-named-bigint-as-dominant-encoding-in-lal-tools (BigInt messageNumber is the dominant use case). §the-named-manifest-constants-cover-four-special-float-values; §the-named-four-manifest-constants-as-json-gap-closure (four #-prefixed constants close JSON's inexpressible-values gap exactly). §the-named-escape-prefix-applies-to-any-special-first-character; §the-named-uniform-escape-rule-over-entire-special-character-set. §the-named-most-tool-arguments-regular-json; §the-named-smallcaps-as-exceptional-case-not-default. §the-named-five-row-encoding-table; §the-named-five-row-table-covers-five-non-json-types. §the-named-ninety-seven-conformant-cycles-and-counting. Seven citation arcs closed; pushes citation-arc-closures-in-pivot to NINE-HUNDRED-AND-TWENTY-EIGHT (921 + 7 net new).

## Section list

- [endo-but-for-bots--packages-lal-primer-smallcaps-md--escape-set-covers-all-seven-prefixes-including-undisclosed-three](../sections/endo-but-for-bots--packages-lal-primer-smallcaps-md--escape-set-covers-all-seven-prefixes-including-undisclosed-three.md)
