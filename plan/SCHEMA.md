# Plan schema (the contract)

The garden **plan** (the roadmap: milestones, the design index, statuses,
estimates, dependency edges, target dates) lives here, on `journal2`, under
`plan/`. The journal is the **single source of truth**, and within it the
**per-design files are the authoritative unit**. The roadmap view
(`plan/README.md`) is an **aggregation** of the per-design files — generated,
never hand-edited, never a second source of truth. Edit a design by editing its
file; the aggregate recomputes. See the design at `designs/plan-in-journal.md` on
`kriskowal/garden` (PR garden#4).

## Tree

```
plan/
  repositories.md                             repository-slug → repository-URL map
  designs/<repository-slug>/<design-slug>.md  one record per design (the source of truth)
  milestones/<id>.md                          milestone definition (goal, exit criterion, target, members)
  velocity.md                                 observed velocity inputs + the S/M/L/XL day mapping
  README.md                                   GENERATED aggregate roadmap; do not hand-edit
  SCHEMA.md                                   this file
```

## Record schema

Each `designs/<repository-slug>/<design-slug>.md` is one design: YAML-ish
frontmatter (the merge-friendly metadata) followed by the design narrative in the
body. One design per file, so two gardeners editing different designs never
collide on the board.

```yaml
---
slug: daemon-supervisor          # REQUIRED. kebab-case; unique across the whole plan; matches the file name.
repository: endo-but-for-bots    # REQUIRED. a repository slug defined in repositories.md.
status: In Progress              # REQUIRED. one of the enum below.
size: M                          # optional. S | M | L | XL.
milestone: M2                    # optional. references milestones/<id>.md.
depends_on: [daemon-vat]         # optional. design slugs, resolved across ALL repositories.
pr: endo-but-for-bots#246        # optional. implementing PR(s): <repo-slug>#N, owner/name#N, or a pull URL.
target: 2026-07-15               # optional. explicit target date; otherwise projected.
created: 2026-06-01              # date the design was created.
updated: 2026-06-24              # date the record was last touched.
---

The full design narrative lives here, in the journal.
```

### Status enum (carried verbatim from the endo v1 plan)

`Not Started`, `Proposed`, `In Progress`, `Draft`, `Complete`, `Active`,
`Reference`, `Deprecated`, `Superseded`. (`Implemented` is normalized to
`Complete` on import.) `Complete`, `Active`, and `Reference` count as done in the
rollups.

## Cross-repository model

A design **targets exactly one repository** (the `repository` field). A
**project** is a higher-level effort that may **span repositories**, expressed
through milestone membership and `depends_on` edges that cross repository
boundaries — not through the per-design field. `depends_on` slugs are resolved
across the whole record set, so an edge from one repository's design to another's
is just two records and one edge. Aggregate computation (milestone totals,
completion, the critical path) is over the **union** of all records.

`repositories.md` maps a slug to a **repository URL** (not a GitHub `owner/name`
pair), so the model stays open to repositories that are **not** on GitHub.
GitHub-specific affordances (PR links, merge detection) key off the resolved URL
being a GitHub URL.

**`agoric-sdk` is excluded unconditionally.** The validator rejects any record
whose `repository` resolves to the agoric-sdk repository, and the renderer never
emits an agoric-sdk row.

## Tooling (lives on `main2`)

- `scripts/jobs/plan/validate.sh` — schema + uniqueness + agoric-sdk-exclusion gate.
- `scripts/jobs/plan/render.sh` — aggregate the records into `plan/README.md`.
- `scripts/jobs/plan/reconcile.sh` — advance `status`/`pr` against actual PR + board state.
- `scripts/jobs/plan/import-endo.sh` — the one-time endo v1 import.

Rendering rides on the bulletin loop (`scripts/jobs/bulletin.sh`); status
reconciliation and the weekly velocity/projection/grooming pass run on the
Sunday-evening schedule (`journal/schedules/plan-recalibrate.md`). There is no new
plan-updating role and no new standalone service.
