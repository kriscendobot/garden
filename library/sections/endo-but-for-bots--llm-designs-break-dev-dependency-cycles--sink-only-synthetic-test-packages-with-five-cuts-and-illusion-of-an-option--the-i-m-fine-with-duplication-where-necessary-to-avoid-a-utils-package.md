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
title: §The-§"I'm fine with duplication where necessary to avoid a utils package"
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

```
"I'm fine with duplication where necessary to avoid a utils
package."
```

§Kris's-design-philosophy-named: §duplication-preferred-over-
indirection-that-creates-cycles. §A-`@endo/test-utils`-package
would itself need to depend on `@endo/init` and reintroduce
the cycle.

§The-design-explains-why: "They are not pure test helpers;
they are full SES installers and AVA wrappers that are also
legitimately consumed at runtime by downstream packages. The
synthetic-package approach moves the *consumers* (the tests
themselves), not the helpers, which preserves the helpers'
public surface."

§Compare-to-cycle-167-where/index.js' §when-in-Rome (per-
platform naming conventions duplicated rather than abstracted)
+ cycle 170's §map-to-existing-substrate-not-parallel-
abstractions. §All-three-are-§prefer-duplication-over-
indirection patterns at different scales.
