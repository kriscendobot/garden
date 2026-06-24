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
title: §The-`sink-only` constraint (the load-bearing property)
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

```
The proposal is a one-shot factoring that moves the test
scaffolding that creates each cycle edge into a sink-only
package: a package that declares the upstream subsystems it
tests via regular `dependencies` and on which **no other
workspace package depends** (neither as `dependencies` nor as
`devDependencies`).  Sink-only is the load-bearing constraint.
A package downstream of the SCC cannot extend the SCC; that
is what makes it a cycle break.
```

§The-prose-names-the-constraint-explicitly. §Sink-only =
§no-incoming-workspace-edges. §If-any-other-workspace-package-
ever-adds-`@endo/foo-test`-as-a-dep, the cycle break collapses.

§Compare-to-cycle-180-hex-package's §sibling-package-cloned-
file-for-file — both are §package-shape-disciplines, but
focused on different invariants. §Hex-package-discipline: clone
the skeleton. §Sink-only-discipline: don't get depended on.

§The-repo-already-has-one-such-package: `@endo/stream-types-
test`. §The-design-generalizes-that-shape, citing it as the
§existing-precedent.
