Fix round 5 for kriscendobot/minion.town PR #160 is pushed and CI is green: all 3 checks passed, `ci-wait-merge` returned rc 0.

**Must-fix applied (assessor):** `closeBroker` removed a guest's broker entry before waiting for a broker start that was still running. A turn that ran `brokerFor(id).transport()` while a `removeChild` was in progress for the same guest could start a second broker, and nothing would ever close it.

- **`src/endo/claude/claude-guest-bridge.ts`:**
  - A `removed` set now records every removed guest's formula ID. `removeChild` adds the ID as soon as the daemon `remove` succeeds, before it calls `closeBroker`. No await separates the two steps, so no turn can slip in between.
  - `upstreamBrokerFor` now refuses a removed guest with "the guest was removed" instead of starting a broker.
  - Formula IDs are never reused, so the set grows by one entry per removal; a comment in the code explains this.
- **`test/claude-guest-bridge-directories.test.ts`:** a new test races a turn against `removeChild`. It holds the first broker start open, removes the child, and runs a turn inside that window. It checks that this turn and any later one are refused, that only one broker ever started, and that the broker was closed. With the fix temporarily reverted, the test fails, so it does catch the race.

**Checks run:** both bridge test files pass (15 tests), `tsc --noEmit` is clean and prettier is applied. eslint printed no lint findings, only a configuration-migration notice, so lint was not effectively checked here; CI's lint passed.

**Pushed:** commit `0e00fb5`, `fix(claude): start no broker for a removed guest`, on top of `ae967c4`, using `safe-push-pr-head.sh` in advance mode.

**Not addressed:** the panel's non-blocking notes were left alone. These include `streamJsonArgv` putting `--verbose` after `-p` if the output-format flag ever appears without it, and the stylist's comments on naming. The driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (787239 cached reads)
- Output: 7850 tokens
- Cost: $0.8214717999999999
- Wall-clock: 608s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
