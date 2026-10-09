---
role: weaver
pr: https://github.com/kriscendobot/minion.town/pull/152
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Weave kriscendobot/minion.town #152 (JS-only scripts part 2a) onto current main, then restack #153

Source: panel round 1 on https://github.com/kriscendobot/minion.town/pull/153 (integrator finding 2, must-fix).

#152 (head `chore/javascript-only-scripts-part-2a`, base `chore/javascript-only-scripts-part-1-dcc2d64`) sits 79 commits behind `main`. It lacks the ci-runner scripts and `deploy/aws/scripts/lib/caddy-environment-sync.sh`, both of which landed on `main` since then. #153 is stacked on a frozen `chore/javascript-only-scripts-part-2a-dcb041b`, which was a rebase of an older 2a onto `main-50aa690`. That 2a tree fails `check-javascript-only-scripts` because the five `deploy/aws/ci-runner/**` `.sh` files, `create-app-artifact.sh`, and `lib/caddy-environment-sync.sh` are not allowlisted. It also regresses Caddy token sync in `deploy-account-endpoint-secret.js` and `deploy-billing-secrets.js`, which use `reload caddy || true` instead of the stale-token restart. #153 currently repairs both in `54c4e09` and `31d053e`.

Task:
1. Weave #152 (and its own base, #151, if needed) onto the current `main` tip, using frozen-base-branch. Carry into 2a these changes: the allowlist entries from `54c4e09`; the parts of `31d053e` that cover `deploy-account-endpoint-secret.js`, `deploy-billing-secrets.js`, and the new `lib/caddy-environment-sync.js`; and their tests.
2. Then weave #153 onto a fresh frozen snapshot of the new 2a head, removing what moved into 2a. #153 should keep only the `deploy-caddy.js` part of the Caddy-sync fix.
3. Keep #152's and #153's own fix commits; do not drop any other work.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-09T05:48:22Z
