---
created: 2026-09-04
updated: 2026-09-05
author: designer, gardener
---

# Formalizing the groom role

`groom` is a v1 role the maintainer asked to be captured formally in v2. This
document records what grooming actually is, why it lands as a directly-postable
role rather than an improvised job convention, how its four v1 skills translate,
and the two forward-commitment questions left for the maintainer. The normative brief
is [`roles/groom/AGENT.md`](../roles/groom/AGENT.md); this is its reasoning.

## The problem: a live verb with no owner

The v1-migration manifest recorded `groom` as *"`references/`-adopted
roadmap-maintenance role; reference-shelf; roadmap upkeep is a posted job if
revived"* — implying a materialized reference-shelf file. That claim is **stale**:
no `groom.md` exists under `references/endo-but-for-bots/roles/` (only chronicler,
juror, marshal, namer, scribe, stratego, triager are present), and its four
associated skills — `velocity-recalibration`, `roadmap-projection`,
`dependency-graph-maintenance`, `groom-open-questions` — were manifest stubs, never
files.

Yet the *verb* is doing real, un-owned work today. The journal's completed-job log
carries `groom-endo-designs-readme`, `groom-refine-endo-roadmap`,
`groom-endo-stale-design-docs`, `groom-parked-job-queue-*`,
`ebfb-llm-designs-groom-*` — all improvised, basename-convention-only, with no role
brief behind them. Two of those passes teach opposite lessons:

- `groom-endo-designs-readme` (2026-08-17) is the model of a **full pass done
  right**: it fanned six subagents across all ~185 status rows against 402 merged +
  309 open PRs, corrected ~34 drifted rows with a citation-backed drift table,
  recounted totals, grounded velocity in real fleet cadence, archived the
  fully-complete Milestone 1 into a new `ARCHIVE.md`, and landed as **draft PR
  #1023** on the fork. It cost ~$12 and ~16 minutes on Opus — this is designer-tier
  judgment work, not a mechanical script.
- `groom-refine-endo-roadmap` (2026-07-02) is the **cautionary lane-mismatch**: with
  no role brief telling it where the ledger lives, it landed a *parallel* roadmap
  reconciliation in the journal `projects/` tree instead of a fork PR — a second,
  diverging roadmap the fork never saw. Its own completion report flagged the gap
  and asked for exactly this formalization.

The "the improvised jobs already run successfully without a role" premise is therefore
only half true: they run, but without a brief one of them silently diverged.

## What grooming maintains

The concrete target is `designs/README.md` on `endojs/endo-but-for-bots`' `llm`
branch — a ~2000-line living, ranked roadmap with a fixed shape:

