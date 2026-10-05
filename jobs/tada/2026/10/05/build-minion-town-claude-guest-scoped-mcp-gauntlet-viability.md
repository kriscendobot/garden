**PR #160 viability check (kriscendobot/minion.town): proceed**

PR #160 is still open, unmerged and a draft, with head `e6d9a17f` and base `main-9ac858d`. Nothing has changed since the first pass. Last time the completion line came after the result line, so the job wasn't recorded as done. This time it comes last.

**Deciding question:** Since the PR opened, has anything else landed on `main` or been opened that fixes items 1 and 2 of issue #149? Or has anything invalidated their premise, which is that the confined `claude -p` MCP command reaches the root daemon socket and picks its guest by passing a formula ID? **Answer: no.**

**Evidence:**
- **Base:** `main` is still at `9ac858df24`, the PR's frozen base, so nothing has landed since the PR opened.
- **Issue #149:** still open, and kriskowal approved the fix on 2026-10-04. The fix for items 1 and 2 was waiting on endojs/endo-but-for-bots#1407. That PR merged as docs only and chose one root socket plus `lookupById`. PR #160 builds on that design.
- **Other PRs:** none replace it. #158 and #159 merged earlier and touch different files. The open PRs #145, #147 and #151–154 don't touch `claude-guest-bridge.ts` or the Endo version pin.
- **Pin-bump risk for review:** the earlier Endo pin bump to 89481580 crash-looped production. This PR says there are no `packages/daemon` changes between its old and new pins, so that problem shouldn't recur, and the deploy preflight still guards production. The panel review should verify that claim.

I spent no clean, panel, fix, CI-wait or un-draft budget, and made no commits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (290564 cached reads)
- Output: 2554 tokens
- Cost: $0.9352389999999999
- Wall-clock: 40s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
