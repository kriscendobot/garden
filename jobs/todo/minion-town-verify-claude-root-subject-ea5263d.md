---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. Commit ea5263d (range 9ac858df240c..5563e989499b) adds kriscendobot's Cognito sub (79b9090e-20a1-70d2-94c7-717257e2be34) as a second entry in ENDO_CLAUDE_ROOT_SUBJECTS. The change touches deploy/aws/systemd/minion-mcp.service and DEPLOYMENT.md. kriskowal authorized it in kriscendobot/garden#89.
Task: check that this unit change is actually live on production, and fix it if it is not. First, look at the board and journal for the job that authored ea5263d. If that job already owns rollout or the /account/claude connect flow, record that and stop without changing anything.
Otherwise:
(1) Check whether CD applied the unit change. Read the CD run for the merge commit and confirm it wasn't marked [skip deploy].
(2) Over SSM, confirm that the deployed /etc/systemd/system/minion-mcp.service (and any drop-ins) has both subjects in ENDO_CLAUDE_ROOT_SUBJECTS, and that the running process environment matches it.
(3) If the unit was updated but the process wasn't restarted, do a targeted restart or CD dispatch. Then confirm minion-mcp is healthy: NRestarts stable, no crash loop. Follow the known EADDRINUSE orphan-recovery recipe if :8920 is held by a PPID-1 manager-node.
(4) Confirm the maintainer's existing subject still resolves as a root subject, so nothing regressed.
Don't drive the /account/claude subscription connect yourself unless the authoring job is gone and garden#89 explicitly assigns it. Report the result as a comment on kriscendobot/garden#89 using owner/repo#N cross-repo references.
