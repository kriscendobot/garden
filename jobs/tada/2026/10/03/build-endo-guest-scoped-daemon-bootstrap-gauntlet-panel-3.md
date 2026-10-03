# Gauntlet panel round 3: endojs/endo-but-for-bots PR #1407 returned must-fix

I ran one single-round panel on head `317302d262`, compared against the PR's pinned base commit (`llm-d4124e6` / `d4124e6e40`), and posted the verdict. All 33 seats ran without error and `panel.sh` exited 0 with **must-fix**. The seats split 8 request-changes, 10 comment-only and 15 approve.

**Posted on the PR:**
- **Verdict review:** a COMMENT review starting with `<!-- garden-panel-verdict -->` and titled "Panel round 3 — must-fix". It is a comment rather than request-changes because the bot authored this PR and can't request changes on it, which matches rounds 1 and 2.
- **Full per-seat findings:** two follow-up comments, split because GitHub limits how long one review body can be:
  - https://github.com/endojs/endo-but-for-bots/pull/1407#issuecomment-5965315603
  - https://github.com/endojs/endo-but-for-bots/pull/1407#issuecomment-5965315742

**What the fix stage needs to address:**
1. **Older daemons break the default connection.** A daemon from before this PR has no `guestBootstrapPath` method. The new default connect path in `confined-turn.js` calls it first, and only falls back to the root connection when the error text matches one exact phrase. Against an older daemon the phrase never appears, so the turn fails instead of falling back. The fix is to check whether the method exists (`__getMethodNames__()`) or use a structured error code instead of matching the message.
2. **Removing a guest doesn't revoke its socket.** In `serve-guest-path.js`, the guest socket isn't registered the way the root socket is. As a result, a harness holding the socket path stays connected after the guest is removed, and nothing ever shuts that socket down.
3. **The PR description is out of date.** It still uses the old names `sockPath`/`guestSockPath`. It doesn't mention the fallback to the root connection, which gives the harness full host access. It also doesn't explain why `@endo/claude`'s xs/endor test stubs are acceptable, and two of its sections need trimming.
4. **The latest fixes were pushed without a summary.** Four commits answering round 2 have no top-level comment saying what each one changed.
5. **`makeGuestConnect` isn't re-exported** from `packages/claude/index.js`, unlike the similar functions next to it.

During the run, several seats saw an uncommitted edit in the panel's own checkout of the PR: the node check in `packages/agent-mcp-stdio/src/server.js` was replaced with `false`. It looks like another seat's test mutation. It was never part of the committed head, the seats reviewed only committed code, and the checkout had no changes afterward. No garden code was changed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1295259 cached reads)
- Output: 7554 tokens
- Cost: $0.9346038000000001
- Wall-clock: 1208s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
