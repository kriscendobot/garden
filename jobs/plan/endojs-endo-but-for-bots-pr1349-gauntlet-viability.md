---
gate: go-ahead
priority: normal
gauntlet: endojs-endo-but-for-bots-pr1349-gauntlet
role: gardener
tier: mentor
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
failure_classification: deterministic
requeue_cycles: 1
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-28T03:46:17Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-28T03:46:17Z
---

---
role: gardener
gauntlet: endojs-endo-but-for-bots-pr1349-gauntlet
gauntlet_stage: viability
gauntlet_iteration: 0
pr: https://github.com/endojs/endo-but-for-bots/pull/1349
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #1349

You are the viability gate for staged gauntlet (endojs-endo-but-for-bots-pr1349-gauntlet). Spend no clean, panel,
fix, CI-wait, or un-draft budget. Decide whether the gauntlet may begin, report the
evidence, then STOP.

1. Read current PR facts with
   `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1349 --json state,mergedAt,isDraft,title,body,baseRefName,headRefName,headRefOid,baseRefOid,url`.
   A merged PR reports `viability=merged`; any other non-OPEN PR reports
   `viability=closed`. Neither enters the gauntlet loop.
2. For an open, unmerged PR, inspect its description, discussion and reviews, linked
   issue/design context, current base code, and relevant newer base history. Ask one
   concrete yes/no question whose answer decides both of these claims: the PR has not
   been superseded, and the need or assumption that motivated it still holds.
3. Report `viability=proceed` only when current evidence supports both claims. If a
   newer implementation/design displaced it, or its motivating premise no longer
   holds, report `viability=overtaken`. Do not enter the expensive loop merely
   because the PR remains open.
4. Include concise `Deciding question:` and `Evidence:` lines in every report.
   For `overtaken`, also include this exact line so the maintainer gets an explicit
   disposition rather than a silent refusal:

   Option: close as superseded

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: viability=proceed -->
  <!-- gauntlet-stage-result: viability=closed -->
  <!-- gauntlet-stage-result: viability=merged -->
  <!-- gauntlet-stage-result: viability=overtaken -->
