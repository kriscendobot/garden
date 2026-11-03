I built the MCP `invite` and `cancelInvite` tools, so the root user can now extend minion.town invitations from its MCP guest. They are in draft PR https://github.com/kriscendobot/minion.town/pull/233. All CI checks pass, including the real-daemon acceptance test for this change. It needed no Endo change.

**What I built**
- **`invite(petName)`**: the caller's MCP guest mints a local invitation with its own daemon `invite` capability. The tool returns the link a new person opens in a browser, and they accept through the existing web accept route.
- **`cancelInvite(petName)`**: voids the caller's invitation under that name while nobody has accepted it, which also frees the name.
- **One shared store for pending invitations**: I moved the in-memory map out of the browser router into `src/web/local-invitations.ts`. The browser invite route and the MCP tools both mint into it, so one accept route redeems both kinds of link.
- **`acceptLocal`**: the browser guest backend can now redeem an invitation that a non-browser guest minted. It runs the same deletion checks as the existing browser-to-browser path.
- **Denial stays absence**: the guest reports an `invite` capability only when its daemon guest has one. The tools mount only when guests live on the daemon, and a guest without `invite` gets a clean error.
- **Names**: `invite` and `cancelInvite` are now registered rather than reserved. The design's provisional `guest_invite(guestName)` becomes `invite(petName)`, recorded in a new § 14 of `designs/invitation-only-guest-onboarding.md`. The remote variant will extend these same tools.

**Tests**
- New `test/endo-invite-tools.test.ts` covers:
  - the tool list;
  - mint, then accept, then a second person refused and the acceptor's retry idempotent;
  - cancel;
  - refusing a name the guest already holds;
  - failing closed without `invite`.
- I updated the tool-name snapshots and coherence checks in `endo-mcp-tool-names`, `endo-clip-tools`, `auth` and `endo-guest-http`.
- **Acceptance run**, in `test/web/guest-web-daemon.test.ts` against a real daemon, passed in CI (run 41610213119):
  - the MCP guest's `invite` tool mints a link;
  - a fresh browser guest accepts it through the web route;
  - each side shows the other as a contact;
  - mail from the MCP guest reaches the newcomer;
  - a second person gets 404 on the spent link;
  - `cancelInvite` voids a second invitation.
- This suite skips on this host because there is no local Endo checkout, so CI was its only run.
- Locally, typecheck and build are clean. One test fails in the full suite: `git-remote/capability.test.ts`, which this change doesn't touch.

**Not done**
- **Production check**: the acceptance ran only in CI. Nobody has invited from the live MCP guest on production yet; that needs a deploy first.
- **Coupons**: the PR states that the tool must carry a coupon before a coupon-gated newcomer can use the link. That argument belongs to `build-minion-town-guest-coupons-phase1-rest` once #199 merges, and the tool's arguments are left open for it.
- **Restarts**: pending invitations from either surface still live only in process memory, so a deploy voids every link nobody has accepted yet.
- Remote invitations (draft #102) and the `legacy-root` migration were out of scope.

No invitation link or guest formula identifier was logged, printed or committed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-mcp-guest-invite.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (5901252 cached reads)
- Output: 37587 tokens
- Cost: $2.999350400000001
- Wall-clock: 882s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
