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
title: §Future-Work (the §next-cycle-of-cleanups)
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

```
Once the cycles are broken and turbo is configured for ^build,
several follow-ups become attractive:
- Remove the multi-paragraph "Why not ^build?" section from
  turbo.json.md and replace it with a one-paragraph note...
- Pick the --conditions=test threading form...
- Audit the rest of the workspace (the 52 packages outside the
  SCC) for less-impactful devDep edges...
- Land the upstream dependencyTypes flag in turborepo as a
  defense-in-depth...
```

§Four-named-follow-ups. §The-§audit-the-rest-of-the-workspace
item points to §the-cycle-detection-discipline applying beyond
the SCC. §The-§upstream-dependencyTypes-flag item points to §a
§defense-in-depth-against-future-cycle-regression.

§Compare-to-cycle-180's §five-known-gaps + cycle 184's §six-
known-gaps. §All-three-are-§named-follow-ups-as-honest-design-
disclosure.
