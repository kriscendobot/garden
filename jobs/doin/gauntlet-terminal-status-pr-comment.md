---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gauntlet: post a PR-visible terminal-status comment on review-budget-reached / halt

Garden machinery fix (main2, scripts/jobs/gauntlet.sh). Found by the prosecutor retro
endojs-endo-but-for-bots-pr1125-b73e4e34-retro and recorded as a dismissal (machinery, not a review miss).

**Defect.** When a gauntlet reaches a terminal state, `finish_review_budget_reached`
(and `halt_gauntlet`) only calls `gauntlet_notify`, which writes to the maintainer inbox. The PR
thread gets no loop-status line. So a green DRAFT sits with no visible
"gauntlet done, awaiting your decision" note, and the maintainer has to ask:
- endojs/endo-but-for-bots#1125 comment 5706332560 (2026-09-17): the gauntlet had hit
  review-budget-reached on 09-13.
- endojs/endo-but-for-bots#1310 comment 5750702331 (2026-09-20): same shape, job
  endojs-endo-but-for-bots-pr1310-72fb67e9.
- Precedent: #796 (a halted gauntlet left the PR silently in draft).

**Ask.**
1. On review-budget-reached and on HALTED, post ONE idempotent top-level PR comment.
   Use a hidden marker keyed by the gauntlet base and terminal state, so re-ticks
   don't duplicate it. It carries the visible loop-status line per
   skills/pr-completion-summary-comment/SKILL.md § Loop-status floor: rounds run,
   head SHA, CI status, the last panel's unaddressed must-fix count if derivable, and
   the next step ("awaiting maintainer merge/undraft or re-run decision"; for a halt,
   the halt reason). Post through the bot-identity gh wrapper, best-effort: a failure
   is a WARN and must never block finish_gauntlet.
2. Add coverage in scripts/jobs/test/gauntlet-test.sh: the comment is posted once on
   budget-reached and once on halt, it is idempotent across ticks, and a gh failure
   does not fail the finish.
3. Update skills/pr-creation-flow (or the gauntlet docs) to say where the terminal
   status is surfaced.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-27T15:42:37Z
