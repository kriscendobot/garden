Fix CI on https://github.com/endojs/endo-but-for-bots/pull/825.

Shepherd escalation: `test (22.x, macos-15)` remains red at head 74f71d55bc78d05939825e28ad7c84d16f042231 after a failed-job rerun.

Failure inventory:
- Original job 90183558135: packages/init/test/async_hooks.test.js, `async_hooks Promise patch` timed out.
- Rerun job 90213778460: packages/daemon/test/ws-relay.test.js:361-425 reports an unhandled rejection `Timed out opening relay channel to dead...`; the asserted test passes, but AVA fails @endo/daemon#test. The ws-relay test is identical to parent origin/daemon-store-phase3-weak-ertp-74931b9, while this PR changes daemon collection-store code and tests.

Investigate the macOS/Node 22 daemon-test interaction and apply a real fix. Do not suppress the test or bypass safety checks. CI evidence: https://github.com/endojs/endo-but-for-bots/actions/runs/30330210988/job/90213778460

<!-- garden-reaped: 2 -->

---
claim:
  host: ps23-garden-f65473ae
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-28T21:03:35Z
