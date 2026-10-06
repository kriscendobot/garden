## Gauntlet UNDRAFT: kriscendobot/minion.town#163 is now ready for review

**What I did**
1. **Idempotence check:** the PR was OPEN and still a draft, so this stage had real work to do. It is "fix(deploy): restart caddy when its gate-token env changes", 9 files, +721/−36, on frozen base `main-9ac858d`.
2. **Advisory appellate pass (non-blocking):** I read the diff myself instead of running a separate `claude -p` review, to stay inside the job budget. I found nothing that needed recording against the PR.
   - The new `deploy/aws/scripts/lib/caddy-environment-sync.sh` is inserted into the SSM heredocs as plain text through `$CADDY_ENVIRONMENT_SYNC`, so its `$` and backticks are not evaluated a second time. Box-side variables in the calling scripts are escaped correctly (`\$?`, `\$caddy_status`).
   - In the secret scripts, a caddy-side failure is recorded and the run fails only after `minion-mcp` restarts, so the app is never left running on its old secret. `deploy-caddy.sh` fails right away instead.
   - Restarts run only after `caddy validate`, wait for caddy to come back for a limited time, and are serialized with `flock`. Secrets are compared by SHA-256 hash and never printed. The docs (`DEPLOYMENT.md`, `deploy/aws/README.md`) were updated to match.
   - One harmless comment change: the backticks were removed around `caddy adapt` in a comment in `deploy-caddy.sh`.
3. **Un-draft:** I ran `gh pr ready`, and the PR now shows `isDraft:false, state:OPEN`.

**What changed:** only the PR's draft flag. I made no garden repo commits.

**Follow-ups:** none from this stage. Merging is the maintainer's call (or a `merge #163` conductor job).

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172375 cached reads)
- Output: 1420 tokens
- Cost: $0.4439310000000001
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
