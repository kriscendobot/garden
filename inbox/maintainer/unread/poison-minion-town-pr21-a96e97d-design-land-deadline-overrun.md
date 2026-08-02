from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-02T02:23:07Z
poison_base: minion-town-pr21-a96e97d-design-land
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-02T02:23:07Z
last_seen: 2026-08-02T02:23:07Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/minion-town-pr21-a96e97d-design-land; it stays HELD until a human promotes it
(promote-plan.sh minion-town-pr21-a96e97d-design-land) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: minion-town-pr21-a96e97d-design-land

--- original job body ---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: https://github.com/kriscendobot/minion.town. Design PR https://github.com/kriscendobot/minion.town/pull/21 ("design(weblet-gateway): the *.minion.town wildcard weblet gateway", `designs/weblet-gateway.md`) is still an **open draft**, yet its Increment 1 has already been implemented and merged as PR #22 (commit a96e97d, CD green).
Task: reconcile the design with what actually landed, then land the design. Read `designs/weblet-gateway.md` on the PR branch against the merged Increment-1 code (`src/endo/gateway/`, `deploy/aws/caddy/conf.d/weblet-gateway.caddy`, `deploy/aws/systemd/endo-gateway.service`, `deploy/aws/scripts/deploy-{endo-gateway,weblet-dns}.sh`, `DEPLOYMENT.md` § Weblet gateway) and update the design where the implementation diverged or where an open question (notably open question 5, the `@endo/*` lane vs the `src/endo` transplant seed) was settled by Increment 1. Rebase the branch on current `main` first.
Then run the gauntlet on #21 end to end (clean → panel review → fix-loop → un-draft) so the design merges ahead of Increments 2–4. If you conclude the design is deliberately being held draft as a living document until Increment 4, do not un-draft it — instead say so explicitly in a journal message to the maintainer with your reasoning, and leave the rebase + reconciliation commits on the branch.

<!-- garden-deadline-overrun: 1 -->
