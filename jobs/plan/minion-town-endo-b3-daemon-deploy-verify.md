---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
doomed_at: 2026-08-09T18:43:07Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-09T18:43:07Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town. Three consecutive commits landed the B3 endo daemon deployment path — 1b2cfe7 "feat(endo): B3 daemon deployment and CD ordering", then two hotfixes b4f22e5 "make B3 daemon deployment runnable" and ee4e70d "focus daemon production closure on target" — which together indicate the deploy path was landed before it was exercised end to end.
Verify the deployment path is actually runnable as it now stands, and close the gap that let two hotfixes be needed:
- Read deploy/aws/scripts/deploy-endo-daemon.sh at HEAD and confirm the production closure/target focus in ee4e70d is coherent with the systemd units deploy/aws/systemd/endo-daemon.service and deploy/aws/systemd/minion-mcp.service (b4f22e5 and 1b2cfe7 both touched the units; check the After=/Requires= ordering matches the CD ordering the workflow now enforces).
- Confirm .github/workflows/deploy.yml ordering and deploy/aws/scripts/deploy-cd-iam.mjs permissions cover every action the daemon deploy step performs; a missing IAM action fails only at deploy time.
- Cross-check .env.example, config/policy.json, and src/config.ts against each other: b4f22e5 changed all three plus dev/client.ts, so confirm no config key was renamed in one place and left stale in another, and that dev/client.ts still speaks the same shape.
- Confirm DEPLOYMENT.md at HEAD describes the deployment as it now works, including the daemon step and its ordering relative to minion-mcp.
Land any corrections as a PR on the fork and run the gauntlet. If a lightweight smoke check (a dry-run or lint of the deploy script, or a unit-file validation) can be added cheaply to CI so this class of "landed but not runnable" regression is caught before merge, include it; if it is not cheap, say so in the PR description rather than building it.

<!-- garden-deadline-overrun: 1 -->
