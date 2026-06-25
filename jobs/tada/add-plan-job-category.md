Inbox is empty. The work is complete and pushed. Here is my report.

---

## Completion report: `add-plan-job-category`

**Done. Committed + pushed to `origin/main2`** — final tip **`cf1ff5233`** (feature commit `2d3785999` + collision-fix `cf1ff5233`). Built in an isolated worktree off `origin/main2`, committed with explicit pathspecs under the `endolinbot` bot identity.

### Metadata schema (plan-job frontmatter)
Formalized the schema already in informal use by the three existing `jobs/plan/` files:
```
---
gate: go-ahead | deferred          # WHY parked (the gate reason)
priority: urgent | high | normal | low   # selection key; `urgency:` accepted as a synonym (legacy)
roadmap: <milestone/item>          # optional; recorded for roadmap-aware selection
posted_by: <role>                  # provenance
posted_at: <iso8601>
---
<work body — becomes the todo job verbatim on promotion>
```
Priority ranking (lower = promoted first): urgent=0, high=1, normal=2, low=3; unknown → normal.

### Promotion paths
1. **Maintainer go-ahead** — liaison (or proxy *within bounds*) runs `promote-plan.sh <base>`. A `go-ahead` job is promoted **only** this way, never auto-selected. (Proxy may promote a `deferred` job but **never** a `go-ahead` one — that's an authority grant it must refuse.)
2. **Priority/urgency selection** — the **foreman** idle-pump, on sustained idle, **prefers** promoting the top `deferred` plan job (highest priority, FIFO within a priority) over generating a new step — and skips the `claude -p` call, saving cost. `go-ahead` jobs are excluded from auto-selection.

### What changed (14 files, +567 lines)
- **New primitives**: `post-plan.sh` (park; idempotent; default `--deferred`) and `promote-plan.sh` (move `plan/<base>`→`todo/<base>`, strip frontmatter, stamp provenance; retries-with-backoff like a completion).
- **`common.sh`**: `JOBS_PLAN` + helpers `plan_field/plan_gate/plan_priority/plan_rank/plan_deferred_ranked`.
- **Scoping** (already correct by construction; now documented): `claim-job.sh` draws only from `todo/`, `reaper.sh` scans only `doin/` — `plan/` is never claimed or reaped, so parked jobs don't go stale.
- **`foreman.sh`**: prefer-promote-deferred before invoking the handler.
- **`bulletin.sh`**: new **Plan queue** section (go-ahead awaiting authorization + deferred top-by-priority, each with gate reason).
- **Docs/roles**: `designs/job-board.md` (§2.5), `skills/job-board/SKILL.md`, and `liaison`/`proxy`/`foreman`/`gardener` AGENT.md vocabulary/norms.
- **Tests**: `run-test.sh` subtest 20 — park→unclaimable, promote→claimable, frontmatter-strip, foreman promotes the high deferred (never the go-ahead), reaper ignores `plan/`. **123/123 pass.**

### Notes / follow-ups
- **The contract reference `journal/jobs/README.md` does not exist in v2** — it's a v1 CLAUDE.md artifact. The journal's top-level `README.md` is the live bulletin dashboard, and the v2 contract genuinely lives in `designs/job-board.md` + `skills/job-board/SKILL.md` (both on `main2`), which is where I documented it. I deliberately did not write a static doc onto the `journal2` message-bus branch.
- **Resolved a name collision** mid-flight: a concurrent `main2` change had added its own `render_plan()` (roadmap-view re-renderer writing `plan/README.md`). My job-board renderer reused the name and silently shadowed it; I renamed mine to `render_plan_queue()` (commit `cf1ff5233`) so both coexist. Worth a glance by whoever owns the roadmap-plan tree, but verified working.
- **Test-harness env leak (not fixed here, pre-existing)**: `run-test.sh` subtests 1/5 fail when run from inside a *live gardener's* shell because exported `GARDEN_GARDENER_CLONE`/`GARDEN_GARDENER_ID` override the fixtures (the test sets `GARDEN_STATE` per-subtest but not those). Run with `env -u GARDEN_GARDENER_CLONE -u GARDEN_GARDENER_ID -u GARDEN_ROOT` to get a clean 123/123. A small hardening (have `run-test.sh` `unset` these at the top) would make the suite robust to that — candidate follow-up job.
