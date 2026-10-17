PR #192 was not merged: `ci-wait-merge.sh` refused at its first step because this host's bot token can't read CI status, and the PR is unchanged.

**What I did**
- Got an isolated checkout of `fix/node-install-root-ownership` (`scratch/project-wt-screen--7fb417249239-c3f661ac`) and ran `scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 192 --screened-delegated-merge`.
- It exited with rc=1 and `ci-read-forbidden`. On host `oros-studio-garden-ce242c49` the token gets a 403 ("Resource not accessible by personal access token") when it reads `statusCheckRollup`. A delegated merge won't fall back to reading CI from the Actions API alone, so it stopped there.

**State of PR #192**
- Still OPEN, base `main`, head `ed7255bbebffd8f397303c1a20adbabe05edd436`, the same commit that was screened. Nothing was rebased, force-pushed or merged.
- As the job instructs, I did not try an ordinary merge, did not queue `--auto`, and did not ask for approval.

**Why this host claimed it**
The job was posted before commit `f5477a650ff` ("pin delegated conductors to the CI-reading host") reached `main2`, so it has no `requires: host=` line and any host could take it. That commit:
- makes the screener pin each conductor to its own host, which can read CI;
- makes `ci-wait-merge.sh` check that it can read CI before it rebases anything. That check is why the head is still at the screened commit.

**Follow-up**
PR #192 still needs a conductor job pinned to the screener's host. I'm not sure the proxy will post one by itself, because the screening record for this commit already exists. If it doesn't, the liaison or proxy should post that conductor for #192 at `ed7255b`. Fixing the token's CI-read permission on `oros-studio` would also remove the problem.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/screen-minion-town-pr192-ed7255b-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (196331 cached reads)
- Output: 1492 tokens
- Cost: $0.34829020000000005
- Wall-clock: 72s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
