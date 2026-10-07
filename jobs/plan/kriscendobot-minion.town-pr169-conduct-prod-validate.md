---
gate: blocked
blocked_on: kriscendobot-minion.town-pr169-gauntlet
priority: normal
arc: minion-town-mcp-ocapn
posted_by: producer
posted_at: 2026-10-07T22:22:00Z
---

---
role: conductor
requires: aws
tier: mentor
fallback-tier: minion
dispatch: automatic
---

**Role: conductor.** Land kriscendobot/minion.town#169 (deploy secret preflight + CD provisioning) once its gauntlet has un-drafted it, then validate in production.
- Merge needs an effective maintainer APPROVED review on GitHub. If it is absent, send ONE maintainer message requesting review, with the gauntlet outcome, and wait as conductor does.
- After merge, confirm the CD run provisions the secret and deploys green.
- Over SSM, on the production host, verify: the secret is present (presence only, never the value); `minion-mcp` is active with no crash-loop (NRestarts stable); the preflight ran and passed in the deploy log; the guest API and landing page respond.
- **Negative check:** in a dry-run or staging invocation, show that the preflight fails loudly when the secret is unreadable. Never remove the production secret.
- Recovery notes: the EADDRINUSE orphan recipe and the 89481580 crash-loop lesson are in the minion.town memory notes on this host.
- Report evidence: CD run URL, unit status, log lines.

PR: https://github.com/kriscendobot/minion.town/pull/169
