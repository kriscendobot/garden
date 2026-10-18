from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-10-18T14:13:24Z
doom_base: heal-minion-town-cfafabe
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-10-18T14:13:24Z
last_seen: 2026-10-18T14:13:24Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/heal-minion-town-cfafabe; it stays HELD until a human promotes it
(promote-plan.sh heal-minion-town-cfafabe) or removes it, so nothing is lost.
Original job base: heal-minion-town-cfafabe

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: fixer
delegation: minion-town-pr-screening
# Heal minion.town production after merge cfafabea5a93f0d270980d4b468841c0565b3a3a
Merge cfafabea5a93f0d270980d4b468841c0565b3a3a (https://github.com/kriscendobot/minion.town/pull/197) broke production: deploy.yml failure.
Run: https://github.com/kriscendobot/minion.town/actions/runs/39126464564
Restore production by the cheapest correct route: a forward-fix PR or a revert PR of
cfafabea5a93f0d270980d4b468841c0565b3a3a, against base main. Put this marker on its own line in the PR body:
<!-- garden-heal: cfafabea5a93f0d270980d4b468841c0565b3a3a -->
Open it with scripts/jobs/gardening/ensure-pr.sh and stage the ordinary gauntlet; the
proxy screens and merges a marked heal PR even while the delegation is paused. Never
push to main directly and never force-revert main.