- `## Roadmap` -> `### Milestones` (M1...M11), each with a goal, a
  `| Design | Status | Notes |` table, an exit criterion, and actual/estimated
  duration. **Milestones are numbered in approach order: M1 first, M11 last; each
  milestone's dependencies all live in earlier milestones** — the numbering
  *encodes* the dependency ordering, an invariant enforced since the 2026-06-03
  renumbering (maintainer directive on PR #400).
- `### Strategic Early Items` — designs pulled ahead of their natural milestone
  because they are foundational (currently `endo-reminder`, `endo-fetch`, both into
  M3).
- `### Execution lead`, `### Unattended design routing`, `### Dependency Graph`
  (mermaid), `### Size and Time Estimates`, `### Timeline`, and a single
  current-totals block at the top.
- An explicit convention inside the doc: *record each grooming pass by appending its
  note to `ARCHIVE.md`; do not layer new groom notes at the top of this file.*

This is the per-project analogue of the garden's own `journal/plan/` + `velocity.md`
recalibration (README § Planning): "a weekly recalibration job re-fits velocity to
what actually shipped, reprojects the roadmap, and grooms the records." Same shape,
different repo.

## Decision: a directly-postable role, not a basename convention

Groom lands as a first-class role in `roles/groom/AGENT.md` and is added to the
CLAUDE.md § Current inventory roles list. The case:

1. **It carries operating norms no existing role owns.** The M1->M11 dependency-
   encoding invariant, the ARCHIVE.md append-don't-prepend split, the Strategic
   Early Items carve-out, velocity re-fit against measured cadence, and the
   fork-PR-not-journal-snapshot lane are all specific, load-bearing, and easy to get
   wrong (one pass already did). A role brief is where such norms live; a basename
   cannot carry them.
2. **The lane-mismatch is exactly the failure a brief prevents.** The divergent
   journal-roadmap incident happened *because* there was no brief saying where the
   ledger is. Encoding the two-surface discipline (edit the fork file, land a draft
   PR) removes the class.
3. **It is recurring and schedulable.** Grooming has a natural weekly-ish cadence
   (README § Planning). A role + the [schedule](../skills/schedule/SKILL.md) skill is
   the v2 idiom for standing cadence; a role gives the scheduler a stable target.
4. **The work is heavy and judgment-bearing.** A full pass is designer-tier
   ($12/Opus, six-way fan-out). Roles are how the fleet routes tier and effort.

The counter-argument — "researcher or gardener could wear a groom hat" — fails
because grooming's deliverable is a *fork-side PR against a ranked ledger with a
dependency-encoding invariant*, which is neither the researcher's journal-only
refinement nor a generic gardener task. It is closest to `designer` (it lands a
draft PR on the fork and reasons about the same `designs/` corpus), and the brief
leans on the designer's own PR-and-frozen-base machinery rather than reinventing it.

## Decision: materialize all four capabilities as dedicated skills

The maintainer resolved the skill-shape question in review: fold all four named v1
capabilities into the active garden as dedicated, self-contained skills. They never
existed as v1 files, so the builder derives their contracts from the responsibilities
below rather than translating text verbatim. The skills divide one groom pass into
four independently citeable operations while composing the narrower v2 substrate
that already exists:

| Dedicated skill | Responsibility and boundary |
|---|---|
| `velocity-recalibration` | Select an explicit evidence window, measure completed work and elapsed delivery time in the roadmap's existing size units, identify the binding delivery constraint, and produce a sustainable velocity estimate with its evidence and uncertainty. It owns the rate input, not milestone dates. It runs during a full pass, not a targeted status correction. |
| `roadmap-projection` | Consume remaining work, the recalibrated velocity range, and dependency constraints to recompute milestone windows, the aggregate timeline, and the assumptions that make them auditable. It preserves actual dates, distinguishes estimates from commitments, and does not hide uncertainty behind a single invented date. |
| `dependency-graph-maintenance` | Reconcile design-declared and PR-declared edges into the roadmap's canonical acyclic graph; report missing targets and cycles; keep milestone numbering dependency-valid; preserve Strategic Early Items as an explicit sequencing carve-out; update the mermaid view and validate it. The existing [design-dependency-walk](../skills/design-dependency-walk/SKILL.md), [pr-dependency-graph](../skills/pr-dependency-graph/SKILL.md), [pr-dependency-topo-sort](../skills/pr-dependency-topo-sort/SKILL.md), and [mermaid-validation](../skills/mermaid-validation/SKILL.md) remain its substrate. |
| `groom-open-questions` | Collect uncertainties exposed by status, velocity, projection, and graph work; close questions that current evidence answers; and route genuine policy, scope, or resequencing choices to the maintainer with alternatives, consequences, and affected roadmap sections. It owns a reviewable question ledger, not the authority to choose silently. It composes the designer's open-question discipline and [message-bus](../skills/message-bus/SKILL.md) for escalation. |

The four contracts are separate because each has a stable input and output that
other roles can cite. They remain coordinated by `groom`: status evidence feeds
velocity, velocity and dependency order feed projection, and unresolved decisions
from every stage feed the open-question ledger. A dedicated skill may reference
an existing lower-level skill, but must not copy that skill's procedure.

### Builder acceptance criteria

The serial builder that follows this accepted design must:

1. Materialize `skills/velocity-recalibration/SKILL.md`,
   `skills/roadmap-projection/SKILL.md`,
   `skills/dependency-graph-maintenance/SKILL.md`, and
   `skills/groom-open-questions/SKILL.md` as self-contained contracts with the
   garden's standard frontmatter, purpose, inputs, procedure, output shape, state
   where needed, composition links, and notes.
2. Encode the responsibility and boundary in the table above. In particular,
   preserve evidence provenance and uncertainty, enforce acyclic dependency order,
   validate changed mermaid graphs, and escalate maintainer choices instead of
   silently resolving them.
3. Make [`roles/groom/AGENT.md`](../roles/groom/AGENT.md) consume all four skills
   directly, while retaining the lower-level verification, scheduling, PR, and
   communication skills that the role still needs.
4. Reconcile [`designs/v1-migration-manifest.md`](v1-migration-manifest.md) and the
   garden skill inventory so no active surface still calls the four capabilities
   folded, covered, absent, or manifest-only stubs.
5. Leave the model-routing and project-versus-garden scope questions below open.
   The skill implementation does not authorize a fleet-spend decision or a scope
   expansion.
6. Run the applicable garden pre-push and local-verification gates, plus a
   repository-wide reference scan proving all four role links resolve and the
   superseded disposition language is gone.

## The two-surface lane, stated once

A v2 gardener job can edit the journal freely but a *project* ledger lives on a
fork. The discipline the brief encodes:

1. Get an isolated project worktree (`ensure-project-worktree.sh <base>
   <owner/repo> <branch>`).
2. Edit `designs/README.md` (and `ARCHIVE.md`) there.
3. Open a **draft PR** against the roadmap branch (or a frozen base where none
   exists) — the designer convention, whose review thread is the interactive
   surface for any milestone resequencing.

A journal reconciliation snapshot is at most a scratch step feeding that PR, never
the deliverable. This is the durable fix for the 2026-07-02 divergence.

## Open questions

- **Should `groom` be pinned in the fleet's per-role model policy
  (`role_default_model` / `role_tier_floor` / `role_default_effort` in
  `scripts/jobs/common.sh`, and the [model-selection](../skills/model-selection/SKILL.md)
  table), and if so at what tier?** A full groom pass is designer-tier judgment work
  ($12/Opus/high-effort in practice), which argues for the `designer`/`builder`
  treatment: floor at `mentor`, default to latest Opus, `high` effort. Today groom
  jobs post with an explicit `tier:` and run fine, so this is a safety-net/spend
  decision, not a blocker — but it commits fleet cost policy and touches dispatch
  code a design job should not change unilaterally. Recommendation: pin
  `groom` at the designer floor (`mentor`, Opus, high) as a small follow-up code
  change once the maintainer confirms the spend.
- **Is groom scoped to project roadmaps only, or does it also formally own the
  garden's own `journal/plan/` + `velocity.md` recalibration** (README § Planning),
  which some improvised passes touched (`groom-parked-job-queue-*`)? This design scopes
  the brief to "any ranked roadmap, project or garden-own" and leans the garden-own
  case on the existing planning machinery, but does not claim that machinery for the
  role; the maintainer may want an explicit boundary.

## Follow-ups

- Materialize the four dedicated skill files and reconcile the four stale skill
  rows in [`designs/v1-migration-manifest.md`](v1-migration-manifest.md), the role,
  and the inventory per the builder acceptance criteria above. The role row itself
  is already corrected and points here rather than implying a reference-shelf file
  exists.
- If the maintainer answers the model-tier open question affirmatively, a one-line
  pin per role in `role_default_model`/`role_tier_floor`/`role_default_effort` plus a
  `model-selection` table row.
