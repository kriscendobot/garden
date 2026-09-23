---
source: designs/break-dev-dependency-cycles.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/break-dev-dependency-cycles.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - repository-governance
  - tooling
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sink-only-package-pattern
cycle: 186
lane: designs
status: current
title: §Cut-3-is-pure-deletion (the simplest cut)
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

```
@endo/zip declares @endo/eventual-send and @endo/ses-ava as
devDeps but its test imports neither; it uses plain ava and
node:assert.

Decision: delete the two devDep entries.  No new package is
needed.
```

§Five-lines-of-diff. §The-§spot-audit-of-test-files (grep for
`import` from each declared devDep) §turned-up-vestigial-
entries. §A-design-that-finds-existing-mistakes is §audit-as-
cycle-break-precondition.

§Compare-to-cycle-180-hex-package's §32-row-audit-table — both
are §exhaustive-audit-drives-scope patterns. §The-§unused-
devDep-detection-via-grep is §mechanical-precision.
