## Fix round 2 report: endojs/endo-but-for-bots PR #1476

I applied the round-2 panel's must-fix items and the most important should-fix items, and pushed them. CI is **green**: all 35 checks finished with 0 failures, on head `bf0d59985f`.

**Pushed with `safe-push-pr-head.sh` (`b393a2002b..2e6f2a3db7`)**
- `293af88ccf` fix(ocapn-noise):
  - **Bounded read-ahead (saboteur and breaker, both seats' top item).** With heartbeats on, the session reader used to read ahead into an unbounded queue. It now stops reading after 64 frames the consumer has not taken, and starts again as the consumer reads. While it is stopped, the session-timeout timer is paused too: a full queue shows the peer is alive and the slow side is local.
  - **Forged-acknowledgment guard (saboteur and breaker).** Sent nonces are now counted alongside received ones (`countNonces`). An `op:pong` that acknowledges a nonce this side never used is ignored, so a peer cannot set the recorded value impossibly high.
  - **Stop after close (saboteur).** The background reader no longer changes session state once the session has been closed locally.
  - **Two new tests.** One checks the forged-acknowledgment guard. The other checks backpressure, and I confirmed it fails when the queue limit is disabled.
- `2e6f2a3db7` docs(ocapn-noise):
  - **Published type (surfacer 1).** `MakeOcapnNoiseNetworkOptions` now includes `heartbeat`, plus the two handshake options the code already accepted.
  - **README (surfacer 2).** New "Session heartbeats" section.
  - **Comment trims (pruner 2–9).** Removed comments that repeated nearby ones, and fixed the doc that named a non-existent `HEARTBEAT_INTERVAL` constant. Added breaker's note that the peer's interval must be well under this side's session timeout.

**PR body (pruner 1, coverage-auditor 1)**
- Cut from 941 to 573 words. The marker and the phase/evidence ledger are unchanged.
- Added an explicit explanation of why there is no XS or endor run: both packages already stub `test:xs` on `llm`, and `@endo/ocapn-noise` has no XS harness.
- Noted that the timer-teardown test patches the host timers and only claims coverage on Node (coverage-auditor 2).

**Local checks**
- All 92 `@endo/ocapn-noise` tests pass.
- Package `tsc`, eslint and prettier are clean; eslint reports only warnings that were already there.
- The repo-root `tsc -p tsconfig.json` ran out of memory on this host, so it was not checked locally. CI's lint job passed.

**CI and the peer commit**
- A peer pushed `bf0d59985f` on top of my commits while CI ran. It adds typed heartbeat messages and renames `peerAckedRecvNonce` to `peerLastAckedRecvNonce`.
- My head's run had 0 failures; one check was cancelled when the new push superseded it.
- `ci-wait-merge.sh --no-merge` returned rc 0 (green) on `bf0d59985f`, which includes my fixes.
- The first one-hour background wait was stopped at its time limit; I finished the wait in shorter foreground runs.

**Not done (should-fix or follow-up)**
- I did not narrow the `try` block in `isHeartbeatFrame` (saboteur 4). Its doc now explains that a frame it cannot read is passed up to the session.
- I did not add a real XS test or a c8 coverage run (coverage-auditor 1 and 3). The PR body now says why XS is not run.
- I did not check whether `packages/ocapn/README.md` documents the `./operations` subpath (surfacer 3).
- The panel-3 stage will re-review.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4396372 cached reads)
- Output: 24344 tokens
- Cost: $2.2001384
- Wall-clock: 4746s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
