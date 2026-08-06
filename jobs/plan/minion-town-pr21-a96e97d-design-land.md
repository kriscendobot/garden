---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
doomed_at: 2026-08-02T02:23:03Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-02T02:23:03Z
---
handler-timeout: 7200
<!-- liaison 2026-08-06: this job was DOOMED by the reaper after a
     deterministic deadline overrun at the 2400s default. It carried no
     handler-timeout: header and its role does not qualify for the 7200s
     builder default (landed 2026-08-01), so it was SIGTERM-killed at the
     wall on every requeue. The budget is the fix; the work is wanted.
     If it overruns 7200s too, that is a REAL overrun -- diagnose it, do
     not raise the budget again. -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: https://github.com/kriscendobot/minion.town. Design PR https://github.com/kriscendobot/minion.town/pull/21 ("design(weblet-gateway): the *.minion.town wildcard weblet gateway", `designs/weblet-gateway.md`) is still an **open draft**, yet its Increment 1 has already been implemented and merged as PR #22 (commit a96e97d, CD green).
Task: reconcile the design with what actually landed, then land the design. Read `designs/weblet-gateway.md` on the PR branch against the merged Increment-1 code (`src/endo/gateway/`, `deploy/aws/caddy/conf.d/weblet-gateway.caddy`, `deploy/aws/systemd/endo-gateway.service`, `deploy/aws/scripts/deploy-{endo-gateway,weblet-dns}.sh`, `DEPLOYMENT.md` § Weblet gateway) and update the design where the implementation diverged or where an open question (notably open question 5, the `@endo/*` lane vs the `src/endo` transplant seed) was settled by Increment 1. Rebase the branch on current `main` first.
Then run the gauntlet on #21 end to end (clean → panel review → fix-loop → un-draft) so the design merges ahead of Increments 2–4. If you conclude the design is deliberately being held draft as a living document until Increment 4, do not un-draft it — instead say so explicitly in a journal message to the maintainer with your reasoning, and leave the rebase + reconciliation commits on the branch.

<!-- garden-deadline-overrun: 1 -->
