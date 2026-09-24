**Press tick 2026-09-24 ~04:4xZ: Claude on minion.town (kriscendobot/garden#89)**

The state changed since the last tick, so I updated the checklist and posted one comment: https://github.com/kriscendobot/garden/issues/89#issuecomment-5807774436. I posted no new jobs.

**What changed since the last tick (01:37Z):**
- **Item 5 design merged.** kriskowal approved endojs/endo-but-for-bots#1226 and it merged to `llm` at 04:16Z.
- **Item 5 build is up.** Job `build-endo-guest-stdio-mcp` finished and opened draft endojs/endo-but-for-bots#1336 on the pinned base `llm-6726b0f`. It covers only the single-tenant shape and its CI was still running.
- **Item 7 fallback fix is done.** Job `minion-town-guest-web-invite-accept-fallback-fix-20260922` finished. kriscendobot/minion.town#81 now pairs guests through the real guest invite and accept instead of the host-authority fallback. It was rebased onto `main`, is `MERGEABLE` with CI green, and is still a draft.
- **Correction:** the local journal copy still showed that fallback-fix job parked, but the live `journal2` branch had it finished.

**Issue edits:** in the body I changed only statuses and evidence: the as-of line, the item 5 and item 7 evidence, and the two blocker bullets. The architecture text and item specs are unchanged.

**Review asks in the comment:**
1. **run the gauntlet #81:** this unblocks the CapTP half of the item 7 eval build.
2. **run the gauntlet #1336**, once its CI settles: this unblocks the confined shape and the `@endo/claude` wiring of item 5, which together are the MCP half of item 7.

The re-review of endojs/endo-but-for-bots#1227 (item 6) is mentioned as still pending but off the critical path.

**Why no new jobs:** nothing new is unblocked yet.
- The CapTP eval build waits on #81 merging.
- The confined stdio shape waits on #1336 being reviewed and composes with endojs/endo-but-for-bots#1015.

**Follow-ups:**
- The maintainer's decision on those two gauntlet triggers.
- The #1336 builder reported one failing `git-flow` test in `agent-tools`. It is probably unrelated to the PR and may already fail on `llm`, but nobody has checked.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260924-043507.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (681958 cached reads)
- Output: 8164 tokens
- Cost: $0.8407915999999999
- Wall-clock: 89s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
