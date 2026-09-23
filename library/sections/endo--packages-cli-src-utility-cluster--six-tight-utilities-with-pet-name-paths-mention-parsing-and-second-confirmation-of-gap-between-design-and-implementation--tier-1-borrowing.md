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
title: §Tier-1 borrowing
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

- §designs-are-guides-not-contracts (§confirmed-twice now;
  verify-against-source not just against design)
- §parseOptional-variant-pattern (undefined-passthrough
  wrapper around a strict parser)
- §empty-segment-rejection in dot-delimited path-parsing
- §@-escape-via-backslash + §@-mention-regex-with-128-char-
  max (matched format/parse pair)
- §example-comments-in-source-not-tests (commented-out
  console.log examples for quick mental verification)
- §strict-regex-bigint-parser for non-negative integer input
- §promise-wrap-Node-callback-API for cleaner async surface
- §async-readline-prompt-with-trim-and-toLowerCase
- §one-purpose-per-file-with-no-internal-dependencies for
  CLI utility clusters
