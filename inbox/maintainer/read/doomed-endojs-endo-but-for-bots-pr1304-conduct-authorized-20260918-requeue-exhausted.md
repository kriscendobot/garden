from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-18T17:53:35Z
doom_base: endojs-endo-but-for-bots-pr1304-conduct-authorized-20260918
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-18T17:53:35Z
last_seen: 2026-09-18T17:53:35Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1304-conduct-authorized-20260918; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr1304-conduct-authorized-20260918) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr1304-conduct-authorized-20260918

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: conductor
handler-timeout: 7200
---
Conduct endojs/endo-but-for-bots#1304 ("feat(daemon): read-only directory
attenuation, 1/3 of #1125"). MAINTAINER AUTHORIZATION (kriskowal, 2026-09-18):

  "My expectation is that the conductor will rebase the pull request on llm proper
   then merge, leaving the other pull requests on the same base pin alone until
   their next rebase or advancement of their base pin."

That is the explicit authorization the shared-frozen-base guard was waiting for.
Forward #1304 ALONE: retarget its base to live `llm`, rebase, then merge. Leave the
other six PRs on `llm-387ea66` untouched.

## State verified at posting (re-derive it; do not trust these)

- OPEN, `isDraft=false`, `mergeable=MERGEABLE`, `mergeStateStatus=CLEAN`.
- Head `69943c50ae1dd9bf470383a112b32240d6b7890f`, and kriskowal APPROVED AT THAT
  EXACT HEAD (2026-09-18T14:19:47Z, review 5248815990, body "@kriscendobot
  Conduct."). The approval is current and already includes the panel-4
  revocation-race must-fixes.
- CI green: 17 SUCCESS / 15 SKIPPED / 0 failing.
- Base is the frozen pin `llm-387ea66`; live `llm` is ~24 commits ahead.

## Why the prior two conduct attempts stopped (both correctly)

1. `endojs-endo-but-for-bots-pr1304-conduct` (05:36Z) declined because a concurrent
   `gauntlet-fix-4` was actively fix-looping the PR and panel-4 had posted a genuine
   must-fix (a revocation race: `context.onCancel` registered after an `await`, so a
   cancel in that window latches the attenuated view live forever). The approval then
   predated the defect. THAT CONDITION IS RESOLVED — the fixes landed and kriskowal
   re-approved the resulting head.
2. `endojs-endo-but-for-bots-pr1304-conduct-20260918` (15:59Z) stalled at the
   unfreeze step: `ci-wait-merge.sh` returned 10 because `llm-387ea66` is shared by
   7 open PRs (#1304, #1303, #1301, #1299, #1298, #1100, #695) and the guard
   reserves that call to the maintainer. It stalled rather than overrode, which was
   correct discipline. The maintainer has now made the call.

The seven are SIBLINGS on one pin, not a dependency stack — the prior conductor
verified none bases on another's head. Retargeting #1304 is `gh pr edit --base`,
which touches only #1304 and never moves or deletes the `llm-387ea66` branch, so the
other six are mechanically unaffected.

## Procedure

1. Retarget #1304's base to live `llm`, rebase onto it, resolve any conflicts
   against 24 commits of divergence, and let base-change-triggered CI run.
2. Re-verify green, then merge.
3. **RETAIN THE HEAD BRANCH — do NOT pass `--delete-branch`.** PR #1306 (2/3 of
   #1125) stacks on #1304's head; deleting it strands #1306.
4. Do NOT touch #1303, #1301, #1299, #1298, #1100, or #695. They stay on the pin
   until their own rebase or base advancement, per the maintainer's instruction.

If the guard still blocks you after the retarget, note that a separate job
(`fix-shared-frozen-base-guard-sibling-vs-stack-20260918`) is correcting the
predicate; report the block rather than overriding the guard by hand.

## Downstream (do not do these here)

After #1304 lands, #1306 (2/3) and then #1305 (3/3) need retarget/rebase and their
own gauntlets. Report that as a follow-up; the conductor does not post it.
