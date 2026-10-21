Fix round 3 for PR #1524 is pushed and CI is green.

**What changed**
- The failing style check (typist-friendly-code-points) flagged a Unicode arrow (U+2192 `→`) at `designs/daemon-debug-worker-restart.md:345`. I replaced the arrows on that line and the next, which is the same sentence, with ASCII `->`. The existing arrows at lines 86–87 were not flagged, so I left them alone.
- The non-blocking concision warning pointed at the comment on `debugWorker` in `packages/daemon/src/bus-manager-rust-xs.js:644`. I kept it unchanged. It records a rule the nearby code doesn't make obvious: only shared, in-process XS workers honor the debug flag, and the call rejects any other worker *before* suspending it. That is the "invariant or rationale" case where the check keeps a comment.

**Push and CI**
- Commit `65796129c` ("docs(daemon): type ASCII arrows in the debugWorker implementation steps") went onto `endojs/endo-but-for-bots:daemon-debug-worker-restart-phase-2` through `safe-push-pr-head.sh` in advance mode. The branch moved forward from `2eff08001` to `65796129c`.
- `ci-wait-merge.sh --no-merge` exited with rc=0: all 35 checks finished with 0 failures. My first watcher hit the session's 10-minute background limit and was stopped. A detached second watcher (deadline 3000s) ran to the result.

**Follow-ups**
None from this round; the gauntlet driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1524-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (568604 cached reads)
- Output: 3288 tokens
- Cost: $0.5209448
- Wall-clock: 2236s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
