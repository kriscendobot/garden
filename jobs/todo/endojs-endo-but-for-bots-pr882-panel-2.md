---
role: gardener
handler-timeout: 10800
---

# Panel round 2 for endojs/endo-but-for-bots PR #882

Run exactly one code-panel round against the current `restore-xs-bootstrap-generators` head. Keep the PR draft; do not fix or un-draft.

Create an isolated checkout with:
`/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr882-panel-2 endojs/endo-but-for-bots restore-xs-bootstrap-generators`

Invoke:
`GARDEN_PANEL_SINGLE_ROUND=1 GARDEN_PANEL_CONCURRENCY=8 /home/kris/garden2/scripts/jobs/gardening/panel.sh <worktree> 882 3b2129924644c67afb80fd2d41b6822498f74168`

Post the aggregate as the formal PR review prescribed by its disposition, record the stage result, and stop.

<!-- garden-reaped: 1 -->
