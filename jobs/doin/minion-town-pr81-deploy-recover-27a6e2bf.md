---
role: gardener
tier: mentor
handler-timeout: 7200
fallback-tier: minion
dispatch: automatic
---
# Recover the failed production deploy of kriscendobot/minion.town#81 (main 27a6e2bf)

https://github.com/kriscendobot/minion.town/pull/81 (web bearer guest invite/accept) was
APPROVED by kriskowal 2026-09-25 05:19Z ("I will evaluate this in production. Please
proceed.") and merged to `main` at 05:28Z (merge commit `27a6e2bf`). The continuous
deployment run https://github.com/kriscendobot/minion.town/actions/runs/36098733289 then
**failed**: in "Deploy app (minion-mcp)" the SSM step restarted `minion-mcp`, the unit
was still `activating` at the smoke check, the smoke failed, and the script restored
the preceding artifact. So production does NOT carry #81, and the maintainer's
production evaluation is blocked.

Do:
1. Over SSM (recipe: memory `minion-town-deployed-topology`, `minion-town-endo-pin-bump-verification`),
   confirm production is healthy on the restored artifact (unit active, NRestarts stable).
2. Diagnose why the #81 artifact did not come up: `journalctl -u minion-mcp` around
   2026-09-25 05:31Z. Distinguish a slow start that outran the smoke window (flake / smoke
   timeout too short) from a real startup crash (config, env, migration, dependency).
3. Fix forward: if a flake, re-run the deploy workflow on `main`; if a code or deploy-script
   defect, open a small fix PR against `main` (via ensure-pr.sh), get CI green, and report
   it for conduct (do not merge without a maintainer directive; pin/deploy-fix conduct
   authority per kriskowal's 2026-09-23 note on #112 applies only to pin advancements).
4. Verify the #81 artifact is live in production (unit active, invite/accept route
   responding) and comment a short note on #81 saying it is deployed and ready for evaluation.

Scope: kriscendobot/minion.town only. Arc: https://github.com/kriscendobot/garden/issues/89 item 7.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T05:40:34Z
