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
title: §The-§cycle-is-cosmetic-noise-not-fatal (the motivation)
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

```
The cycle is not strictly fatal for affected-set selection
(`...[origin/llm]` walks the same workspace graph turbo would
walk for `^build`, so downstream packages are still selected
when an upstream changes), but the cosmetic noise on every CI
log conflicts with the project's silent-by-default diagnostic
discipline, and the per-task cache hash is weaker than it
could be.
```

§Three-cited-costs:

1. **§Cosmetic-noise** — turbo prints a multi-line cycle
   warning at the start of every invocation; clutters CI logs.
2. **§Silent-by-default-discipline-conflict** — Endo's
   project-wide diagnostic discipline (cycle 183-init's
   `console.warn` is the §exception-not-the-rule) is violated
   by per-invocation noise.
3. **§Weaker-per-task-cache-hash** — without `^build`, the
   `test`/`lint` task hashes don't include upstream package
   build hashes, so the cache is more permissive than
   correctness allows.

§None-of-these-is-fatal-alone, but together they §motivate-the-
factoring. §Compare-to-cycle-180-hex-package's §three-concrete-
costs of duplication (inconsistent semantics + native fast-
paths only wired up in one package + no canonical home). §Both-
designs-name-the-motivating-costs-as-a-three-bullet-list.
