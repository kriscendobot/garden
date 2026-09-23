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
title: §The-§absence-of-tests (in this cluster)
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

§None-of-these-six-files have adjacent test files in this
ingest. §The-CLI-utilities-are-tested-via-the-CLI-itself
(integration tests of the `endo` commands).

§Compare-to-cycle-185-check-bundle which has its own test
file. §Cycle-195-cli-utilities are §implicitly-tested-by-
the-CLI-commands that use them.

§The-§example-comments-in-source (message-parse.js) might
be the §closest-thing-to-a-test these utilities ship. §A-
contributor-would-uncomment-and-run-Node to verify behavior
during development.
