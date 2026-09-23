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
title: §The-survey (Tarjan SCC produces exactly one 13-package SCC)
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

```
@endo/compartment-mapper
@endo/evasive-transform
@endo/eventual-send
@endo/harden
@endo/hex
@endo/init
@endo/lockdown
@endo/module-source
@endo/promise-kit
@endo/ses-ava
@endo/test262-runner
@endo/zip
ses
```

§The-dependencies-only-subgraph-has-zero-non-trivial-SCCs.
§Every-cycle-is-created-by-devDependencies-back-edges. §This-
observation-is-load-bearing: the runtime layering is clean; the
test-time layering creates the cycle.

§The-18-cycle-forming-devDep-edges collapse to §four-families:

| Family | Edges | Cut |
|--------|-------|-----|
| `ses`-as-test-installer | 11 | Cut 1 → `@endo/ses-test` |
| `@endo/hex`'s test scaffold | 4 | Cut 2 → `@endo/hex-test` |
| Vestigial `@endo/zip` devDeps | 2 | Cut 3 → delete |
| `@endo/harden`'s `ses` import | 1 | Cut 4 → `@endo/harden-test` |
| Mop-up: `@endo/eventual-send` → `@endo/lockdown` + `ses` | — | Cut 5 → `@endo/eventual-send-test` |

§Each-cut-is-independent — they can land in any order. §The-
recommended-order-is-smallest-to-largest: Cut 3 (5 lines) →
Cut 4 (50 lines) → Cut 2 (30 lines) → Cut 5 (150 lines) → Cut 1
(600 lines) → final turbo.json flip.
