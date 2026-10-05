Fix round 1 for kriscendobot/minion.town PR #160 is done: the one must-fix is pushed and CI is green (3/3 checks passed).

**The must-fix:** panel round 1 had one, from the saboteur seat. In `src/endo/claude/claude-guest-bridge.ts`, `closeBroker` threw away every error, so when `broker.close()` failed (for example an `fs.rm` EBUSY or EACCES), the broker's `0600` socket directory was left behind and nothing was logged.

**What changed** (commit `061a975`, pushed with `safe-push-pr-head.sh`, moving the head from `004d905` to `061a975`):
- **Close failures are now reported.** A failed broker *start* is still dropped quietly, because its caller already saw that error. A failed *close* now goes to `options.diagnose({ reason: "broker-close-failed", guestFormulaId, message })`.
- **Two new tests in `test/claude-guest-bridge-reconnect.test.ts`:**
  - A broker whose `close()` throws is reported through `diagnose` when its connection closes.
  - Retiring a broker whose start failed reports nothing.
- **Checks run before pushing:** the bridge test file and `claude-cli-backend.test.ts` pass (26 tests), and `tsc --noEmit` is clean.

**Follow-ups:** none. I left the reviewers' should-fix and comment-only items alone (the main one: the broker is resolved with the root host plus an ID, which the reviewer says belongs upstream). The driver posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (666257 cached reads)
- Output: 4046 tokens
- Cost: $0.6036754
- Wall-clock: 361s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
