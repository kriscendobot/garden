I'm stopping PR #1591 at the viability gate: the result is **overtaken**. The fix it makes is already covered by an older, more advanced PR, #1542, which edits the same driver file for the same bug.

**Deciding question:** Is #1591 the only live fix for the bwrap sandbox process (the init) being left orphaned when the launcher dies before it arms `--die-with-parent`, so that running a full gauntlet on it isn't duplicate work?

**Answer:** No.

**Evidence:**
- **PR state:** #1591 is open and still a draft. It was opened today (2026-10-31T14:04Z) on base `llm-9a14ddf`, head `2c3ab022`, and has no reviews or comments yet. It changes `packages/sandbox/src/drivers/bwrap.js`, adding `process.kill(-child.pid, 'SIGKILL')` on the bwrap leader's `exit`, and loosens the cleanup bound in `packages/sandbox/test/bwrap.test.js`.
- **Competing PR:** #1542, "fix(sandbox): make bwrap tests pass on Ubuntu 26.04 and kill the sandbox init on cancel", opened 2026-10-22, is open and out of draft. It names the same root cause: bwrap arms `--die-with-parent` late, so a launcher killed during setup leaves its init stranded. It fixes this in the same driver file, more robustly: it learns the init's pid via `--info-fd` and kills the init directly after proving it still owns that pid. If no report arrives, it falls back to signalling the process group. It adds a real-bwrap test that cancels 40 spawns across the setup window and checks for survivors, plus fake-launcher tests for each kill boundary. It has been through the panel and three fix rounds, and CI on its head is green (14 passed, 20 skipped, 0 failed).
- **Likely flaw in #1591's approach:** #1542's test notes say the bwrap init leaves the host process group via `setsid()`. If that's right, #1591's group-wide kill would not reach the orphaned init at all. This is a strong reason to prefer #1542, though I did not verify it by running anything.
- **Missing link:** #1591's description cites #1504, #1566 and #1571 but never mentions #1542. It looks like it was built without knowing #1542 exists.
- **Base history:** nothing has landed on `llm` since `9a14ddf` that touches `packages/sandbox`. Neither fix has merged, so the flaky test is still a real problem. The cheaper way to fix it is to land #1542 (maintainer action) and weave the red PRs onto it, not to run a second competing fix through the gauntlet.

Option: close as superseded

Follow-up for the maintainer: either close #1591 as superseded by #1542 and move #1542 to merge, or, if #1542 is being dropped for some reason, re-stage #1591 through the explicit "run the gauntlet #1591" ask. I spent no clean, panel, fix, CI-wait or un-draft budget, and made no commits.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1591-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (317499 cached reads)
- Output: 3671 tokens
- Cost: $0.4804478
- Wall-clock: 95s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
