---
source: packages/cli/src/{pet-name,message-format,message-parse,number-parse,random,prompt}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/cli/src
source_path: packages/cli/src/pet-name.js, packages/cli/src/message-format.js, packages/cli/src/message-parse.js, packages/cli/src/number-parse.js, packages/cli/src/random.js, packages/cli/src/prompt.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
genre: §endo-source-comment-fragment §canonical-CLI-utility-cluster
cycle: 195
lane: chat
status: current
title: Six tight CLI utilities (pet-name path parsing, @-mention message format and parse, parseBigint, randomHex16, readline prompt) with second confirmation of the design-vs-implementation gap
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

> §Chat-lane after cycle 194's designs-lane. §The-twenty-
> ninth-consecutive designs/chat alternation cycle (166-195).
> §Cycle-185-check-bundle observed the §gap-between-design-
> and-implementation when cycle 180-hex-package's audit-
> table-row-23 predicted §retained-at-boundary for `check-
> bundle/index.js` line 14, but the actual source had
> migrated to `encodeHex`. §Cycle-195 confirms the same
> pattern at a second site: `cli/src/random.js` line 9 was
> the same §retained-at-boundary prediction (cycle 180-hex
> audit-table-row-32) — and §the-actual-current-source uses
> `encodeHex(bytes)` from @endo/hex. §Twice-now: designs-
> are-guides-not-contracts.

`packages/cli/src/` contains a §six-file-utility-cluster
(138 lines total) of small focused helpers used throughout
the `endo` CLI surface. Each file is §a-single-responsibility
helper that the CLI's command modules import.

| File | Lines | Single responsibility |
|------|-------|-----------------------|
| `pet-name.js` | 41 | §dot-delimited-pet-name-path-parsing |
| `message-format.js` | 20 | §template-literal-formatter for `@petName` mentions |
| `message-parse.js` | 28 | §regex-based parser for `@petName:edgeName` |
| `number-parse.js` | 13 | §parseBigint with strict regex validation |
| `random.js` | 13 | §randomHex16 — now uses @endo/hex |
| `prompt.js` | 23 | §readline-based interactive lowercase prompt |

§The-single-most-structurally-interesting-move is §second-
confirmation-of-the-§gap-between-design-and-implementation
(at `cli/src/random.js` line 9) + §dot-delimited-pet-name-
path-parsing-with-empty-segment-rejection + §@-escape-via-
backslash-in-format-companion-with-@-mention-regex-in-parse
+ §strict-regex-bigint-parser + §example-comments-in-source-
not-tests. §Five-named-moves across the cluster.
