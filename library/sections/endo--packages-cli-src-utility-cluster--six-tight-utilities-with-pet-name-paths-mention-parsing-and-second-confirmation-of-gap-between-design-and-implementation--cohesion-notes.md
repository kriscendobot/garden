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
title: §Cohesion notes
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

- §Six-tight-utilities, each §one-purpose-per-file with §no-
  internal-dependencies.
- §Second-confirmation-of-the-§gap-between-design-and-
  implementation: cycle 180-hex-package's audit-table-row-32
  predicted §retained-at-boundary for `cli/src/random.js` line
  9; actual source uses `encodeHex(bytes)`. §Two-of-two-audit-
  boundary-sites have-since-been-migrated.
- §Pet-name-path-parsing with §empty-segment-rejection and
  §parseOptional-variant-pattern.
- §@-mention-format/parse-pair: §@-escape-via-backslash in
  format; §regex-with-128-char-max + §optional-edge-name in
  parse.
- §Five-properties-of-the-regex (lowercase prefix + 128 char
  max + allowed charset + optional edge + global flag).
- §Example-comments-in-source-not-tests (five console.log
  examples commented out in message-parse.js).
- §parseBigint with §strict-regex `/^(0|[1-9][0-9]*)$/` for
  non-negative integer with no leading zeros.
- §randomHex16 with §Node-callback-promise-wrap + §confirmed-
  use-of-@endo/hex despite cycle-180-design-prediction-of-
  boundary-retention.
- §Async-readline-prompt with §trim-and-toLowerCase-discipline.
- §Implicitly-tested-by-the-CLI-itself (no per-file unit
  tests in this cluster).
