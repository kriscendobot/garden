Viability: **proceed**. PR #169 is still open and has not been merged, and nothing has overtaken it. I spent nothing on clean, panel, fix, CI-wait or un-draft.

**PR facts:** kriscendobot/minion.town#169, "fix(deploy): preflight GUEST_RECOVERY_KEY before deploy-app restarts minion-mcp". It is OPEN and a draft. The base is `main-d750b09` (frozen at `d750b09b`) and the head is `d3f982ca`. A gauntlet run already posted a terminal status comment: `review-budget-reached`, 6 rounds, CI green.

Deciding question: On current `main`, does the app still need `GUEST_RECOVERY_KEY` (at least 32 characters) to start, while `deploy-app.sh` still checks nothing about that key before it restarts minion-mcp, with no merged change already doing this?

Evidence:
- **The motivating need still holds.** `src/auth/stores/dynamodb.ts:54-55` on `main` still throws "DynamoDB guest recovery requires a recovery key of at least 32 characters", and `src/config.ts` reads `GUEST_RECOVERY_KEY`.
- **The gap is still there.** `deploy/aws/scripts/deploy-app.sh` on `main` checks only `ACCOUNT_GATE_SHARED_SECRET` in `/etc/minion-mcp/account.env` (line 413). It has no `GUEST_RECOVERY_KEY` preflight, so a host missing the key would still crash-loop after a deploy.
- **The base hasn't moved on this.** `main` is 9 commits past `d750b09`, all from the clip-gutter PR #143 (shell/www/auth/design files plus `DEPLOYMENT.md`). None of them touch `deploy-app.sh`, `deploy-account-endpoint-secret.sh` or `minion-mcp.service`. `DEPLOYMENT.md` is the one file both sides changed.
- **Nothing supersedes it.** A code search finds `GUEST_RECOVERY_KEY` only in files this PR already edits plus `src/config.ts`. A PR search finds no other open or merged guest-recovery preflight.
- **Possible future conflict.** Open PRs #153 (ready) and #154 (draft) convert the deploy scripts to JavaScript, including `deploy-app` and `deploy-account-endpoint-secret`. Neither has been merged or touched since 2026-10-04, so they don't displace #169. Whichever lands second will need to carry the preflight across.

Follow-up: none needed for viability. Because of the earlier review-budget terminal, the next step after this gate is the maintainer's call: merge, un-draft, or re-run.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-20261008-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (225666 cached reads)
- Output: 2272 tokens
- Cost: $0.4512532
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
