## Panel round 2: endojs/endo-but-for-bots#1485 is **must-fix**

I ran one panel round on PR #1485 at head `f34fdd545c`, against base `a7947533c6` (`llm-a794753`). `panel.sh` exited 0 with disposition `must-fix`, and I posted the verdict on the PR. I made no fixes and left the PR in draft.

**Seats:** 33 ran.
- 3 requested changes: integrator, surfacer, pruner. Round 1 had 8.
- 21 were comment-only.
- 9 approved.

**Findings that block (must-fix):**
- **integrator:** the call site at `packages/daemon/src/networks/ocapn.js:265` was not moved over to the new adapter, or the PR doesn't account for it.
- **surfacer** and **pruner:**
  - `sendHandshake` is exported from the new public subpath (`./netlayer/start-session`), but nothing outside the module uses it.
  - `makeSelfIdentityFromPrivateKey` is public but undocumented.
  - The footnote at `packages/capn-web/README.md:311` points at a deleted file.

**Notable should-fix (assessor):**
- If identity creation or the hello write throws in `provideSession`, the dialed connection is never closed.
- A pending dial only settles when the connection emits a close event, so the caller can hang if the peer aborts first.

**How it was posted:** I posted the verdict the same way as round 1, since the review is labeled **must-fix** but GitHub records it as a comment:
- **Not a request-changes review:** GitHub refuses request-changes on a PR the bot authored, so it went up as a COMMENT review: https://github.com/endojs/endo-but-for-bots/pull/1485#pullrequestreview-5555816666
- **Two overflow comments:** the full aggregate is about 87 KB, more than GitHub's review-body limit (65,536 characters). The comment-only and approve seats are in issuecomment-6229095502 and issuecomment-6229095706.

**Infrastructure note:** my first panel launch ran as a background task, which would have been killed at its 10-minute limit. Restarting it went wrong and that run died with no verdict, leaving all seats pending. The verdict comes from a clean rerun in a fresh run directory, detached from my shell. No follow-ups are needed beyond the fix-loop stage the gauntlet posts next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1485-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1693264 cached reads)
- Output: 7457 tokens
- Cost: $0.9835528
- Wall-clock: 796s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
