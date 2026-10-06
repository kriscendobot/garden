Panel round 4 on endojs/endo-but-for-bots#1426 ("render the Familiar security-warning banner") came back **must-fix**. I posted the verdict on the PR, and as this stage requires I didn't fix or un-draft anything.

**How the round ran**
- I reviewed the PR head `962358b45f` (branch `feat/familiar-security-warning-banner`) against base `llm-395c485`, in an isolated checkout made for this job.
- `panel.sh` in single-round mode exited 0. All 33 seats returned with no seat errors, and the decider ruled must-fix.
- Seats asking for changes: assessor, prover, saboteur and wire-watcher. Eight seats left comments only, and 16 approved.

**Blocking findings**
1. **Restarting or purging the daemon skips the defense re-check.** `handleRestartDaemon` and `handlePurgeDaemon` reload the Chat window with `win.loadURL(...)` (`packages/familiar/electron-main.js` around lines 211 and 238). The reload never calls `verifyExfiltrationDefenses()` again. Instead, a `did-finish-load` listener in `packages/familiar/src/security-warnings.js` (around lines 77–89) replays the warnings captured at startup. Because the page is rebuilt from scratch, a banner the user dismissed also comes back, which breaks the banner's own documented rule that a dismissal holds until a new warning arrives. Saboteur and assessor raised this; wire-watcher flagged it as should-fix.
2. **The previous round's fix has no regression test.** No test covers the `app.on('activate', …)` → `verifyAndWarn(mainWindow)` path. Reverting it to reuse the startup warnings would still pass every test (from prover).

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1426#pullrequestreview-5424545704
- It went up as a COMMENT review, not request-changes, because GitHub refuses request-changes from the bot on its own PR. Rounds 1–3 were posted the same way.
- The full aggregate is about 78 KB, which is over GitHub's limit for a review body. The posted review has the disposition header, a summary of the blocking findings, full findings from every seat that didn't approve, and the approving seats by name only.

**Next step:** the fix-loop stage should address both blocking findings: re-run the defense check on restart and purge reloads, and add a test for the per-window re-check path.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1426-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (920073 cached reads)
- Output: 5319 tokens
- Cost: $0.7738746
- Wall-clock: 1343s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
