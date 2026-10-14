Fix round 1 for kriscendobot/minion.town PR #186 is done: all three must-fix items from the panel are fixed and pushed, and CI is green on the new head `dabd857`.

**What changed:**
1. **Refresh failures no longer read as "refused" (archivist, assessor, breaker).** Only a 400 or 401 with Cognito's `invalid_grant` still counts as `refused`. A network failure, a 5xx, a 429, a 400 for any other reason, or a 200 with no access token now reports `reason=unreachable`. `root-canary-exec.sh` and `root-canary-status.sh --check` exit 1 for that, a failed canary, and keep exit 75 for the three credential-state reasons. The reasons table in `DEPLOYMENT.md` now tells operators not to re-mint for `unreachable`.
2. **The production audit wiring now has a test (prover).** The new `test/mcp-audit-http.test.ts` starts the real app with the Claude wiring on and a root subject configured. It opens a session, calls `dismissClaudeAgent`, and checks for exactly two audit records, `session-initialized` and `claude-tool-call`, with the right client, subject, session id, tool and child name. It also checks that the access token never appears in them. Lockdown freezes `console`, so a small helper, `test/helpers/record-console-info.ts`, records `console.info` and has to be imported before `@endo/init`.
3. **A re-mint revokes the token it replaces (breaker).** `root-canary-mint.sh` reads the existing secret, stores the new credential, then revokes the old refresh token; if that revoke fails it stops and tells the operator to run `root-canary-revoke.sh --yes` and re-mint. `root-canary-revoke.sh` also revokes a different token left in the secret's `AWSPREVIOUS` version. Both use a new shared revoke helper in `root-canary-common.sh`.

**Commits:** `ddeb3db`, `88213b9` and `dabd857`, pushed on top of `f10693f` with `safe-push-pr-head.sh` (no history rewrite).

**Checks:**
- **CI:** `ci-wait-merge.sh --no-merge` returned 0. On this host the token can't read the PR's combined check status, so the script fell back to the Actions runs API and saw one run, which passed; other kinds of status checks wouldn't have been visible.
- **Locally:**
  - The typecheck is clean.
  - The script tests all pass (13), including new ones for the 5xx, 429, non-`invalid_grant` 400, network-failure and missing-token cases, the exit mapping for `unreachable`, and revoking both the current and `AWSPREVIOUS` tokens.
  - The full suite had 2 failures out of 1071, and both fail again when run on their own: `endo-guest-lockdown` (a 5-second timeout, likely host load) and `git-remote/capability` (a git-failure test that didn't see the failure, likely this host's git setup). Neither file touches the code I changed, and CI is green.

**Follow-ups:** The mint-time revoke has no test, because the script only runs on `endolin-garden1` and needs an interactive login; it uses the same revoke helper the revoke test covers. Panel round 2 is left for the gauntlet driver to post.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2044635 cached reads)
- Output: 18727 tokens
- Cost: $1.5113229999999995
- Wall-clock: 1434s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
