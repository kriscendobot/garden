**Viability report — endojs/endo-but-for-bots#1591** ("fix(sandbox): sweep the bwrap process group when the leader exits")

PR #1591 is open, unmerged and still a draft. Its base is the frozen `llm-48d6f3e` and its head is `096c17adcf`. The fix rounds ran on the 17th, CI is green, and it is waiting for the panel to review it again.

Deciding question: Does `llm` still treat the bwrap leader's `exit` as the reap, with no SIGKILL sweep of the process group, while no other PR has landed a fix for the orphaned pid-namespace-init race?

Answer: yes. The PR has not been superseded and its premise still holds.

Evidence:
- **`llm`'s driver is unchanged.** In `llm`'s `packages/sandbox/src/drivers/bwrap.js`, `child.once('exit', …)` still resolves the exit straight away, and SIGKILL is sent only during teardown. Line 871 carries the comment "killProcessGroup declines a group whose leader Node already reaped", which is exactly the gap this PR closes. The last `llm` commit to that file is `4e40831281` from 2026-10-22, before this PR was opened, so no newer implementation has replaced it.
- **The flaky test is unchanged.** "bwrap timeout and repeated cancellation reap process groups" and its "survived bounded cleanup" error are still in `llm`'s `bwrap.test.js`. The last change to that file, `27705a4cdf` on 2026-10-28, adjusted assertions and did not fix the race.
- **The overlapping PRs are all still open:**
  - #1504 is the source of the cherry-picked fix.
  - #1566 is the source of the cleanup-diagnostics commit.
  - #1542 ("kill the sandbox init on cancel") and #1538 (bwrap cancellation) cover nearby ground.

  None of them is merged, so nothing on `llm` has displaced #1591, and the containment hazard and cross-PR CI flake still apply.
- **The earlier halt was a format problem.** The 2026-10-31 gauntlet stopped because that viability report was missing its required lines, not because the PR's substance had changed. Since then, fix rounds have answered the panel's containment findings.

Follow-up: the panel reviewers may want to check how #1591 overlaps #1542 so the two don't land conflicting bwrap-init kill logic. This doesn't block the gauntlet.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1591-gauntlet-20261117-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (191765 cached reads)
- Output: 1929 tokens
- Cost: $0.473333
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
