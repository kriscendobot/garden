Work complete. Inbox empty, everything committed, pushed, and the reply posted.

## Completion report

**Job:** Dead-lettered intent for `issue-kriskowal-garden-29` — fold mhofman's new PR review + issue comment on kriskowal/garden#29 into the in-flight ymax-critical-promotion work (`kriscendobot/agoric-sdk#9`) and reply on the issue thread.

**What I did:**

1. **Addressed both inline review points** (review `pullrequestreview-4659486609`), committed as `d4be7bf` and pushed to `kriscendobot/agoric-sdk@garden29-promote-ymax-critical` (PR #9):
   - `packages/SwingSet/src/controller/upgradeSwingset.js` — dropped the Zoe `zcf` contract-name assertion in `applyVatOptionUpdates` ("Dynamic vat should be sufficient"). The live/non-terminated dynamic-vat guard is the meaningful one; the `zcf` check coupled a generic kernel writer to a Zoe convention.
   - `packages/cosmic-swingset/src/launch-chain.js` — made the not-in-bootstrap precondition explicit: `(upgradeDetails && !isBootstrap) || Fail…` before applying updates.
   - `packages/SwingSet/test/upgrade-swingset.test.js` — reworked the removed-guard test into "does not inspect the vat name/label".

2. **Ran the real function against a real mainnet snapshot** (the "test against a mainnet snapshot with the inquisitor tool" ask). Read the real agoric-3 swing-store rows (cached Polkachu snapshot `agoric-26146641`, height 26146641) read-only and drove the actual exported `applyVatOptionUpdates` over them. **All 11 checks passed:** `v288` is the real live ymax1 contract vat (`zcf-b1-61c340-ymax1`, `critical:false`), the flip goes false→true in place with every other option byte-identical, no `version` key written, idempotent, and the agoricdev-25 pin `v320` (absent on agoric-3) is correctly rejected — cross-chain safe. Because this change is a pure kvStore value-flip (no vat execution), this direct exercise is stronger evidence than an xsnap run.

3. **a3p-integration ask** — confirmed the flexible `upgradeInfo` path is wired (`parseUpgradePlanInfo` passes `vatOptionUpdates` straight through), which is the channel an a3p test must use since the synthetic chainID matches neither golang `switch` pin. Explained the design and the one wrinkle (target vatID isn't a chain constant → discover it dynamically), and **offered to land the a3p proposal as a follow-up** pending mhofman's confirmation of shape.

4. **Replied on the issue thread:** https://github.com/kriskowal/garden/issues/29#issuecomment-4928406026 (did not close — the submitter does that).

**Changed:** 3 source files on the PR branch (remote head now `d4be7bf7020ab68b4b94d01bae9681a0c94e8c1c`).

**Follow-ups:** a3p-integration proposal test — offered, not landed (needs a synthetic-chain run this environment can't do, plus maintainer sign-off on the upgradeInfo-driven shape). The reworked ava unit tests are the CI-runnable regression net; fork CI should exercise them (better-sqlite3's native build doesn't complete in this sandbox, so they weren't run locally).
