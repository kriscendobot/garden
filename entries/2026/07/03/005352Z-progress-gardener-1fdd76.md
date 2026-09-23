---
kind: progress
role: gardener
host: endolinbot2
at: 2026-07-03T00:53:54Z
---
---
job: xs2rust-endor-press-20260703-004244
role: gardener (Fable press-driver, PR endojs/endo-but-for-bots#600)
pr_head: be08ab8ae6d0c9eaf05e1f77e6e80290f1fd7ef3
---
# xs2rust-endor press check-in: unstalled the stage2b orchestration (leader timer starvation)

State found: PR #600 head be08ab8ae, DRAFT, base llm. The serial orchestration
`xs2rust-endor-build-stage2b` (heap -> frames -> exceptions) had sat `state: pending`
for ~2.3h with all three children parked in plan/ and nothing in doin/ — a genuine
stall, not an active chain.

Root cause: on the leader (endolinbot2) the `garden-orchestrate` timer had NEVER
fired (LastTrigger empty). It was one of four timers still on pure
OnActiveSec/OnUnitActiveSec pairs (orchestrate, foreman, deadmail, mirror-closer);
a never-fired monotonic timer's first elapse is re-anchored by every daemon-reload,
and the fleet reloads ~every minute (gardener-scaler + repo-watcher), so the first
fire never came — next-elapse slid perpetually ~2min ahead.

Action taken:
- Manually started the four starved services once. orchestrate promoted child 1/3
  `xs2rust-endor-build-stage2b-heap` (observed log: "promoted child 1/3 ... (serial)");
  it is claimed and in doin/. The manual activation anchored OnUnitActiveSec, so the
  timer now self-fires every 3min (observed re-fire at 00:52:27).
- Durable fix pushed to main2 as ad362c963: the four timers converted to the
  established OnCalendar + Persistent=true idiom (immune to reload churn). Takes
  effect fleet-wide on next deploy (upgrade-monitor will signal).

Bars: finish line NOT met — roadmap stage 2b just started (heap child in flight).
test:rust / test262 NOT verified this tick (deliberately: a builder now owns the
branch; press-driver defers per charter while the chain is advancing). No pushes
made to xs2rust-endor.

Next check-in should see: heap child progressing or in tada/, then frames promoted.
