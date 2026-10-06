---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (main advanced 5563e989..be0edb8f; this is the merged gate-token fix series for PR #163, follow-up to the 2026-10-05 incident in kriscendobot/garden#89, where signed-in GET /account/claude returned 403 because caddy sent an empty X-Account-Gate-Token).
Task: verify on production that the deployed change works. Do not rewrite the fix. Over SSM on the minion.town host (see the deploy/aws scripts and DEPLOYMENT.md § Caddy config discipline, "Reload vs restart (gate tokens)"):
1. Confirm CD deployed be0edb8 or later, and that the live /etc/caddy conf.d/minion-town.caddy uses the runtime placeholders `{env.ACCOUNT_GATE_TOKEN}` / `{env.BILLING_GATE_TOKEN}` and no `{$...GATE_TOKEN}` remains.
2. Confirm that caddy's MainPID environment matches /etc/caddy/account.env and billing.env. Compare hashes only, never print the secrets; `caddy_environment_in_sync` in deploy/aws/scripts/lib/caddy-environment-sync.sh does this.
3. Confirm that the new lock directory /run/minion-town-deploy is created root-owned 0700 by deploy-caddy.sh and the secret scripts, and that the scripts no longer warn about a foreign-owned lock directory.
4. Smoke-test a signed-in GET /account/claude and the billing gated route end to end: expect no 403 from an empty gate token.
If anything is red, fix it in a small follow-up PR, using the gauntlet as usual and GARDEN_YARN=npm. Before deploying, watch for the known minion-mcp EADDRINUSE orphan (PR #137) and the CD-reverts-unmerged-guest.js hazard. Report the result on kriscendobot/garden#89.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-06T15:09:53Z
