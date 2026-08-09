---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Rebase kriscendobot/minion.town PR #18 onto main (make it mergeable)

PR #18 (feat/endo-daemon-guest-mcp-b3) is APPROVED by kriskowal but is CONFLICTING
against origin/main (10 behind / 3 ahead). Rebase/weave it onto current main and
force-push the head branch so it becomes mergeable.

The known conflict is a SEMANTIC one in `.github/workflows/deploy.yml`: this PR
adds an `endo-daemon` deploy lane + `[all, endo-daemon, app, oauth2-proxy, caddy,
www]` deploy_target options and a "Deploy Endo daemon" step; main has since added
an `endo-gateway` lane + `[all, app, endo-gateway, oauth2-proxy, caddy, www]`
options (powers plane / weblet gateway, PRs #24/#26). The correct resolution KEEPS
BOTH lanes: union the deploy_target options (all, endo-daemon, app, endo-gateway,
oauth2-proxy, caddy, www — dependency order) and both deploy steps, ordered so the
Endo daemon is installed/healthy before the app step that enables ENDO_SOCK.
DEPLOYMENT.md may also need a trivial content merge. Verify typecheck/build/tests
after the rebase. Do NOT change the PR's substance beyond conflict resolution.
Leave the PR a DRAFT — a follow-up conductor job un-drafts and merges.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-09T17:44:20Z
