I applied the panel's round 1 must-fix items to kriscendobot/minion.town PR #160 and pushed them. CI is green at the new head `32f40bd`: `ci-wait-merge` returned rc 0 with 3 of 3 checks passing.

The panel reviewed `9ac858d..dcdaf01`. The head had since moved to `97d01cd`, so I fixed on top of that.

**Must-fix items**
- **curator:** the bridge's narrow `DaemonConnection` interface in `src/endo/claude/claude-guest-bridge.ts` reused the name of the richer interface in `root-host-socket.ts`. Commit `1f3f7db` renames it to `GuestBridgeConnection` and adds a doc comment saying it is a narrowed version of the other one. The typist seat flagged the same issue.
- **pruner:** the comments and docs walked through implementation steps.
  - `1f3f7db` shortens the module header in `claude-guest-bridge.ts`.
  - `32f40bd` cuts the DEPLOYMENT.md § Tools entry and the confinement comment in `cli-provider.ts` down to the boundary itself, with links to #149 and #162.
  - I also trimmed the PR description and kept its `garden-job` marker.
- **scribe:** the earlier push `dcdaf01` had no summary comment. I posted one at https://github.com/kriscendobot/minion.town/pull/160#issuecomment-6000999869. It covers `dcdaf01`, `97d01cd` and this round's two commits.

**Checks:** `tsc --noEmit` passes, and the 21 `test/claude*` test files (266 tests), pin-drift and federation tests all pass. Both commits went up through `safe-push-pr-head.sh`, which advanced the head from `97d01cd` to `32f40bd`.

**Should-fix items not done this round** (the PR comment lists them too):
- **locksmith:** a turn already in flight could start a fresh broker for a child that was just removed. The fix is to mark removed ids as retired and refuse them.
- **engine-realist:** brokers for guests that are not children are only closed when the daemon connection drops, so they build up on a long-lived connection. They need an idle timeout or a size cap.
- **saboteur:**
  - The stale-broker sweep swallows every `readdir` error, not just "missing directory", so a failure there goes unreported.
  - Removing a child can stall behind a broker start that hangs.
  - The splice in `tools/vendor-endo-claude.sh` doesn't check that its markers are in order.
- **packager:** commit `e6d5c4d` bundles four changes under a narrow title and could be split.

I did not re-run the panel; the driver posts panel round 2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr160-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1154101 cached reads)
- Output: 6698 tokens
- Cost: $0.8635162
- Wall-clock: 408s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
