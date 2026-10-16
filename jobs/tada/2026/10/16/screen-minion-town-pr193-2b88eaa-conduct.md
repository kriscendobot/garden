PR #193 was not merged: `ci-wait-merge.sh` stopped because this host's bot token can't read the PR's CI status.

**What I did**
- Made an isolated project checkout of `build/ocapn-guest-canary` (at `/Users/dom/garden/scratch/project-wt-screen--3e1df9c64e93-3d131391`). Its head is `2b88eaacaf83df2e0cee44fe0366e6195b405f38`, the commit the screen covered.
- Ran `scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 193 --screened-delegated-merge`, which exited with rc=1.

**What changed**
- Before the CI check, the script moved the PR's base from the frozen `main-30a4c62` to the live `main`. Three sibling PRs stay on `main-30a4c62`, and no stacks depend on #193.
- It then tried to read the CI status and got a 403: `GraphQL: Resource not accessible by personal access token (statusCheckRollup)`. Delegated merges don't accept the Actions-only fallback, so it stopped with `ci-read-forbidden … NOT pending — fix the token, then rerun`.
- After the run the PR is still OPEN, base `main`, head `2b88eaa`, mergeable MERGEABLE. The head did not move, so this is not an "awaiting re-screen" case.

As the job instructs, I didn't fall back to an ordinary merge, queue `--auto`, or ask for approval.

**Follow-ups**
- This host (oros-studio-garden-ce242c49) has a known gap: its bot token lacks `checks:read`, so every screened delegated merge for minion.town will fail here the same way. Either give the token CI read permission or pin these conductor jobs to a host whose token can read CI status, then rerun the conductor for #193 at `2b88eaa`.
- The base is already `main`, so a rerun won't need that step. If `main` has moved ahead of `main-30a4c62`, it may want a fresh CI run first.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/screen-minion-town-pr193-2b88eaa-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (193198 cached reads)
- Output: 1485 tokens
- Cost: $0.34410759999999996
- Wall-clock: 254s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
