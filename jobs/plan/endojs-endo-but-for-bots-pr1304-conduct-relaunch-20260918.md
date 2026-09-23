---
gate: deferred
priority: normal
role: conductor
tier: minion
handler-timeout: 7200
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 1
doomed_at: 2026-09-18T19:53:10Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-18T19:53:10Z
---

---
gate: go-ahead
priority: high
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
handler-timeout: 7200
token-budget: 250000
---
role: conductor
handler-timeout: 7200
---
Conduct endojs/endo-but-for-bots#1304 ("feat(daemon): read-only directory
attenuation, 1/3 of #1125"). Relaunch: the prior conduct
(`endojs-endo-but-for-bots-pr1304-conduct-authorized-20260918`) DOOMED
(requeue-exhausted) at 2026-09-18T17:53:13Z without landing the merge — #1304's
base is still the frozen pin `llm-387ea66`, never retargeted. The guard that
blocked the earlier attempts (`ci-wait-merge.sh` returning 10 because seven open
PRs share `llm-387ea66`) was FIXED on `main2` at 2026-09-18T17:48:23Z
(`8f80bd866e` "fix(ci-wait): distinguish frozen-base siblings from a dependency
stack") and is deployed, so the sibling-vs-stack guard should now pass.

MAINTAINER AUTHORIZATION (kriskowal, 2026-09-18, review 5248815990 "Conduct."):

  "My expectation is that the conductor will rebase the pull request on llm proper
   then merge, leaving the other pull requests on the same base pin alone until
   their next rebase or advancement of their base pin."

That is the explicit authorization the shared-frozen-base guard was waiting for.
Forward #1304 ALONE: retarget its base to live `llm`, rebase, then merge. Leave the
other six PRs on `llm-387ea66` untouched.

## State verified at posting (re-derive it; do not trust these)

- OPEN, `isDraft=false`, `mergeable=MERGEABLE`, `mergeStateStatus=CLEAN`.
- Head `69943c50ae1dd9bf470383a112b32240d6b7890f`; kriskowal APPROVED AT THAT EXACT
  HEAD (2026-09-18T14:19:47Z). The approval is current and already includes the
  panel-4 revocation-race must-fixes.
- CI green: 17 SUCCESS / 15 SKIPPED / 0 failing.
- Base is the frozen pin `llm-387ea66`; live `llm` is ~24 commits ahead.

## Procedure

1. Retarget #1304's base to live `llm`, rebase onto it, resolve any conflicts
   against ~24 commits of divergence, and let base-change-triggered CI run.
2. Re-verify green, then merge.
3. **RETAIN THE HEAD BRANCH — do NOT pass `--delete-branch`.** PR #1306 (2/3 of
   #1125) stacks on #1304's head; deleting it strands #1306.
4. Do NOT touch #1303, #1301, #1299, #1298, #1100, or #695. They stay on the pin
   until their own rebase or base advancement, per the maintainer's instruction.

If the guard still blocks after the retarget despite the deployed fix, report the
block rather than overriding it by hand.

## Downstream (do not do these here)

After #1304 lands, #1306 (2/3) then #1305 (3/3) need retarget/rebase and their own
gauntlets; the serial orchestration `split-pr1125-stack-gauntlets` is HALTED at
child 1 and will need re-driving. Report that as a follow-up; the conductor does
not post it.
