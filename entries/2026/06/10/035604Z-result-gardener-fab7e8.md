---
ts: 2026-06-10T03:56:04Z
kind: result
role: gardener
host: endolinbot
to: liaison
---

# Result: skills/model-selection landed (commit 83c229e1)

## Maintainer directive (2026-06-10)

> As the gardener, please direct each role to be dispatched with the
> best model fit for the job. That is, the model that is adequate to
> the task, for which any more advanced model would be wasteful.

## What landed

Commit `83c229e1` on `origin/main` (2 files, +158 / -4):

- **`skills/model-selection/SKILL.md`** (new) — the canonical
  per-role model assignment. Six tables covering 29 roles + 33 jurors
  (62 cells), grouped by *Orchestrators and meta-evolution*,
  *Judges*, *PR-creation chain*, *Per-task and curation roles*,
  *Standing watchers*, *Code-panel jurors*, *Design-panel jurors*.
  Each cell is one row with the tier and a one-line rationale.

  Tier criteria:
  - **Opus** — orchestrators, judges (aggregate many juror blocks),
    designer (authors at scale), gardener (meta-evolution), and
    five jurors whose lens carries hard-to-reverse downstream
    consequences (breaker, critic, saboteur, warden, skeptic).
  - **Sonnet** — substantive engineering / curation with bounded
    scope. The long tail; the default.
  - **Haiku** — roles whose dispatch body is dominated by
    deterministic substeps (cleaner, conductor, monitor,
    review-queue, timekeeper, three jurors: changeset-auditor,
    packager, fast-checker).

  Adequacy beats parsimony: when a role's typical engagement
  straddles tiers, the tier with reliable adequacy on the typical
  case wins. The shepherd's 2026-05-29 *"I'll wait for the next
  monitor tick"* incidents are the cited evidence that Haiku is not
  adequate for shepherd despite its mostly-mechanical surface;
  Sonnet is the right floor.

  Procedure: orchestrator reads the role's row, passes the model ID
  to `Agent`'s `model` parameter, records the choice in the
  dispatch entry's frontmatter (`model: opus | sonnet | haiku`).

  Overrides: maintainer or dispatch brief may name an explicit
  one-engagement override; the table stays canonical for subsequent
  dispatches. A judge may also lift a juror to Opus when the lens
  carries an unusually heavy case for one PR.

- **`CLAUDE.md`** § Dispatch contract: step 2 records the model
  tier in the dispatch entry's frontmatter; step 3 passes the model
  parameter from `skills/model-selection/SKILL.md`. Inventory
  list updated with `model-selection`.

Frontmatter `updated:` bumped to 2026-06-10 on CLAUDE.md.

## Design rationale: single table over per-role frontmatter

A per-role `model:` frontmatter field would mirror Claude Code's
standard agent-definition shape, but the garden has thirty-plus role
files and a Sonnet 5 (or analogous next-version) release would
require thirty-plus edits to retarget. A single skill-side table is
one diff to retarget every role at once. The trade-off: one extra
file the orchestrator reads at dispatch time, against deferred
maintenance cost on model revisions. The single-table shape wins.

## How the orchestrators consume this

The dispatch contract in CLAUDE.md now names the lookup as part of
step 3 (the `Agent` invocation). Liaisons and stewards already in
session will pick up the rule on their next dispatch after re-reading
the role file (the standing nudge-the-inbox shape lands a message in
the next batch if cycles do not naturally cycle through the role
file).

Driver lanes (the gardener and librarian lanes I landed 2026-06-04
plus future PR-work lanes per `designs/driver.md`) consult the
skill in the same place; the lane's role-classifier already uses
the dispatched role's name as the key.

## Out of scope

- **Sonnet 5 / Haiku 5 retargeting.** When a new Claude version
  lands, a separate gardener pass updates the model IDs in the
  table's *Tiers* section. The role-to-tier mapping stays stable;
  only the tier-to-ID mapping changes.
- **Per-host model overrides.** A future driver-container or
  dispatch-prompt mechanism could name a host-local override (e.g.,
  *"on the laptop, run everything on Sonnet because the Opus quota
  is low"*). Out of scope for this initial landing.
- **Audit of historical dispatches** for whether they used the
  right tier. The skill governs going-forward dispatches; past
  dispatches that used a different model are not retroactively
  flagged.

Self-improvement: `skills/model-selection/SKILL.md` (new),
`CLAUDE.md`; the model-selection axis now has a canonical source of
truth and the dispatch contract reads it at dispatch time. Ninth
gardener-actioned encoding this session.
