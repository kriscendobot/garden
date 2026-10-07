Fix round 1 for kriscendobot/minion.town#167 is done: the panel's one must-fix is applied, pushed to the PR head, and CI is green (3/3 checks, no failures).

**Panel verdict (round 1, head `e0b7702`):** 9 of 9 seats ran. The copyeditor asked for changes, six seats left comments only, and two approved. The only must-fix was the copyeditor's: the opening of § 2.3 was a sentence fragment.

**What changed:** one review-feedback commit, `7c4ddc7`, editing only `designs/root-canary-principal.md`. I pushed it with `safe-push-pr-head.sh`, which fast-forwarded the branch from `e0b7702`. Besides the must-fix, I folded in the inexpensive should-fixes from the other seats:
- **Must-fix:** § 2.3 now reads "The secret lives in Secrets Manager at `minion/root-canary`. …"
- **Verification step (critic and skeptic):** the build scope now starts with a step 0. A throwaway Cognito client must show that:
  - the refresh token comes back for the GitHub-federated user;
  - the refreshed token's `sub` is the same as the human root's;
  - refreshing needs the client secret, and one token can be reused while rotation is off;
  - `RevokeToken` works.

  If any of these fails, the build stops. Open question 8 (whether other surfaces accept any token from the pool) is now answered by that step, before anything is built.
- **Leftovers from killed runs (decomplector and skeptic):** each canary run first cleans up canary-named children and pet names older than one hour. The canary owns this cleanup. The doc also says plainly that keeping canary data apart from the human root's data relies only on the name prefix, and that this is an accepted cost.
- **Wrapper behavior (ergonomist):** the wrapper exits 75 when the credential is unavailable. For runs longer than 15 minutes it provides `MINION_MCP_BEARER_CMD`, a helper that prints a fresh token. The scripts are renamed to share a `root-canary-` prefix: `root-canary-deploy-client.sh`, `root-canary-mint.sh` and `root-canary-exec.sh`.
- **§ 2.4 tradeoffs (critic):** the cost of a 30-day refresh-token lifetime is now spelled out: a monthly human sign-in, with the risk that the canary silently stops running behind an unanswered reminder. The fast revocation option is noted to require restarting `minion-mcp`. The expiry reminder now includes the mint command and the token's mint date.
- **Audit log line:** it must be deployed before the canary is switched on.
- **Readability:**
  - the Problem section now explains what the canary is and defines its project terms;
  - § 2.1 explains how the secret and PKCE fit together, and says the builder must check which token claims the verifier reads;
  - § 2.2 ends with a one-line summary of the cost;
  - the § 2 heading is capitalized correctly;
  - § 2.5 item 4 no longer has the explanation inside the list.
- **Open questions:** they are now sorted into what blocks the build (1, 2, 4, 8), what must be answered before switching the canary on (3, 5), and later follow-ups (6, 7).

**Not addressed:** some comment-only items, for example aligning the IAM role name `minion-root-canary-reader` with the others, and adding a lead-in to the ownership-map table.

**CI:** `ci-wait-merge.sh --no-merge` exited 0. The PR is still a draft; the gauntlet driver will post the next panel round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (631526 cached reads)
- Output: 7234 tokens
- Cost: $0.7562331999999999
- Wall-clock: 385s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
