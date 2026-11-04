## Completion report: minion.town arc supervision, tick 2026-11-04T00:25Z

No checklist box changed. The merge delegation is `active`, and I didn't merge anything by hand.

**Issue 58**
- **Checklist:** I refreshed the evidence and added the #234 merge, the deploy and the new probe coverage. The architecture text is unchanged.
- **Comment:** posted because the state changed: https://github.com/kriscendobot/garden/issues/58#issuecomment-6619059836

**State found**
- **#234 (prod-probe invitation round trip):** merged at 22:17Z as `9196892` and deployed green. `local-invitation-roundtrip` passes in production (runs 41730426047 and 41738765838).
- **`main` test run on `9196892`:** failed on the known "reincarnates a guest-pinned Claude inbox responder" race. It wasn't a #234 regression: I reran the failed job and it passed, so `main` is green.
- **#235 (MCP guide and primer):** in gauntlet panel round 4, so I left it alone.
- **#229 (API-key provider UI):** passed its panel and stays draft by design until `claude-api-build-20261027-resume` finishes the remaining phases.
- **#199 (guest coupons):** still waiting on the maintainer's decision, which was already requested, and it isn't an item on issue 58's checklist.

**Actions**
1. **Gauntlet for #236 (remote invitation hints):** recorded `kriscendobot-minion.town-pr236-gauntlet`, because its build only staged a gauntlet for the Endo PR, #1647.
2. **Flake fix:** posted `build-minion-town-responder-test-mailbox-poll`, a test-only change that polls the mailbox assertion. The race has now hit both #234 and `main`, and a failure also skips the later guest-web daemon step.
3. **Closed #102:** superseded by #233, which took the `invite` and `cancelInvite` MCP tool names with local behavior, and #236, which carries the remote-invitation work. #102's MCP route for remote invitations didn't land, so that would need new work if wanted.

**Not verified**
- The scripts logged both posts as successful, but neither job appeared in the root journal's `todo/` or `doin/` when I checked straight afterward. That checkout may just have been behind, or the gauntlet driver may not have posted its first stage yet.
- My issue comment says the probe doesn't cover the MCP `invite` tool or remote invitations. I inferred that from the check's description and #234's scope, not from reading the probe code.

**Follow-ups for later ticks**
- **Validation gap:** no probe is confirmed to cover the MCP `invite` tool that #233 landed. I posted no job because that objective is still unchecked and the job limit per tick was reached, so the next tick should decide; the draft root canary PRs #186 and #191 may matter here.
- **Closing #147:** close it once #235 merges, since #235 carries its design over. Also check #78 and #95, which may be superseded by it too.
- **Maintainer review:** point the maintainer at endojs/endo-but-for-bots#1647 once it leaves draft. I sent no question this tick because no decision is blocking yet. The three open questions in #236 only matter at federation enablement, including whether locators embed `minion.town` or `ocapn.minion.town`, which is permanent.

The arc isn't finished: the publish charge, distributed persistence, Endor, ERTP and the issue 89 items are all still open.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-arc-press-20261104-000530.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1514811 cached reads)
- Output: 18308 tokens
- Cost: $1.4593782
- Wall-clock: 996s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
