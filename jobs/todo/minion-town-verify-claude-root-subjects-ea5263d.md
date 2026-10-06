---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. Commit ea5263d (range 9ac858df..5563e989) adds kriscendobot's Cognito sub (79b9090e-20a1-70d2-94c7-717257e2be34, GitHub_279080640) as a second entry in ENDO_CLAUDE_ROOT_SUBJECTS. The change is in deploy/aws/systemd/minion-mcp.service and DEPLOYMENT.md. The maintainer authorized it in kriscendobot/garden#89.
Task: check that the deployment is live and healthy. Do not change the code.
1. Look at whether CD ran for this commit. If it ran with [skip deploy], or did not touch app/minion-mcp, do not redeploy on your own. Report the gap instead.
2. Over SSM, confirm that the deployed minion-mcp unit on prod has both subjects in ENDO_CLAUDE_ROOT_SUBJECTS. Then run `systemctl show minion-mcp` and check that the unit is active, with NRestarts stable and no crash loop.
3. The restart can leave an orphaned manager-node holding :8920 (EADDRINUSE; see PR #137). If that happened, use the documented orphan-kill-and-restart recovery.
4. Optional: if you can do it without exposing secrets, confirm that the kriscendobot identity can reach the root @claude-agents tools and the /account/claude connect flow.
Report what you found to the maintainer inbox. If nothing is wrong, close as a no-op.
