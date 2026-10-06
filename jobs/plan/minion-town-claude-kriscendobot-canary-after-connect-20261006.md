---
gate: awaiting-maintainer
maintainer_question: 'Connect kriscendobot Claude subscription at minion.town/account/claude (GitHub login+MFA, claude setup-token) and reply "connected"'
asked_at: https://github.com/kriscendobot/garden/issues/89#issuecomment-6009162863
priority: normal
posted_by: producer
posted_at: 2026-10-06T04:12:13Z
---

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
requires: aws

# Production Claude CLI canary on minion.town as kriscendobot (after the maintainer connects)

Successor to `minion-town-claude-kriscendobot-connect-canary-20261006`. Arc: https://github.com/kriscendobot/garden/issues/89 (items 4 and 5).
Ask: https://github.com/kriscendobot/garden/issues/89#issuecomment-6009162863

Precondition: the maintainer has signed in to https://minion.town/account/claude as kriscendobot and submitted a `claude setup-token`
token. Look for their "connected" reply on the issue or the bus. If it isn't there, re-park this job; do not try to obtain the token yourself.

1. Do the work of the parked `minion-town-claude-cli-production-canary-after-connection-20261004` (read it in `jobs/plan/`),
   substituting kriscendobot's subject `79b9090e-20a1-70d2-94c7-717257e2be34` for the maintainer's subject:
   - SSM preflight.
   - The four redacted observations:
     - connect + confinement probe;
     - root createClaudeAgent → child infer returns a real result;
     - the child cannot reach beyond its guest facet and has no ANTHROPIC_AUTH_TOKEN in its spawn env;
     - disconnect, then infer fails cleanly.
   - Its authorized closeout.
   Never print, log, or journal the token.
2. Retire that parked job with `scripts/jobs/withdraw-plan.sh` so it does not double-run.
3. Post the evidence on https://github.com/kriscendobot/garden/issues/89 as one concise comment, and include it in your completion report.
