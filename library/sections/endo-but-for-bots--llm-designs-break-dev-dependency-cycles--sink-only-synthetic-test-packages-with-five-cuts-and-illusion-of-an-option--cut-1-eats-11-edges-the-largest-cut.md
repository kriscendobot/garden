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
title: §Cut-1-eats-11-edges (the largest cut)
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

```
A new package packages/ses-test/.  Hosts the SES test files
currently in packages/ses/test/ that need @endo/module-source
and the test262 prelude harness driving @endo/test262-runner.
```

§The-package.json-of-`@endo/ses-test`:

```
name: @endo/ses-test
private: true
dependencies:
  ses:                        workspace:^
  @endo/module-source:        workspace:^
  @endo/test262-runner:       workspace:^
  @endo/compartment-mapper:   workspace:^
  @endo/evasive-transform:    workspace:^
  @endo/init:                 workspace:^
  @endo/ses-ava:              workspace:^
  @endo/eventual-send:        workspace:^
  @endo/lockdown:             workspace:^
  ava: catalog:dev
```

§Nine-workspace-dependencies + `ava`. §`private: true` so
`lerna publish` skips it. §No-other-workspace-package-depends-
on-`@endo/ses-test`.

§The-files-moving: 13 import-hook test files + 5 test262
preludes + 2 build scripts. §This-single-move-retires-11-
edges including the `ses` ↔ `@endo/compartment-mapper` mutual
pair.

§Compare-to-cycle-178/180/184-§phased-implementation: this
design's §recommended-order is by §estimated-diff-size, not by
§dependency-order. §The-cuts-are-independent so size-order is
the §least-friction-rollout.
