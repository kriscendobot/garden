---
title: 'endo-but-for-bots designs/break-dev-dependency-cycles.md'
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/break-dev-dependency-cycles.md
source_paths:
  - designs/break-dev-dependency-cycles.md
authors:
  - Kris Kowal (prompted)
created: 2026-05-11
updated: 2026-05-18
status_at_ingest: In Progress
ingested: 2026-06-03
ingested_by: scholar
topics:
  - repository-governance
  - tooling
sections:
  - endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option.md
genre: §endo-but-for-bots-design §sink-only-package-pattern
cycle: 186
lane: designs
---

# Break devDependency Cycles via Synthetic Test Packages (design)

## §Abstract

736-line design (Created 2026-05-11, Updated 2026-05-18, In
Progress) that audits the `endojs/endo` workspace dependency
graph and proposes a §sink-only-synthetic-test-package
factoring that breaks the 13-package SCC currently formed by
18 dev-dependency back-edges.

§The-key-observation: §the-cycle-is-all-in-devDependencies.
The `dependencies`-only subgraph has zero non-trivial SCCs.
A Tarjan SCC pass over the combined graph returns exactly one
13-package SCC.

§The-key-proposal: §sink-only-synthetic-test-packages — `@endo/
<subsystem>-test` packages that declare upstream subsystems via
regular `dependencies` and on which no other workspace package
depends. §Sink-only-is-the-load-bearing-constraint: a package
downstream of the SCC cannot extend the SCC.

§Five-cuts (Cut 1 SES, Cut 2 hex, Cut 3 zip-delete, Cut 4
harden, Cut 5 eventual-send) collapse the 18 edges into four
families. §Cuts-can-land-independently in any order;
recommended smallest-to-largest by diff size.

§The-§"illusion of an option" review-rejection language is
preserved verbatim: a proposed in-place rewrite of Cut 4
(`@endo/harden`) was rejected because the candidate shim
itself imports `'ses'`, so the edge would be renamed rather
than cut.

§Status: Cuts 2-5 shipped 2026-05-11 → 2026-05-14 (4-day
burst); Cut 1 open as PR #261. The design itself merged via
PR #206 on 2026-05-10.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `designs/break-dev-dependency-cycles.md` | 736 | The design being ingested |
| `packages/ses-test/` (Cut 1) | open | Largest synthetic package; PR #261 |
| `packages/hex-test/` (Cut 2) | shipped | PR #211; commit `68246ad92` 2026-05-12 |
| `packages/harden-test/` (Cut 4) | shipped | PR #210; commit `e56e9940d` 2026-05-13 |
| `packages/eventual-send-test/` (Cut 5) | shipped | PR #247; commit `c72d2a31f` 2026-05-14 |
| `packages/zip/` (Cut 3 — delete devDeps) | shipped | PR #209; commit `3ca283bf8` 2026-05-11 |
| `packages/stream-types-test/` | existed | The §existing-precedent the design generalizes |

## §Dependencies and lineage

- §Parent-design-of cycle 180 hex-package's §"@endo/hex-test
  (Cut 2 of break-dev-dependency-cycles) is also merged"
  sentence. Cycle 180 ratified this design's Cut 2.
- §Cites-PR-121 (`feat(ci): adopt turborepo for affected-set
  test runs`) as the motivation (`turbo.json.md` calls out
  this cycle as the reason for the in-package `dependsOn:
  ["build"]` form).
- §Cites-Issue-116 (`Frugal use of CI`; closed by PR #121).
- §Cites-vercel/turborepo-issues #675, #796, #9253 — closed
  feature requests for `dependencyTypes` traversal restriction
  that would have fixed the cycle from turbo's side.
- §Existing-precedent: `packages/stream-types-test/`.

## §Related sources in the library

- §Cycle 180 (`endo-but-for-bots--llm-designs-hex-package.md`)
  — §child-design that this design's Cut 2 ratifies. Cycle 180
  Status named PR #211 (Cut 2 landing).
- §Cycle 175 (`endo--packages-harden-make-selector-js.md`) —
  §package-namespaced-condition sibling to this design's
  `test-endo-foo` condition pattern. Both use §named-slots-
  instead-of-bare-generics.
- §Cycle 167 (`endo--packages-where-index-js.md`) — §when-in-
  Rome (per-platform naming) is the §duplication-preferred-
  over-indirection sibling at platform-naming scale.
- §Cycle 170 (`endo-but-for-bots--llm-designs-daemon-
  capability-filesystem.md`) — §map-to-existing-substrate-not-
  parallel-abstractions sibling.
- §Cycle 178 / 180 / 183 / 184 (the §honest-design-evolution
  family) — this design adds a §Resolved-Decisions section
  citing PR #206 review discussion per resolution, which is
  §review-iteration-archived-in-design.
- §Cycle 182 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-debugger.md`) — §three-option-architectural-decision
  sibling. Both reject options with named reasoning; cycle
  186's §"illusion of an option" is the sharpest rejection
  language in the corpus.

## §Comment fragments worth preserving

```
A package downstream of the SCC cannot extend the SCC; that
is what makes it a cycle break.
```

§The-load-bearing-property-named-explicitly. §A-one-line-
proof-sketch of the sink-only constraint.

```
"an illusion of an option"
```

§Kris's-review-phrase preserved verbatim. §The-substantive-
test: does the cycle-break candidate live outside the SCC?

```
"I'm fine with duplication where necessary to avoid a utils
package."
```

§Kris's-design-philosophy named: §duplication-preferred-over-
indirection-that-creates-cycles.

```
"I prefer this option on the grounds that the package and its
test package will be adjacent in the list."
```

§The-§alphabetical-adjacency-naming rationale named explicitly.
§Discoverability-as-naming-criterion.

```
The cycle is not strictly fatal for affected-set selection...
but the cosmetic noise on every CI log conflicts with the
project's silent-by-default diagnostic discipline, and the
per-task cache hash is weaker than it could be.
```

§Three-cited-costs-of-the-cycle. §The-§motivation-section
names what's-bad-about-the-status-quo.
