# Bulletin: display the jobs/plan/ queue (parked plan jobs) — "## Plan queue" section

Wear the **mentor** role. The bulletin does NOT surface the **`jobs/plan/` category** (the
parked plan jobs gated on maintainer go-ahead or deferred by priority). The maintainer wants
it displayed. Add a deterministic **"## Plan queue"** section to `scripts/jobs/bulletin.sh`.
Infrastructure on `main2` (bot identity; isolated worktree off `origin/main2`; redeploy the
bulletin loop).

## Disambiguate (important)

There are two "plan" things — do NOT conflate them:
- The **design/roadmap plan** under `journal/plan/designs/**` (the plan-in-journal roadmap),
  which `bulletin.sh`'s existing `render_plan`/`roadmap_index` handles. Leave that alone.
- The **`jobs/plan/` board category** (`add-plan-job-category`): parked plan JOBS that
  gardeners never claim, gated `go-ahead` (need maintainer authorization) or `deferred`
  (selected by priority). **This is what to display.**

## The section

Add **"## Plan queue"** to the bulletin (a high-value human section — what is parked and what
needs your go-ahead). Read `jobs/plan/*.md`; for each, parse the frontmatter (`gate`,
`urgency`/`priority`, optional roadmap) and a one-line description (the first heading), and
render two groups:
- **Awaiting go-ahead** — the `gate: go-ahead` jobs (these need maintainer authorization to
  run): `` - `<base>` — <description> `` ; lead with these (they need a human).
- **Deferred (by priority)** — the `gate: deferred` jobs, sorted by priority/urgency:
  `` - `<base>` — <description> (priority <p>) `` .
Show counts; "(none)" when empty. Place it near the top human-attention sections (e.g. after
"Parked for maintainer feedback", before the Board). Deterministic — no claude; reading the
plan files' frontmatter + first line is cheap. Preserve the idempotent change-compare (the
plan section is deterministic given its inputs) and graceful behavior.

## Redeploy & verify

Restart `garden-bulletin.service` (non-blocking) so the loop picks it up; confirm a tick
renders "## Plan queue" in `journal/README.md` listing the four currently-parked plans
(classify-lint-endo-master, ingest-ocap-library-sections, investigate-resumable-gardeners,
investigate-systemd-run-vs-gardener-loops — all gate=deferred). If you cannot restart from a
dispatch worktree, flag the restart as a pending deploy step.

## Tests

Fixture: a `go-ahead` plan and a `deferred` plan → the section lists each under the right group
with description + priority; an empty `jobs/plan/` → "(none)"; the section does not disturb the
design-plan `render_plan`. `shellcheck`/`bash -n` clean.

## Definition of done

The bulletin renders a "## Plan queue" section listing the `jobs/plan/` parked jobs (go-ahead
awaiting authorization + deferred by priority, with descriptions), distinct from the design-plan
render, committed/pushed to `origin/main2`, redeployed, a tick confirmed to show it. Report the
SHA and a sample rendering.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 66
  claimed_at: 2026-06-25T21:21:49Z
