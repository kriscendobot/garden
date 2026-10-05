---
role: builder
arc: claude-on-minion-town
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Route the Claude account page through Caddy

Fix the live 404 reported at https://github.com/kriscendobot/garden/issues/89#issuecomment-5996039708 in https://github.com/kriscendobot/minion.town.

Diagnosis at `origin/main` commit `9d563c9`: the Node app mounts `/account/claude`, but `deploy/aws/caddy/conf.d/minion-town.caddy` only proxies the exact `/account` path. Authenticated requests for `/account/claude` therefore fall through to the static-file handler and return 404. The unauthenticated production request redirects to sign-in, which is why the defect appears only after authentication.

Add a specific Caddy route for `/account/claude` and `/account/claude/<nonce>` before the static fallback. Preserve the existing forward-auth flow, forward `X-Auth-Request-Sub`, and attach `X-Account-Gate-Token` before proxying to the app. Add deterministic coverage that would fail if these paths fall through to static serving. Strengthen deployment verification to exercise the stable account path through the relevant routing layer, not only the Node loopback nonce route. Do not expose or request any Claude setup token.

Open a draft pull request with `/home/kris/garden/scripts/jobs/gardening/ensure-pr.sh`, run local verification, and stage the normal gauntlet. Reply on the issue thread with the pull request URL and evidence. Never close the issue.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-89
issue_url: https://github.com/kriscendobot/garden/issues/89#issuecomment-5996039708
submitter: kriscendobot
----- END ISSUE NOTE -----
