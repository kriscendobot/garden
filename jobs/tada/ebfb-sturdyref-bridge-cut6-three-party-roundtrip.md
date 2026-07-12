Inbox empty, working tree clean (all committed). The job is complete.

## Completion report

**Job:** Bridge cut 6 — three-party round-trip integration (A, B, C) for the SturdyRef cross-peer bridge (design #697), on `endojs/endo-but-for-bots`.

**Delivered:** DRAFT PR **#704** (`build/sturdyref-bridge-6-three-party-roundtrip`), base `build/sturdyref-bridge-5-foreign-internalization`, kept draft. Stacks correctly on cut 5.

**What I did**
- Read the design (§ 3 Three-party handoff, § Acceptance criteria) and the `three-party-handoff` concept doc before coding; verified the cut-5 predecessor branch existed on origin before checking it out (isolated project worktree keyed by this job base).
- Stood up the round-trip over **real `tcp-test-only` netlayers**, with a daemon's OCapN identity (`makeOcapnIdentity`) rotating through each handoff role.

**Changes**
- `packages/daemon/src/ocapn.js` (+ `types.d.ts`): daemon-side arming, the cut-4/5 open question deferred to here. When a netlayer is armed, the identity now adopts the netlayer's **dialable** location (real designator + host/port hints) as its self peer-locator, so a minted/URI-exported SturdyRef carries a location a foreign peer can actually dial. Unarmed advertisement (`hints:false`) is unchanged. Added `shutdown()` (an armed identity previously leaked its listening server).
- `packages/daemon/test/three-party-roundtrip.test.js` (new): the required round-trip with the daemon as **B** (sim-A passes a sim-C ref in-band → B dials C), as **C** (daemon-C's minted ref dialed by sim-B), and as **A** (daemon-A re-gifts out-of-band as an `ocapn://` URI); plus a dedup/re-dial check. Every rotation asserts **no A-C traffic at pass time** and a **fresh B-C session at enliven**. Daemon-as-B asserts the **end-to-end confinement surface**: a guest at B would hold a daemon-local presence that reveals neither C's locator nor the swiss-num.
- `packages/ocapn/test/handoff-sturdyref-contrast.test.js` (new): live-handoff contrast — a live-imported reference works and its grant is the sanctioned `handoff -> sturdy-ref` upgrade (never the reverse), driven over a real session.
- `packages/daemon/test/ocapn.test.js`: cut-5's armed test now tears down through the new `shutdown()` (clean process exit).

**Confinement property preserved:** no-location / no-identification / opaque-and-unforgeable, end to end — the OCapN capability and netlayer never cross a facet (proven for the full daemon in cut 5's `endo.test.js`), and a foreign-hosted value reaches a receiver's guest only as a daemon-local presence carrying no locator and no secret.

**Real-execution evidence (headline, all over localhost TCP):**
```
✔ round-trip, daemon as A (Gifter): ... no A-C traffic, a fresh B-C session
✔ round-trip, daemon as B (Receiver): ... no A-C traffic, a fresh B-C session
✔ round-trip, daemon as C (Exporter): ... no A-C traffic, a fresh B-C session
✔ dedup and re-dial: ... converges on one presence-per-value ... re-dials after teardown
✔ a live-imported reference works and its grant upgrades handoff -> sturdy-ref (never the reverse)
```
tsc clean (both `daemon` and `ocapn` packages); eslint adds no errors; no new dependencies (no yarn.lock change).

**Follow-ups:** The full endo-daemon *subprocess* confinement round-trip (an armed guest enliven via `E(host).lookup`) is not exercised here because arming the production daemon's netlayer prejudges the maintainer's open question (which netlayers arm by default). The confinement clause is instead proven at the identity + presence level plus cut 5's guest-cannot-reach-`sturdyRefs` tests. Arming the production daemon netlayer from persisted config remains the tracked open question.
