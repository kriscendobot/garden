---
role: builder
tier: mentor
fallback-tier: minion
arc: minion-town-mcp-ocapn
handler-timeout: 7200
dispatch: automatic
---
**Role: builder.** In https://github.com/kriscendobot/minion.town, make deploys survive a missing startup secret.
1. Add a **pre-restart preflight** to `deploy-app.sh`: it fails the deploy loudly, before restarting anything, when the app's required startup secret is absent or unreadable on the target host.
2. Make **CD provision that secret** so the preflight passes on a fresh or rotated host, with no hand-run script.

**Background (job `minion-town-pr81-deploy-recover-27a6e2bf`; maintainer message `liaison-followup-847507094048`).** The app needs a secret at startup that only a hand-run script provisions. CD neither runs that script nor checks for the secret, so a fresh host or a rotated secret crash-loops on deploy.

**Maintainer directive (kriskowal, liaison muster 2026-10-07):** "Build it, go through the gauntlet, land it, provision the CD secret, validate it in production."

**Constraints:**
- Secrets stay where minion.town keeps them today. Use SSM Parameter Store or Secrets Manager, read by the deploy step through its existing IAM role, or a GitHub Actions secret. Choose whichever the current CD already uses for its other secrets, and say which in the PR.
- Never echo a value in logs. The preflight checks presence and readability, not content.
- Least privilege: if CD needs a new IAM permission, scope it to that one parameter and document it in the PR body.
- Follow the minion.town gauntlet mechanics (`GARDEN_YARN=npm`, rebase before each push since `main` moves).
- Tests: the preflight fails with a clear message when the secret is absent and passes when present (stub the fetch).

Open the PR as DRAFT. Your successful completion auto-stages the gauntlet as `kriscendobot-minion.town-pr<N>-gauntlet`.

**Chained follow-up (do this before you complete, once you know <N>):** park the landing-and-validation step, blocked on that gauntlet:
```
scripts/jobs/post-plan.sh --blocked --blocked-on kriscendobot-minion.town-pr<N>-gauntlet --arc minion-town-mcp-ocapn kriscendobot-minion.town-pr<N>-conduct-prod-validate <body>
```
Its body, filled in with the PR URL (frontmatter `role: conductor`, `requires: aws`):

> **Role: conductor.** Land kriscendobot/minion.town#<N> (deploy secret preflight + CD provisioning) once its gauntlet has un-drafted it, then validate in production.
> - Merge needs an effective maintainer APPROVED review on GitHub. If it is absent, send ONE maintainer message requesting review, with the gauntlet outcome, and wait as conductor does.
> - After merge, confirm the CD run provisions the secret and deploys green.
> - Over SSM, on the production host, verify: the secret is present (presence only, never the value); `minion-mcp` is active with no crash-loop (NRestarts stable); the preflight ran and passed in the deploy log; the guest API and landing page respond.
> - **Negative check:** in a dry-run or staging invocation, show that the preflight fails loudly when the secret is unreadable. Never remove the production secret.
> - Recovery notes: the EADDRINUSE orphan recipe and the 89481580 crash-loop lesson are in the minion.town memory notes on this host.
> - Report evidence: CD run URL, unit status, log lines.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-07T22:09:44Z
