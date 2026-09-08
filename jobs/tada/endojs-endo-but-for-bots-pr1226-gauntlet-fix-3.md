CI is green (rc 0). The fix is pushed and CI passed.

## Completion report

**Job:** Gauntlet FIX round 3 — endojs/endo-but-for-bots PR #1226 (`designs/endo-guest-stdio-mcp.md`, a design document).

**Panel-3 must-fix items applied** (the two request-changes seats, critic and ergonomist):

1. **critic — per-spawn re-mount mechanic (socket-discovery §).** The doc claimed the broker's UDS lives "inside" one stable per-guest `@endo/claude-sandbox` slice, but that slice is per-spawn (DD6/DD7), while the broker socket is per-guest and outlives every spawn. Rewrote bullet 1 to state the actual mechanic: the broker binds its socket in a stable per-guest directory owned by the harness (disjoint from `whereEndoSock`), and the harness **re-mounts that same directory into each freshly created per-spawn slice** (mirroring DD7's per-spawn credential mount) while excluding sibling guests' directories and the raw daemon socket.

2. **ergonomist #1 — `initialize` label reconciliation.** The "two sibling transports spell the same handshake" claim contradicted `endo-gateway-mcp.md` (`serverInfo.name: "endo-gateway"` vs this doc's `"endo"`). Fixed the transport prose and the Dependencies row to say the transports share the response *shape* and `mcp__<server>__<tool>` *grammar* but each pins its own `serverInfo.name` label by design.

3. **ergonomist #2 — facet-method throw wire shape.** The error taxonomy never specified how an ordinary facet exception (e.g. `readText` on a missing path, which `endo-claude.md` DD8 settles to `{type:'facet-threw',…}`) surfaces. Added an error-table row + prose clarifying it is an MCP `tools/call` result with `isError: true` (a successful JSON-RPC response, **not** a protocol error), plus a matching test-plan acceptance criterion.

**Adjacent should-fixes also corrected** (both cheap, forestall re-flags): the reason-2 catalog-staleness self-contradiction flagged independently by skeptic and decomplector (freshness is a *client* property; staleness is bounded by *broker teardown*, now a firm requirement), and the copyeditor subject-verb fix ("many guests mean").

**Hygiene:** removed the four em-dashes my edits introduced (recast per em-dash-style; the doc was em-dash-free), verified no typist-hostile code points added, and reverted a stray `packages/floot/package.json` unicode-escape normalization made by the install tooling (committed only the design file).

**Push & CI:** committed as a follow-up on the PR head and pushed via `safe-push-pr-head.sh --mode advance` (`ecff9f749 → 1ef191e76`). Bounded CI wait returned **rc 0 — GREEN** (7 checks, 0 failed).

Stopped here per stage instructions (did not re-run the panel; the driver re-posts panel-4).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1226-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2886229 cached reads)
- Output: 21105 tokens
- Cost: $2.9016174999999995
- Wall-clock: 907s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
