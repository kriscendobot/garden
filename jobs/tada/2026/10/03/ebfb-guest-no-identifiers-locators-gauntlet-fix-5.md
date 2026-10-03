I applied the last open must-fix from panel round 5 and pushed it to PR #1404. CI was still pending when the one-hour wait ran out: `ci-wait-merge` returned rc 4.

**Starting state:** The previous attempt at this stage had already pushed fixes for most of the round-5 must-fix items (head `c6857a2b52`). It then reported failure because CI was red, which halted the gauntlet. A later rerun of `test (22.x, macos-15)` turned that head green. But it had deferred the saboteur must-fix (fae subagent delegation could be spoofed by rebinding `subagent.<name>`), so I fixed it this round instead of leaving it for panel 6 to flag again.

**The fix** (commit `9e2eb7b327`, `fix(fae): confirm a subagent's pet name by formula identity before asking`):
- **New `verify(name)` on the spawner:** It compares the parent's `subagent.<name>` with the child it spawned, using the host's `identify` (formula identity, not the pet name). Both fae's spawner and floot's session spawner implement it.
- **Check before sending:** `makeSubagentDelegations` takes a new optional `verifyBinding` hook. `ask` calls it before it sends and refuses if the name now points at something else. fae and floot both pass it in when they have a spawner.
- **Why checking before the send is enough:** a reply can only answer a message its sender received, so confirming who receives the ask also covers the reply. Rebinding the name after an ask can at worst get the attacker's own mail discarded.
- **Tests:** I added a refusal test for `ask` and a `verify` test (true after spawn, false after rebind or stop). The test stub spawners and the fake host's `identify` are updated, and one sentence was added to the existing changeset.
- **Local results:**
  - fae: all 160 tests pass.
  - floot: `inbox-delegation` passes (8 tests). That file had the only floot failure in a full run, caused by the stub spawner missing `verify`, which I fixed.
  - eslint: no errors. Prettier was applied, and fae's `tsc` reported nothing in the files I touched.

**Push and PR:** I pushed with `safe-push-pr-head.sh`, which fast-forwarded the head from `c6857a2b52` to `9e2eb7b327`. I also posted a summary comment on the PR (issuecomment-5966161638).

**CI:** 21 checks passed and 8 were skipped. The two macOS test cells waited for a runner for most of the hour. At the deadline `test (22.x, macos-15)` was running and `test (24.x, macos-15)` was still queued. Nothing has failed.

**Follow-ups:**
- The stylist should-fix (jaine `channelId` duplicating `channelName`) is still deferred to `ebfb-guest-designation-consumers`.
- The gauntlet's terminal "halted" comment on the PR refers to the earlier attempt's red CI, so it is now out of date.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-no-identifiers-locators-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 174 tokens (7396414 cached reads)
- Output: 41083 tokens
- Cost: $3.8502788
- Wall-clock: 8294s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
