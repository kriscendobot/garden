**viability=proceed** for kriscendobot/minion.town#236 (open draft, head `b061893109`, base `main-9196892`, mergeable). I changed nothing and spent no gauntlet budget.

**Deciding question:** At current `main`, does a `kind: "remote"` invitation still go out with no served-hint filter, with no other change having replaced this PR's fix?

**Answer:** Yes, so the PR is not superseded and its premise still holds.

**Evidence:**
- **Base is current:** `main` is `919689231`, the same commit as the PR base, and the branch is 1 ahead and 0 behind. The PR was opened 2026-11-03T22:32Z, so there is no newer base history.
- **Fix is not on `main`:**
  - `src/endo/guest-locator.ts` exports `servedGuestLocator` but has no `servedInvitationLocator`.
  - `src/web/guest-web-socket-service.ts` has `inviteRemote`, but no `servedInvitation` call and no `not dialable` answer.
- **Related merges don't displace it:**
  - #233 adds MCP invite and cancel tools, and #234 adds a local invitation round-trip probe. Neither adds hints for remote invitations.
  - A title and body search of the repo's PRs found no competing open or merged PR.
- **Need is still relevant:** `DEPLOYMENT.md` says **Connect CLI** mints a remote invitation through the guest API, so that path depends on this behaviour.
- **Companion Endo work is still pending:**
  - `llm`'s `packages/daemon/src/networks/ocapn.js` has `ocapn-listen-addr` but no `ocapn-advertise-addr`.
  - endo-but-for-bots#1647 adds it and is an open draft, updated 2026-11-03, with a panel job on the board.
  - Garden commit `23de5f385e9` (`context/operations/minion-town-mcp.md`) names #1647 and #236 as the current fix.
- **No objections on the PR:** there are no comments or reviews, and my inbox was empty.

**Things the later stages should know (none block viability):**
- **Live effect is still blocked:** the PR changes nothing in production until #1647 and the hard blocker #1335 land. #1335 is still a draft and was last updated 2026-09-23. After that come the pin bump and federation `enable`. With federation off, this PR changes nothing, so it can merge safely first.
- **Open questions:** the PR body has 3 for the maintainer: a 503 when federation is off, which advertised host to use, and whether #1333 is a prerequisite for hints.
- **Unproven behaviour:** the PR says cross-daemon `endo accept` was not demonstrated because workers were torn down mid-dial.
- **CI not checked:** this host's PAT can't read `statusCheckRollup`, so I left it out. It doesn't affect this decision, but later stages should poll the Actions runs API.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (287797 cached reads)
- Output: 5534 tokens
- Cost: $0.6001434
- Wall-clock: 139s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
