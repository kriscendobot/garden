---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
title: "§Audit-extends-beyond-source: §test-files-included"
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

Five test files appear in the audit table:

- `daemon/test/hex.test.js`
- `ocapn/test/buffer-utils.test.js`
- `ocapn/test/codecs/_codecs_util.js`
- `ocapn/test/codecs/passable-fuzz.test.js`
- `compartment-mapper/demo/policy/app.js`

§Test-scaffolding-uses-`Buffer.from(...).toString('hex')` for
hex formatting of fuzz diagnostics and codec snapshots. §These-
are-migration-targets-too: removing `Buffer` from test
scaffolding lets tests run on XS and browser realms.

§This-is-the-§portability-by-removing-Node-specific-imports
discipline. §Cycle-179-lp32 had the same flavor: same-host stdio
IPC means no Node-specific `Buffer` is needed; @endo/hex
similarly lets test code drop its `Buffer` dependency.
