The Claude-on-minion.town arc (kriscendobot/garden#89) has a new maintainer decision to make, so I asked one question and posted a press comment. I posted no jobs.

**What changed since the last press (2026-09-30 00:43Z)**
- **Item 5, endojs/endo-but-for-bots#1371 (draft, CI green):** the first real Claude turns through the confined launcher ran at 00:52Z, on a scratch daemon on a garden host rather than production.
  - A subscription token fails when passed through `apiKeyHelper`, but works when passed through `--settings` `env`. The fix is commit `ed7ffe23c2`, which also stops the turn after two 401 errors.
  - The guest's tools were reached, and the relay process had an empty environment.
  - **New security hole:** when a host formula id appears in the prompt, the guest can call `storeIdentifier` with it and ends up holding its host (`?type=host`).
- **Item 4, endojs/endo-but-for-bots#1357 (design gauntlet):** panel round 3 came back must-fix. Among the findings, Decision 9 drops the rule that a guest-influenced prompt must run inside the sandbox. Round 4 is queued.
- No change on minion.town PRs #140, #105 and #106, or on endo-but-for-bots #1369 and #1340. `minion-town-pr87-production-gate-resume-20260922` is still parked, waiting on the maintainer.

**Actions**
1. **Maintainer question** (sent 04:34Z): how to close the `storeIdentifier` hole.
   - (a) Remove the tools that mint identifiers from what the confined agent and the broker allow.
   - (b) Have the daemon refuse to let a guest store an id it was never granted.
   - I recommended (a) now, plus a design job for (b).
2. **Issue #89 body:** updated the "as of" line, item 5's evidence (including the new escalation and the remaining follow-ups), and item 4's gauntlet status. The architecture and item specs are unchanged.
3. **Issue comment:** https://github.com/kriscendobot/garden/issues/89#issuecomment-5904114796. The new decision comes first, then the ask still pending since 2026-09-29 08:40Z to promote the parked pr87 job, then the two state changes.

**Why no jobs:** nothing unblocked is sitting idle. Round 4 of the #1357 gauntlet is already in `todo`. The fixes on #1371 wait on the answer to the question above, and item 4's real provider waits on the pr87 job being promoted.

**Follow-up:** once the maintainer answers, the next press posts the matching #1371 fix job. Until then, later presses only check for the answer and post no new work.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260930-033506.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (903630 cached reads)
- Output: 6406 tokens
- Cost: $0.842526
- Wall-clock: 98s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
