I opened a revert of merge `f6fe2b5` as the heal: https://github.com/kriscendobot/minion.town/pull/211 (draft). It hasn't merged yet, so production is not restored. The gauntlet should be staged by the completion hook once it reads this report.

**What broke:** run 39617782849 failed at **Deploy app (minion-mcp)**. The new app exits right after it starts:

```
Error#1: guest bond index unavailable (run deploy/aws/scripts/deploy-accounts-store.sh): ValidationException
```

https://github.com/kriscendobot/minion.town/pull/200 needs a migration before it can deploy. `deploy-accounts-store.sh` adds the `guest-formula-fingerprint` DynamoDB index and the app role's `Query` grant. It has to run as the fleet admin, which CI's scoped role can't do, and nobody ran it before the merge.

**Current state:** the deploy smoke put the previous app build back, but every later deploy step was skipped (gateway, git remote, login gate, npm registry, Caddy, www). So `main` and production now disagree.

**Why a revert:** the app refusing to start without the index is a deliberate fail-closed check in #200. Weakening it to get a green deploy would hide the missing migration. Running that admin migration on production myself was outside what this job allows.

**What changed:**
- **Branch:** `heal/revert-pr200-f6fe2b5` holds one commit, `git revert -m 1 f6fe2b5`, touching 38 files.
- **PR base:** the PR targets a frozen copy of `main` named `main-f6fe2b5` rather than `main` itself, because `ensure-pr.sh` refuses to open a PR against plain `main`. The conductor retargets it to `main` at merge time.
- **PR body:** carries the `<!-- garden-heal: f6fe2b522cacc8443e45fb42676243cd9edb8cb3 -->` marker so the proxy will screen and merge it.
- **Untouched:** nothing was pushed to `main`.

**Follow-up:** to land #200 again, the fleet admin runs `deploy/aws/scripts/deploy-accounts-store.sh`, then reverts this revert. I sent the maintainer inbox a note saying this; no reply is needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/heal-minion-town-f6fe2b5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (707564 cached reads)
- Output: 4968 tokens
- Cost: $0.6932567999999999
- Wall-clock: 120s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
