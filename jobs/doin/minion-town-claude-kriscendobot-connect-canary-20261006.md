---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
requires: aws

# Connect kriscendobot's own Claude subscription on minion.town, then run the production canary

Arc: https://github.com/kriscendobot/garden/issues/89 (items 4 and 5). kriskowal approved
https://github.com/kriscendobot/minion.town/pull/164 ("Proceed"), whose stated purpose is to let
the fleet drive the `/account/claude` connect flow itself as kriscendobot rather than waiting on the
maintainer's own sign-in. #164 is merged and verified live (job `minion-town-verify-claude-root-subjects-ea5263d`):
`ENDO_CLAUDE_ROOT_SUBJECTS` now includes kriscendobot's GitHub-federated subject
`79b9090e-20a1-70d2-94c7-717257e2be34`, and `/account/claude` returns 200 for it.

1. Sign in to https://minion.town/account/claude as kriscendobot through Cognito's GitHub federation
   (skill `skills/minion-town-mcp-playwright-login/SKILL.md`; disposable profile).
2. Obtain a kriscendobot subscription token with `claude setup-token` and submit it on that page.
   NEVER print, log, commit, message, or journal the token; pipe it straight into the form.
   If the token cannot be obtained non-interactively, stop and ask the maintainer ONE question via
   `message-user.sh` naming exactly what is needed.
3. Then do the work of the parked `minion-town-claude-cli-production-canary-after-connection-20261004`
   (read it in `jobs/plan/`), substituting subject `79b9090e-…` for the maintainer's subject: SSM
   preflight, then the four redacted observations (connect + confinement probe; root
   createClaudeAgent → child infer real result; child cannot reach beyond its guest facet and has no
   ANTHROPIC_AUTH_TOKEN in its spawn env; disconnect then infer fails cleanly). Do its authorized
   closeout, then retire that parked job with `scripts/jobs/withdraw-plan.sh` so it does not double-run.
4. Report the evidence on garden#89 (one concise comment) and in your completion report.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T03:41:33Z
