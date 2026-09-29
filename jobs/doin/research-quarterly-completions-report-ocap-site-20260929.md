---
role: researcher
requires: host=endolin-garden2-5bcdff64
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Roll up a quarterly completions report and publish it as an HTML ocap.site clip

Dispatched on `endolin-garden2-5bcdff64` specifically because it has
demonstrated working, authenticated minion-town MCP access (it completed
`minion-town-clipometer-pr84-canonical-publish-validate` on 2026-09-23).

## Task

1. **Gather.** Walk `journal/jobs/tada/` for essentially all completed jobs in
   recorded history — the tree currently spans 2026-06-24 through today,
   under both the legacy flat `tada/<base>.md` layout (one leftover file) and
   the current date-sharded `tada/YYYY/MM/DD/<base>.md` layout (98 day
   directories as of this writing). Use
   `scripts/jobs/completion-window-report.py --since 2026-06-01 --until <now>
   --format json` (or `md`) as the primary enumeration tool rather than
   reading every individual report body — it already knows how to read both
   layouts. Only open an individual `tada/` report when you need more than
   its title/summary line for a highlight.
2. **Roll up.** Produce a genuine rollup, not a raw list: total completions;
   a breakdown by month (the history is short enough that a strict
   calendar-quarter split isn't very informative — use whatever period
   granularity actually shows the shape of the work, monthly is probably
   right); a breakdown by role/job-kind (design, build, fix, shepherd,
   gauntlet stages, self-heal fixes, orchestrations, etc. — derive this from
   basename/role-field patterns, don't hand-classify each one); and a short
   "notable" section calling out a handful of the more significant
   completions (major designs, arcs that closed, incidents resolved) — use
   judgment on what counts as notable, this is meant to be readable by a
   human skimming it, not exhaustive.
3. **Render.** Produce a single self-contained HTML page (inline CSS, no
   external assets — the clip's CSP is same-origin only, see
   `skills/minion-town-clip-publishing/SKILL.md`) presenting the rollup:
   summary numbers up top, then the breakdowns, then the notable section.
4. **Publish.** Publish it via `mcp__minion-town__publish` as a clip (per
   `skills/minion-town-clip-publishing/SKILL.md` — read it first, it
   documents real gotchas: the `powers` argument, the immutable
   content-addressed `<hash>.ocap.site` URL shape, the CSP, and that
   `upgrade` cannot rewrite live content, so a fresh publish call is what you
   want, not an update-in-place).
5. **Report.** Put the resulting `<hash>.ocap.site` URL plainly in your
   completion report, and also send it to the maintainer inbox
   (`scripts/jobs/message-user.sh <this-job-base>`) so it's visible without
   having to read the job report.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-29T00:33:37Z
