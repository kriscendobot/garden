---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-22T10:41:31Z
---
# Claude-on-minion.town completion-press tick 20260922-103505

Read-only pass over the journal2 clone. Window: prior dispatch 2026-09-18T02:35:12Z → now
(a 4-day gap; both this press and the outward `claude-on-minion-town-press` last dispatched
2026-09-18, then went silent until now — see finding C). Inbox empty. No board writes; no git
in $GARDEN_ROOT.

## Roster (rebuilt this tick)

Arc = kriscendobot/garden#89. Board positions now: todo 0, doin 0 (only this press), orch 0.
All arc jobs are either completed (tada) or parked in plan.

MERGED IN WINDOW (arc advanced substantially):
- endo #1304 merged 09-18T21:05 (1/3 of #1125), #1306 merged 09-19T05:30 (2/3), #1305 merged
  09-19T15:21 (3/3) → the split-pr1125 stack fully LANDED, all three slices.
- minion.town #99 merged 09-18T07:03 (pinned Claude harness provisioning).
- minion.town #98 merged 09-22T00:39 (end-to-end evaluation design).
- minion.town #87 merged 09-22T03:13 (wire Claude-agents capability behind ENDO_CLAUDE_ENABLED
  — the central build-phase deliverable).
- minion.town #104 merged 09-22T05:16 (refresh pinned daemon commit to guest-native accept).

STILL OPEN / DRAFT (expected; designs + confinement core in progress):
- endo #1015 (confinement core, draft) — its refresh-for-review job DOOMED (finding A).
- endo #1226, #1227 (design PRs, draft); #1228 CLOSED (superseded → backfill design posted).
- minion.town #96, #97 (design PRs, draft).

DOOMED IN WINDOW, UNRESOLVED (findings):
- A) endojs-endo-but-for-bots-pr1015-refresh-for-review-20260919 — requeue-exhausted
  (repeated-plain-exit), cycles 2, doomed 09-21T23:23:17Z on endolin-garden-ece02cb4.
  No successor posted; #1015 remains draft, never reached review.
- B) fix-minion-town-claude-harness-supply-chain-hardening — requeue-exhausted
  (repeated-plain-exit), cycles 2, doomed 09-18T08:23:06Z on endolin-garden-ece02cb4.
  release.json signature re-verification hardening; parked, not superseded by the #99/#87 merges.

DOOMED IN WINDOW BUT RESOLVED BY MERGE (churn, NOT findings): a large cluster of pr1304/1305/1306
conduct / shepherd / weave / gauntlet-panel / review jobs doomed 09-18→09-19 (requeue-exhausted /
deadline), and two orchestrations HALTED — split-pr1125-stack-gauntlets and
endojs-endo-but-for-bots-pr1305-shepherd-retcon-conduct-20260919. Despite the halts, all three
PRs merged through other conduct paths, so the halted orchestrations are moot, not live blockers.

PARKED PLAN (arc, intentional / awaiting promotion):
- backfill-endo-claude-design-from-minion-town-production (gate go-ahead, posted 09-22T01:25) —
  awaits promotion; foreman is deliberately braked.
- evaluate-reauth-escalation-default-after-oauth-relay (gate deferred, awaits browser OAuth relay).

## Counts
- Roster completions in window: 6 merges (endo 1304/1305/1306, minion 87/98/99/104 — 7 PRs).
- Dooms in window: ~15 arc jobs, of which 13 resolved by the stack merges (churn) and
  2 remain unresolved (findings A, B). No policy-refusal among them (all requeue-exhausted /
  deadline-overrun). No arc job absent-without-report. No arc job on a 3rd+ requeue cycle in-window
  (both live dooms at cycles 2). No arc work claimable in todo.

## Findings
- A + B: two arc jobs doomed in-window and unresolved; maintainer messaged (one message).
- C: schedule silence 09-18T02:35 → 09-22T10:35 meant no press covered the window in which the
  stack merged and A/B doomed; likely the deliberate schedule pause / quota, noted for context.

Assessment: arc is HEALTHY and advancing — the split stack and the central #87 capability wiring
all merged this window. Two doomed follow-ups (#1015 refresh, harness hardening) need a maintainer
call on re-posting. Schedule left STANDING.
