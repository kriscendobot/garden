# design(plan-in-journal): the plan as cross-repo garden journal state

| Created  | 2026-06-24 |
| Revised  | 2026-06-25 |
| Author   | designer (gardener fleet) |
| Status   | Proposed   |

> Revised 2026-06-25 to fold in kriskowal's review on
> [garden#4](https://github.com/kriskowal/garden/pull/4). The six decisions: the
> plan moves fully into the garden journal (records and narrative), journal2 is the
> single source of truth, a reconciler keeps the plan current, that reconciliation
> consolidates into the bulletin generator and journalist rather than a new role or
> service, review-queue latency stays a single garden-wide metric, and each project
> is named by a short kebab-case slug that maps to a repository URL (GitHub or not).

## Summary

Move the **plan** (the roadmap: milestones, the design index, statuses, estimates,
dependency edges, target dates) out of the single endo fork and **fully** into the
garden's own `journal2` state, re-architect it to span **multiple repositories**, and
replace the hand-enforced README synchronization discipline with **idiomatic garden
automation** (a reconciler that rides on the existing bulletin generator and
journalist loops over journal2). The plan becomes garden-level state because the
garden now operates at garden scope, not endo scope.

The plan lives in one place. Both the **plan metadata** (status, size, dependencies,
milestone, target date, project) and the **design narrative** (the prose of each
design) move into `journal2`. The maintainer's directive is to move it all into the
journal to avoid a coordination problem: keeping metadata in journal state while the
narrative lived on per-repo fork branches meant two homes that had to be kept in
sync across repositories. One home, one source of truth, one recomputed view, no
manual sync.

## Problem

Today the plan lives at `designs/README.md` on the `endojs/endo-but-for-bots:llm`
branch: a hand-maintained table of roughly 104 designs (a status enum, six
milestones M0 through M6 with exit criteria and target dates, a Mermaid dependency
graph, and a velocity-calibrated S/M/L/XL estimate table). The process that keeps it
correct is documented in the endo `designs/CLAUDE.md`: every modification to any
design (especially its metadata) must be reflected by hand in the README summary
table, the milestone totals, the dependency graph, and the estimates. Three problems
follow:

1. **Single-repo residence.** A garden-level milestone cannot span repositories. The
   table, the subsystem prefixes (`daemon-`, `chat-`, `ocapn-`, and so on), and the
   milestone narratives are all endo-specific, so work the garden does in the garden
   repo itself or in `endojs/endo` has no place on the plan.
2. **Manual synchronization is brittle.** The sync discipline is the human-enforced
   core: a metadata edit that forgets to update the table, the totals, the graph, or
   the estimates silently desynchronizes the plan from reality. This is exactly the
   kind of mechanical bookkeeping the garden's job-board automation exists to take
   over.
3. **Garden infrastructure is coupled to one fork's branch.** The journalist, the
   bulletin's roadmap sections, the foreman, and the prior design-poller all read an
   endo-resident file on the `llm` branch. The garden's own coordination layer should
   read garden-local state, not reach into a fork to learn its own roadmap.

## What is generalizable, what is endo-specific

Reusing the synthesis the liaison already performed: the **endo-specific** parts are
the `llm` branch, the package layout, the subsystem prefixes, and the endo
technology in the milestone narratives. The **generalizable** parts (which this
design lifts to garden scope) are the metadata format, the status enum, the
dependency-graph concept, the velocity-calibrated estimate model, milestone binning
by exit criterion, and the synchronization discipline itself. The plan carries the
generalizable parts. The endo-specific subsystem prefixes survive only as slugs on
the records that target endo, not as structure the garden imposes everywhere.

## Proposed representation: the plan as `journal/plan/` state

The plan lives under a new `journal/plan/` tree on the `journal2` branch, alongside
the existing `jobs/`, `inbox/`, `repos/`, and `projects/` state. The **journal is the
single source of truth**: there is no authoritative per-repo copy of any part of the
plan. The per-design records are the source of truth for metadata, the per-design
narrative is the source of truth for prose, and the rendered roadmap is generated and
must not be hand-edited.

```
journal/plan/
  projects.md                              the project-slug to repository-URL mapping (see Cross-repository model)
  designs/<project-slug>/<design-slug>.md  one record per design: metadata frontmatter + the design narrative below it
  milestones/<id>.md                       milestone definition: exit criteria, target date, members
  velocity.md                              observed PR-merge velocity inputs and the S/M/L/XL day-mapping
  README.md                                GENERATED roadmap view (table + dep graph + estimates); do not hand-edit
```

A design record is small in metadata and self-contained: the frontmatter is the
merge-friendly part (one file per design, so two gardeners editing different designs
never collide on the board), and the narrative prose lives in the body of the same
file, in the journal, not on a fork branch.

```yaml
---
slug: daemon-supervisor
project: endo-but-for-bots                     # project slug; projects.md maps it to a repository URL
status: in-progress                            # the v1 enum, carried verbatim
size: M                                         # S | M | L | XL
milestone: M2
depends_on: [daemon-vat, ocapn-handoff]        # design slugs, resolved across all projects
pr: endo-but-for-bots#246                       # the implementing PR(s) when known, by project slug
target: 2026-07-15                             # optional explicit target; otherwise projected
created: 2026-06-01
updated: 2026-06-24
---

The full design narrative lives here, in the journal. This is the prose that used to
live on a fork's `designs/` branch. It moves into journal2 so the plan has a single
home and there is no per-repo copy to keep in sync.
```

Moving the narrative into the journal is the coordination-avoiding move the
maintainer directed. The earlier draft kept narrative in each home repository and
referenced it by a pointer, on the theory that prose is repo-coupled and heavy. In
practice that split created the coordination problem this design exists to remove: a
metadata edit in journal2 and a narrative edit on a fork branch are two writes in two
repositories that must agree. With both in journal2, a single record (frontmatter
plus prose) is one merge-friendly file, reviewed in one place, with one source of
truth. The endo subsystem coupling that the prose carries is just text in a journal
file; it does not constrain garden state.

The status enum is carried verbatim from v1: Not Started, Proposed, In Progress,
Draft, Complete (Implemented), Active, Reference, Deprecated, Superseded.

## Cross-repository model

The garden develops in several repositories. The plan is cross-repo in that each
design **targets** a project that maps to a repository, while every part of the plan
itself (records, narrative, milestones, the generated view) lives in journal2.

- **Projects are named by a short slug.** Each design's `project` field is a short
  kebab-case slug (`endo-but-for-bots`, `garden`, `endo`). Slugs are deliberately
  lightweight and adaptable: a kebab-case variation can be introduced later without a
  schema migration.
- **`projects.md` maps slug to repository URL.** A single mapping file records, for
  each project slug, the repository URL it targets. The plan tracks **repository
  URLs**, not GitHub `owner/name` pairs, so the model stays open to **repositories
  that are not on GitHub** (a self-hosted git remote, a non-GitHub forge). Nothing in
  the record schema or the renderer assumes a GitHub host. Where a GitHub-specific
  affordance is needed (PR links, merge detection), it keys off the resolved URL
  being a GitHub URL rather than assuming it for every project.
- **Dependency edges cross projects.** `depends_on` lists design slugs; the renderer
  resolves each slug to its record across the whole record set, so an edge from an
  endo-but-for-bots design to an endo design is just two records and one edge. Slugs
  are unique across the plan (the validator enforces uniqueness).
- **Aggregate computation is over the union.** Milestone totals, completion
  percentage, estimate rollups, and the critical path are computed across all records,
  not per project. The critical path follows `depends_on` across project boundaries.
- **Scope is bounded.** The allowed project set is the repositories the garden
  actively develops: the garden itself, `endojs/endo`, `endojs/endo-but-for-bots`, and
  others the maintainer adds to `projects.md`. **`agoric-sdk` is excluded
  unconditionally** ("we must not and cannot do anything for agoric-sdk"): the
  validator rejects a record whose `project` resolves to the agoric-sdk repository,
  and the renderer never emits an agoric-sdk row.

```mermaid
flowchart LR
  subgraph records["journal/plan/ (single source of truth in journal2)"]
    A["endo-but-for-bots / daemon-supervisor (M2)"]
    B["endo / ocapn-handoff (M2)"]
    C["garden / plan-in-journal (M-infra)"]
    M["projects.md (slug to repo URL)"]
  end
  A -- depends_on --> B
  records --> R["roadmap reconciler (folded into bulletin + journalist)"]
  R --> V["journal/plan/README.md (generated view)"]
  V --> J["journalist"]
  V --> BU["bulletin roadmap sections"]
  records --> F["foreman (next-step planner)"]
```

## The process as garden automation

The endo `designs/CLAUDE.md` process maps onto garden machinery one step at a time.
There is **no new plan-updating role and no new standalone service**. Per the
maintainer's directive, plan reconciliation and rendering **consolidate into the
bulletin generator** (`scripts/jobs/bulletin.sh`) and the **journalist**, which
already run continuously over `journal2`. The bulletin loop's shape is exactly right
for this: a durable cursor over `origin/journal2`, a deterministic recompute, a
change-gated CAS push, and multi-host idempotence. The plan view is one more
journal-local rendered artifact that loop produces, and keeping the plan current is
one more reconciliation it performs.

| `designs/CLAUDE.md` process step | Garden mechanism |
|---|---|
| Per-doc metadata table required on every design | **Plan validator** (a pre-push gate plus a job posted on plan change): validates each record's frontmatter against the schema, rejects missing or unknown fields, rejects an unknown status, enforces slug uniqueness, and rejects a project that resolves to agoric-sdk. Reuses [`skills/pre-push-gates`](../skills/pre-push-gates/SKILL.md). |
| Sync every metadata edit into the README table | **Reconciler in the bulletin generator**: the bulletin loop regenerates `journal/plan/README.md` from the records whenever the plan changes. This replaces the manual sync; the view is recomputed, never hand-edited. No separate `garden-roadmap-renderer` service is introduced. |
| Milestone totals and exit criteria | The reconciler aggregates membership and totals; a milestone-rollup step recomputes per-milestone size totals and completion percentage. |
| Dependency graph | The reconciler emits the Mermaid graph; a cycle-and-dangling-edge check runs via [`skills/dependency-graph-maintenance`](../skills/dependency-graph-maintenance/SKILL.md) and surfaces a violation as a maintainer note rather than a silent bad graph. |
| Velocity-calibrated estimates | **Velocity recalibration** ([`skills/velocity-recalibration`](../skills/velocity-recalibration/SKILL.md)) observes merged-PR cadence from board `tada` completions plus merge timestamps, recomputes the S/M/L/XL day-mapping into `velocity.md`, and **roadmap projection** ([`skills/roadmap-projection`](../skills/roadmap-projection/SKILL.md)) reprojects milestone target dates. **Review-queue latency is a single garden-wide timeline input**, not per-project: one latency figure feeds every projection regardless of which repository a milestone's designs target. |
| Status drift (record says Complete, PR unmerged, or the reverse) | **The reconciler takes responsibility for updating the plan.** Riding on the bulletin and journalist loops (which already observe completions), it compares each record's `status` and `pr` against actual PR and board state and advances the status, with an audit `entry`. Design authors do not hand-sync a summary table; the reconciler keeps the plan current. |
| Design lifecycle (proposal to complete) | Board-event-driven transitions the reconciler applies: a design PR opening sets Proposed or Draft; a detected merge sets Complete; the reconciler advances the record. The lifecycle is data the reconciler maintains, not a human checklist. |

### Connection to the in-flight machinery

This proposal is coherent with the services landed in this session only if each plan
consumer is re-pointed at the journal-local plan. The cutover points:

- **journalist** ([`roles/journalist`](../roles/journalist/AGENT.md)) bins PRs into
  milestones for the bulletin, and now also hosts plan reconciliation. Today it reads
  the endo `designs/README.md` Per-Design Estimates table. **Cutover:** it bins and
  reconciles against `journal/plan/` (the records plus the generated view), which
  removes its cross-repo fetch of the `llm` branch and lets it bin work from any plan
  project.
- **bulletin roadmap sections** (`scripts/jobs/bulletin.sh`) render milestone-binned
  sections and now also regenerate `journal/plan/README.md`. **Cutover:** render from
  `journal/plan/`, which is journal-local, so the bulletin stops reaching into a fork
  for its own roadmap.
- **foreman** ([`roles/foreman`](../roles/foreman/AGENT.md), `scripts/jobs/foreman.sh`)
  is the idle-pump that posts the next unblocked step of the current in-progress
  milestone. Today it reads `designs/README.md` on `llm` to find the current milestone
  and next step. **Cutover:** read `journal/plan/milestones/` and the records, pick the
  current milestone and the next unblocked step from the journal-local plan and the
  `depends_on` edges. The foreman gains cross-project sequencing for free and loses its
  fork fetch.
- **design-poller / design-to-pr-pipeline** walked the `llm` roadmap branch for
  designs ready to build. **Cutover:** the readiness query becomes a plan query: a
  record with status Proposed or Accepted and an unblocked `depends_on` set is
  ready-to-build. The poller (or the foreman) reads the records; the cross-project edge
  resolution is the same machinery the reconciler uses.

## Migration path

Incremental, with a named cutover point per consumer so the journalist, the bulletin,
and the foreman keep working mid-flight. Journal2 becomes the single source of truth
as soon as the records render faithfully; the endo file degrades to a generated,
non-authoritative redirect and then retires.

```mermaid
flowchart TD
  P0["Phase 0: schema + reconciler in the bulletin loop + one-time import; plan SHADOWS endo README"]
  P1["Phase 1: journal2 becomes the single source of truth; endo README becomes a generated redirect"]
  P2["Phase 2: cut over consumers one at a time (bulletin, journalist, foreman, poller)"]
  P3["Phase 3: cross-repo activation (garden + endo records; spanning milestones)"]
  P4["Phase 4: retire the manual sync discipline and the endo redirect"]
  P0 --> P1 --> P2 --> P3 --> P4
```

- **Phase 0: schema, reconciler, shadow import.** Land the `journal/plan/` schema, the
  validator, the `projects.md` mapping, and the reconciler step inside the bulletin
  loop. A one-time import reads the current `endojs/endo-but-for-bots:llm`
  `designs/README.md` table into per-design records, and pulls each design's narrative
  from its fork `designs/` file into the record body. The generated
  `journal/plan/README.md` is diffed against the live endo table for fidelity. The
  endo file stays the live source only until the shadow renders faithfully.
- **Phase 1: journal2 is the single source of truth.** Once the shadow renders
  faithfully, declare the journal records and narrative the sole source of truth.
  Generate a copy of the table back into the endo `designs/README.md` as a
  **non-authoritative redirect** (a courtesy for any human still reading there, with a
  pointer to `journal/plan/`). It is generated output, not a second source of truth.
- **Phase 2: cut over consumers, one at a time.** Order by risk, lowest first:
  1. **bulletin** (read-only of the view, already journal-local): point its roadmap
     sections at `journal/plan/README.md`.
  2. **journalist**: bin and reconcile against the records.
  3. **foreman**: read `journal/plan/milestones/` and the records.
  4. **design-poller**: query records for ready-to-build.
  Each consumer's cutover is one commit; until it lands, that consumer reads the
  redirect copy of the endo file.
- **Phase 3: cross-repo activation.** Add records (with narrative) for garden-itself
  designs and endo designs; populate `projects.md`; let milestones span projects; turn
  on cross-project critical-path computation; confirm the agoric-sdk exclusion in the
  validator.
- **Phase 4: retire the manual discipline.** Replace the synchronization section of
  the endo `designs/CLAUDE.md` with a pointer to `journal/plan/` and the reconciler.
  Endo `designs/` narrative is now mirrored from the journal record bodies; the
  Phase 1 redirect can stop once no human relies on it.

## Decisions folded in (kriskowal review, garden#4, 2026-06-25)

- **Plan fully in the journal.** Both metadata and narrative live in `journal2`. The
  earlier narrative-stays-home split is removed because it recreated the coordination
  problem this design exists to remove.
- **Journal2 is the single source of truth.** No authoritative per-repo copy. The endo
  README becomes a generated, non-authoritative redirect and then retires.
- **The reconciler updates the plan.** Status, lifecycle, and the view stay current via
  a reconciler, not via design authors hand-syncing a summary table.
- **Reconciler consolidates into the bulletin generator and journalist.** No new
  plan-updating role and no standalone `garden-roadmap-renderer` service; the work
  rides the loops already running over `journal2`.
- **Review-queue latency is garden-wide.** One latency metric feeds every projection;
  no per-project granularity.
- **Slug to repository-URL mapping, non-GitHub allowed.** Projects are named by a
  short kebab-case slug; `projects.md` maps each slug to a repository URL; the model
  does not assume GitHub.

## Open questions

- Source-of-truth granularity within the journal: per-design record files (proposed,
  for board merge-friendliness) versus one structured plan file. The proposal keeps
  per-design files; is that the maintainer's preference?
- Should the Complete transition be fully automatic on a detected merge, or should the
  reconciler hold Complete behind a maintainer gate? (The reconciler owns the update
  either way; the question is whether the final flip is gated.)
- Does the Phase 1 endo `designs/README.md` redirect get removed in Phase 4, or kept
  indefinitely as a courtesy pointer for human readers?
- Field naming: is `project` the right field name (versus `repository`), now that the
  value is a slug resolved through `projects.md` rather than an inline `owner/name`?
