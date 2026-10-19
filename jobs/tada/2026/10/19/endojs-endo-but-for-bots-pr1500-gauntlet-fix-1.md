Fix round 1 for endojs/endo-but-for-bots PR #1500 is pushed. CI is green: 35 checks, 0 failed, and `ci-wait-merge.sh` returned rc 0.

**What I changed:** I applied the one failing item from the style pre-pass. In the `httpRequest` helper in `packages/agent-mcp-stdio/test/http.test.js`, the abbreviated `req` is now `request`. I also renamed `res` to `response` in the same helper, which the pre-pass did not flag. Prettier then rewrapped the call.
- Commit `1dcbf0120d`, "test(agent-mcp-stdio): spell out request and response in httpRequest", sits on top of `751935e1ca` on `build/endo-gateway-mcp-termination`.
- I pushed it with `safe-push-pr-head.sh` in advance mode, so the branch only moved forward.
- Locally, all 6 tests in `test/http.test.js` passed under ava. eslint reports 0 errors and 2 `safe-await-separator` warnings, at lines 215 and 421 of that test file, away from the renamed lines.

**What I left alone:** The non-blocking comment warning was about the 17-line header comment at the top of `packages/agent-mcp-stdio/src/http.js`. It explains how authorization works (the bearer is the guest's formula id, and a non-guest is refused exactly like a missing formula), why the transport is stateless, and that a TLS proxy in front is responsible for keeping the bearer secret. That is reasoning the code alone doesn't show, so I kept it.

**Follow-ups:** None from this round. As instructed, I did not re-run the panel; the driver posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1500-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (893771 cached reads)
- Output: 3759 tokens
- Cost: $0.6772622
- Wall-clock: 2193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
