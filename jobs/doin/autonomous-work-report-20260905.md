---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Produce a clip report inventorying the garden's currently-planned and in-progress
work that will keep moving **automatically, with no maintainer action required**,
and publish it via `skills/minion-town-clip-publishing/SKILL.md`. This is the
mirror image of `pr-review-sequence.md`'s "Awaiting your decision" section — that
document tracks what's stuck on a maintainer call; this one tracks what is NOT
stuck, i.e. what proceeds on its own.

**Survey the live `journal2` board** (`journal/jobs/`) and be precise about WHY
each bucket is or isn't autonomous:

- **`jobs/todo/`** — posted and claimable right now by any eligible gardener.
  Autonomous by construction.
- **`jobs/doing/`** — actively running. List what's in flight and on which host
  where that's cheap to determine.
- **`jobs/plan/` broken out by gate** (read each parked job's frontmatter `gate:`):
  - `orchestrated` — promoted automatically by the deterministic `orchestrate.sh`
    watcher per its owning orchestration record (`jobs/orch/*.md`). List each live
    orchestration (serial/parallel, its children, and which child is currently
    active/pending) — these ARE autonomous.
  - `blocked` — promoted automatically by `unblock.sh` once the named blocker
    resolves. List each with its `blocked-on` target — autonomous, contingent on
    that external event.
  - `budget-hold` — promoted automatically by `budget-refresh.sh` once the named
    quota window resets. List each with its `budget-resets-at` — autonomous,
    contingent on the reset landing.
  - `deferred` — the default park state. These do **NOT** proceed on their own;
    they need an explicit maintainer promotion (`promote-plan.sh` / "go ahead").
    Count them but do not present them as part of the autonomous set — flag them
    as the explicit contrast case, the way pr-review-sequence.md's "Awaiting your
    decision" does.
- **`journal/schedules/*.md`** — recurring jobs the sole `garden-scheduler`
  dispatches on cadence regardless of the foreman. List each with its cadence and
  next-due time; these keep firing autonomously independent of everything else on
  this list.

**Be explicit about the foreman brake.** `config/foreman-brake` is currently SET
(re-engaged 2026-09-04T11:53:36Z, "this host resumed leadership but should not
autonomously pump work"). The foreman is the ONLY thing this brake stops — it
means `deferred` plan jobs get no new autonomous promotions and no new milestone
steps get generated, but it does NOT touch `orchestrated`/`blocked`/`budget-hold`
promotion (those run on their own deterministic watchers, not the foreman) and
does NOT touch schedule dispatch or todo/doing claiming. Make this distinction
visually clear in the report: "autonomous today, brake or no brake" vs. "would
need the foreman, currently braked" vs. "needs an explicit maintainer go-ahead
regardless of the brake."

**Format:** tables/counts over prose where the data supports it (this report
follows the same "substantiate the claim" bar as the just-published budget-
calibration chart report — don't just assert "N jobs are autonomous," show the
breakdown). Clip CSP is same-origin only (`script-src`/`style-src`/`connect-src
'self'`, `img-src 'self' data:` — no CDN); inline SVG or same-origin JS/CSS only.
Report the published clip URL in your tada report.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-05T03:48:40Z
