---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 7200
repo: kriskowal/garden (branch main2, pushed directly; no PR)

Give a deadline-nudged job a legal way to hand off, and the budget facts to
decide whether to hand off at all. Maintainer-motivated (kriskowal, 2026-08-13):
the hope was that a nudged job would "organize its follow-up work, possibly
employing an orchestration and distribution of its budget, and taking budget into
consideration, deciding whether to park for the next quota reset or continue."
Today it cannot do any of that.

## Evidence: the mechanism runs and still fails

`garden-deadline-nudge.timer` is active and firing every 60s;
`deadline-nudge.sh` nudges at 1/4 of budget remaining (cap 900s). On 2026-08-13
three jobs were nudged, READ the nudge (journal shows
`inbox(ebfb-pr475-integrate-endo-ascii) read 1 msg(s)` and
`inbox(ebfb-pr977-lint-unstick) read 1 msg(s)`), and then ran to rc=124 at the
wall anyway: `ebfb-pr475-integrate-endo-ascii`, `ebfb-pr977-lint-unstick`, and
`endojs-endo-but-for-bots-pr403-e97aa392`. Delivery is not the problem.

## Defect 1 — the nudge asks for something it forbids

The message body says, in the same breath:

  "...record the next job under `## Follow-ups`; garden-follow-up consumes that
   section." and "Do not emit the completion signal while the current job's core
   deliverable is unfinished."

`## Follow-ups` is harvested ONLY from completion reports in `jobs/tada/` (see
`follow-up.sh` and CLAUDE.md § Autonomous follow-up surface). So a job with an
unfinished core deliverable is told to record follow-ups AND forbidden to use the
only channel that delivers them. It has no legal handoff, so it keeps working
until it is killed. That is not a wording nit; it is the whole failure.

Fix by giving it a real channel. The producer primitives are already available to
any worker, and the nudge simply never mentions them:

- `post-job.sh <successor-base>` — a successor carrying an appropriate
  `handler-timeout:`, for work that is one continuous unit (a single branch,
  sequential edits) and must NOT be split across agents.
- `post-plan.sh --orchestrated --orchestrated-by <orch>` + `post-orchestration.sh`
  — when the remaining work IS separable into stages, which is what the
  maintainer meant by "employing an orchestration".
- `post-plan.sh --deferred` / `--go-ahead` — park it.

The nudge must name these and say how to choose. It must also let the job record,
in its own report, that it is handing off UNFINISHED work rather than completing:
add an explicit disposition (for example `handed-off: <successor-base>` alongside
the existing `orchestration-failed:`-style front matter) so a partial handoff is
never mistaken for a finished deliverable. Keep the prohibition on FALSE
completion; replace "you may not complete" with "complete as a declared,
evidenced handoff".

## Defect 2 — the nudge carries no budget facts

It sends `deadline_at` and `remaining_seconds` and nothing about tokens. A job
therefore cannot weigh continue-versus-park, which was half the maintainer's ask.
Include what is already measured with no LLM: this attempt's billable spend from
`usage/<base>.jsonl`, any declared budget in force (including a campaign budget
if the job is an orchestration child), and the remaining figure. If a quota
window is known to be exhausted or near, say so — today's 04:36Z panel failures
show the fleet does hit windows, and a job that knows it should park rather than
burn its last minutes on work that cannot succeed.

## Defect 3 — parking on budget is designed but unbuilt

`designs/liveness-progress-reaping.md` (commit `b580e3d51a`) specifies exactly the
disposition wanted: progress+budget replaces elapsed-only doom, and over-budget
jobs park as held `go-ahead` plans promoted on quota-window refresh. It is
DESIGN-ONLY — that commit touches two files, both under `designs/`. Implement the
park-and-promote-on-quota-refresh path so a nudged job can choose it, and so the
reaper's destination follows progress and budget rather than elapsed time alone.
Follow that design; where you depart from it, say why in the commit message.

## Tests

Extend `scripts/jobs/test/deadline-nudge-test.sh`: the nudge body names the
handoff primitives; it carries spend and budget fields; a job that hands off is
distinguishable from one that completed; and a park decision produces a held plan
that a quota-window refresh promotes. Keep the existing claim-attempt conditional
push semantics — a stale sender must still never warn a later claim.

## Notes

- Garden convention: land on `main2` directly, no PR.
- Do not weaken the real protection here: a job must still never emit a clean
  completion for an unfinished deliverable. The point is to add an honest third
  option between "finish" and "die at the wall", not to make giving up cheap.
- Report elapsed against the 7200s budget, and if this does not fit, name the
  split points rather than overrunning.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-13T21:23:31Z
