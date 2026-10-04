---
created: 2026-09-28
updated: 2026-10-04
author: liaison
---

# Skill: liaison-reports

A catalog of the reports the liaison can generate for the maintainer, so a
future liaison session doesn't have to rediscover what exists or re-derive a
report from scratch. Every report shares one landing convention (below);
this skill's real content is the table of *which* report answers *which*
question.

## Landing convention (shared by every report here)

Write to `reports/<name>-<date-or-window>.md` on `journal2` via the standard
producer-clone CAS pattern (`ensure_clone`/`sync_clone`/`commit_and_push`
against `${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}` — never
hand-edit the live `journal/` worktree). After landing, fetch
`origin/journal2` and confirm `git -C journal show
origin/journal2:reports/<path>` returns the content before handing over a
URL. Give the maintainer the fully qualified
`https://github.com/kriscendobot/garden/blob/journal2/reports/<path>` link —
that is the "fully qualified URL" the maintainer asks for by habit.

## The reports

| Report | Question it answers | How to generate | Skill/tool |
| --- | --- | --- | --- |
| **Host disposition** | Which hosts are healthy right now — claims, completions, terminal failures, transient kills, per-worker-kind follow-through, across one or more windows? | Run `scripts/jobs/host-disposition-report.py --windows <list>` directly (read-only, deterministic, no board job needed). | [host-disposition-report](../host-disposition-report/SKILL.md) |
| **Completions since X** | What did the fleet actually complete since a given moment (a quota reset, a fleet-wide change, an incident)? Themed narrative + full itemized appendix. | Run `scripts/jobs/completion-window-report.py --since <ISO>` directly (deterministic; the script does the enumeration, but the themed-narrative write-up needs a gardener job's judgment for anything beyond a small window — see its own header comment for the current split). | none yet — capture one if this becomes recurring enough to warrant it |
| **Maintainer priorities / sitrep** | What are the standing priorities' current status, and what needs a maintainer decision right now? | No reusable tool; this is a fresh investigation each time (PR states, board health, recent incidents) written up by the liaison or a dispatched gardener job, following the shared landing convention. Precedent: `reports/maintainer-priorities-2026-09-28.md`. | none — genuinely bespoke per ask |
| **Open PR survey** | What's the state of every open bot-authored PR across watched repos? | No reusable tool found as of this cataloging (2026-09-28); the existing `reports/open-pr-survey-2026-09-18.md` was hand-produced. Check for a script before re-deriving by hand — one may have landed since. | none confirmed |
| **Monthly progress** | A longer-horizon retrospective over a stated period. | No reusable tool; hand-produced (`reports/monthly-progress-2026-07-14-to-2026-08-14.md` is the precedent for shape/voice). | none |
| **Credit / cost incident investigation** | Why did spend spike unexpectedly (a specific incident, not routine monitoring)? | No reusable tool; hand-produced per incident (`reports/credit-investigation-endolin-garden2-20260905.md`, `reports/kimi-k3-credit-exhaustion-20260730.md` are precedents). | none |
| **Context-graph size audit** | How large/unwieldy is the context library getting? | A test file exists (`scripts/jobs/test/context-graph-size-audit-test.sh`) but no corresponding script was found on `main2` as of this cataloging — either retired or renamed. Confirm before assuming it's runnable; four historical reports exist (`reports/context-graph-size-audit*.md`, 2026-08-13/09-12) as precedent for shape if you end up writing it fresh. | none confirmed live |

## Related, but NOT a liaison-generated report

`scripts/jobs/design-pr-gauntlet-coverage-audit.sh` is a **standing,
autonomous, leader-only timer** (deterministic, no LLM) that alerts the
maintainer inbox when a historical bot-authored open PR has no gauntlet
coverage. Its separately bounded path stages coverage for post-arm PRs. It runs
on its own cadence and posts findings directly, not something the liaison
invokes on demand. Don't confuse it with a report the liaison produces; it's
closer in shape to a watchdog.

## Adding a new entry

When a report gets built (a dispatched job produces a reusable script, or
the liaison hand-writes one enough times that it deserves a name), add a row
here rather than letting it live only in institutional memory of one
session. If the tool is substantial enough to need its own procedure detail
(inputs, output shape, notes — the `host-disposition-report` skill is the
model), give it its own `skills/<name>/SKILL.md` and link it from this
table; a one-off ad hoc report type doesn't need its own skill file, just a
row here naming its precedent.
