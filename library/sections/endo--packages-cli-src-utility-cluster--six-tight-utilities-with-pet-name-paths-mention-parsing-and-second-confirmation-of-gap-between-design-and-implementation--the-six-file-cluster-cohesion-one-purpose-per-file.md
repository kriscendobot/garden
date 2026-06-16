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
title: §The-§six-file-cluster-cohesion (one-purpose-per-file)
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

§Six-files-each-with-one-purpose. §No-file-imports-another
in the cluster. §Each-file-is-imported-individually by the
CLI's command modules (under `commands/`).

§Compare-to-cycle-187-shim-cluster which §three-package-spans
(eventual-send + promise-kit + ses-ava) with §nine-files.
§Cycle-195-is-§one-package-six-files. §Different-scope; same
§single-responsibility-per-file discipline.

§Compare-to-cycle-191-zip-src-cluster which had §eight-files
(of 11) with §interlocking-dependencies (BufferReader
imported by reader, etc.). §Cycle-195-cli-utility-cluster
has §no-internal-dependencies — flat utility helpers.

§Tier-1-borrowing: §one-purpose-per-file-with-no-internal-
dependencies for §CLI-utility-clusters where the helpers
are §independently-importable.
