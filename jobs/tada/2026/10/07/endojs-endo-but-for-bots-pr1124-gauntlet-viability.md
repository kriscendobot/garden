**Viability gate for endojs/endo-but-for-bots PR #1124: proceed.** The PR is open, not merged and not superseded, and the need it was built for still holds.

**PR facts:** The PR is "feat(daemon,ocapn): OCapN formula nonce locator mechanism". It is OPEN and still a draft. Base is `llm-f1e3065` (`f1e30658`), head is `kriscendobot:build/ocapn-nonce-locator-mechanism` @ `2c9c40bb9`. GitHub reports it MERGEABLE, with merge state UNSTABLE.

**Deciding question:** Does current `llm` still lack a way to redeem a canonical formula identifier presented through OCapN `bootstrap.fetch` (a formula nonce locator plus the per-session `makeLocatorForSession` hook), while the design still calls for it and no other PR provides it?

**Evidence:**
- **Base is current.** The base snapshot `llm-f1e3065` is identical to the `llm` tip (`f1e30658`, 2026-10-06, ahead 0 / behind 0). The 2026-09-30 gauntlet halted because the PR targeted a floating base. That cause is gone now that the base is pinned.
- **Not on `llm`.**
  - `packages/daemon/src/networks/formula-nonce-locator.js` does not exist on `llm` (404).
  - `packages/ocapn/src/client/index.js` on `llm` takes only the shared `locator` option. It has no `makeLocatorForSession`.
  - `packages/daemon/src/networks/ocapn.js` on `llm` still answers only the fixed well-known `endo-peer-entry` swissnum. This is the behavior the PR replaces.
- **Design still asks for it.** `designs/daemon-ocapn-external-connectivity.md` on `llm` still says Status: In Progress. Its §2 ("The Daemon's `locator` Replaces `EndoGateway.provide`") still specifies the decode / check-local / `provide(id)` locator that #1124 implements.
- **No competing PR.** Searching for "nonce locator" and `makeLocatorForSession` finds only #1124 and #1333. #1333 depends on #1124: its body says incoming formula redemption goes "through #1124's bounded session locator", and it extends #1124's `makeFormulaNonceLocator`. So downstream work is waiting on this PR.
- **Reviews and discussion.** All reviews and comments are from the bot: five panel rounds (each must-fix, the last at round 5, 2026-09-05), the fix commits responding to them, and automatic blocked-job promotion comments. The plan `endo-minion-town-federation-release-gate` is waiting on this PR. No maintainer comment rejects or supersedes it.

Nothing changed: no clean, panel, fix or CI budget was spent, and no commits or pushes were made. The job inbox was drained and was empty. No follow-ups beyond letting the gauntlet go ahead.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (535598 cached reads)
- Output: 3797 tokens
- Cost: $0.6076196
- Wall-clock: 95s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
