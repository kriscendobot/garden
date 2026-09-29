---
handed-off: kriscendobot-minion-town-endo-pin-post1015-deploy-verify-20260929
deliverable-complete: false
---
The pin is advanced on minion.town's `main`, but it isn't running in production yet. The first deploy took production down for about 5 minutes. I restored it by hand, and the box is back on the old pin `f9cbcfc` and healthy. The deploy-script fix (#139) has green CI but no conductor had picked it up after 90 minutes. I've posted a successor job to own the rest.

**What was done:**
- **Pin PR:** https://github.com/kriscendobot/minion.town/pull/138. The new pin is `1706e63247fb2c23b767f24fa1bd4b35d575089e`, the #1015 merge and current `llm` HEAD. It moves all three pinning sites together: `test.yml`, `ENDO_COMMIT` in `deploy-endo-daemon.sh`, and `PINNED_ENDO_COMMIT` in `captp-client.ts`. The federation script reads `ENDO_COMMIT`, so it follows.
- **Daemon changes since the old pin:** stored formula shapes are unchanged, the host, guest and directory methods are unchanged, and `client.js` is unchanged. Only mount `grep`/`glorp`/`entry()` behaviour changed, and minion.town calls none of them, so no test changes were needed.
- **`@endo/claude`:** it arrives as a private confinement core with no daemon formula. Nothing new becomes injectable into the `ENDO_CLAUDE_ENABLED` seams, so the Claude wiring is unchanged.
- **Checks against a real daemon at the new pin:** typecheck and build were clean. `npm test` passed 624 tests. The live-daemon integration suite passed 5/5 and the guest web invite test 2/2.
- **Restart over old state:** I populated a state store with the old `f9cbcfc` daemon, then booted the new daemon on it twice. The names and values survived, new writes worked, and there were no migration errors.
- **Merge:** CI was green, and the conductor merged #138 as `47d0c0b`.

**What went wrong with the deploy (run 36531062447):**
- The upgrade's dry run itself passed. But the deploy script checks the dry-run daemon by running `endo list` against its socket, and it did so before that socket existed. The endo CLI starts its own daemon whenever it can't connect.
- That stray daemon grabbed port 127.0.0.1:8920. The real `endo-daemon` then crash-looped on "address already in use" after the swap, and again after the automatic rollback, because the old version uses the same port. It restarted 30 times, from about 06:28 to 06:33Z.
- I restored production over SSM by killing the stray process. My own first health check then started a second stray on the real socket and state, which I also killed.
- The box now runs `f9cbcfc`: the unit is active, the socket connects, only the unit's own processes are running, and minion-mcp is active.

**The fix:** https://github.com/kriscendobot/minion.town/pull/139, CI green.
- Every check first requires the socket to accept a connection.
- Anything the CLI could still auto-start is sandboxed away from the real state and port.
- Stray endo processes outside the unit are killed after the dry run, before a rollback restart, and after a successful swap.
- I tested the rendered checks read-only on the box: they pass on the live socket, refuse a missing socket without starting anything, and leave the unit's processes alone.
- The conductor job for it (`conduct-kriscendobot-minion-town-pr139-20260929`) has been waiting in todo since 06:37Z.
- I told the maintainer about the outage through the liaison.

**I did not revert the pin.** The crash-loop came from the deploy script, not the new Endo version, and production is healthy on the old pin. The revert-and-fail fallback stays with the successor if the retried deploy fails.

**Open risk:** until #139 merges, `main` pins `1706e63` while the box runs `f9cbcfc`. Any other merge to `main` would retry the upgrade with the old, buggy check.

**Successor:** `kriscendobot-minion-town-endo-pin-post1015-deploy-verify-20260929`, parked in plan/ at high priority and blocked on the #139 conductor job. Once #139 merges, it will:
1. Watch or trigger the deploy.
2. Confirm the box runs `1706e63` without crash-looping.
3. If the deploy fails, restore production, revert the pin as #111 did, and emit the orchestration-failed signal.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-endo-pin-post1015-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 138 tokens (7074296 cached reads)
- Output: 36509 tokens
- Cost: $3.2023272000000005
- Wall-clock: 6819s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
