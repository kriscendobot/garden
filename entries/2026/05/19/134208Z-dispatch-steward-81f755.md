---
ts: 2026-05-19T13:42:08Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
---

# Dispatch: fixer on #290 per jcorbin's @-mention directive

jcorbin (recognized maintainer per
`skills/monitor-endo-but-for-bots/SKILL.md`) on PR #290 at
`13:40:02Z` ([#290 issuecomment-4488329947](https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4488329947)),
`@kriscendobot` directive (loud per at-mention surveillance
matrix → fixer):

Two parts:

1. Replace `makePiAgent` from `@endo/genie` with direct
   `new PiAgent(...)` calls. Constructor-indirection isn't
   earning its weight; blocks passing prior session messages;
   forces genie's claw-system-prompt opinions. Keep using
   `runAgentRound` stream adapter.
2. Look at `packages/genie/src/tools/...` especially `common.js`;
   see if it advances `@endo/patterns` checking around Pi's tool
   surface.

Dispatch root: `/home/kris/dispatches/fixer--52b3b4` on `feat/lal-pi-harness`.

Per-action authorizations: reply on the comment thread,
top-level summary, push to feat/lal-pi-harness,
`gh pr edit --add-reviewer kriskowal` (NOT `gh api -f reviewers=`).
Standing broad-comment authorization on endojs/endo-but-for-bots
covers all comment ops.
