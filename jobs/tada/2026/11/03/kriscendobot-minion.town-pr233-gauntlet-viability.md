`viability=proceed`. PR #233 is open and unmerged (draft, head `d953febe`, base `main-c5c3504`), and I spent no clean, panel, fix, CI-wait or un-draft budget.

**Deciding question:** On current `main`, does the root user's MCP guest still have no way to mint an invitation, with no newer PR or design already providing one?

**Answer:** Yes, so the PR is not superseded and its motivating need still holds.

**Evidence:**
- **Base history:** `main` is identical to the PR's base `c5c3504` (compare shows 0 ahead, 0 behind), so there is no newer base history that could have displaced it.
- **Gap still open on `main`:**
  - `src/endo/mcp-tool-names.ts:76-81` still lists `invite` and `cancelInvite` as reserved only.
  - `src/endo/guest-control.ts` has no invite references.
  - `src/web/local-invitations.ts` does not exist.
  - Design § 7 still spells the tool `guest_invite(guestName)`.
- **Need is current:** The garden#58 supervisor tick of 2026-11-03T09:17Z names this as a new blocker: "the root user cannot extend an invitation yet". Local invite, accept and mail were proven on production that day, but the root acts through its MCP guest. The browser Settings route belongs to a different guest, and the `legacy-root` migration that would join the two is not built. The producing job `build-minion-town-mcp-guest-invite` records the same goal as a 2026-11-03 maintainer goal.
- **No competing work:** An all-state PR search for "invite", plus the open PR list, found nothing that replaces this PR:
  - **#102:** the older remote-invitation attempt, idle since 2026-09-17. It depends on an unmerged Endo primitive, and the build brief scoped remote invitations out.
  - **#234:** a companion that adds a prod-probe check for local invitations, not an MCP tool.
  - **#199:** coupon admission, still an open draft. #233 deliberately leaves the coupon argument to its follow-up job.
  - **#81:** merged earlier, and it provides the web invite and accept routes that #233 builds on.
- **Discussion:** #233 has no comments or reviews, so nobody has objected to it, and my job inbox was empty.

**Possible conflict:** #199 and #234 are both on the same `main-c5c3504` base and also touch guest web code, so whichever merges first may require a re-weave of #233. That is a sequencing matter and does not affect viability.

**Checks not read:** The bot token can't read the PR's status check rollup, so I did not look at CI status. This gate doesn't need it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr233-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (214085 cached reads)
- Output: 3924 tokens
- Cost: $0.543593
- Wall-clock: 138s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
