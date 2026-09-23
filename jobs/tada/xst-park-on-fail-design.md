Inbox empty. Job complete.

## Completion report — xst-park-on-fail-design

**Design doc:** `designs/xst-park-on-fail.md` on the garden's `main2` (commit `3485005d4`) — https://github.com/kriskowal/garden/blob/main2/designs/xst-park-on-fail.md

**Home recommendation:** garden `designs/` now (the designer carve-out for agoric-sdk is output-is-the-file/no-PR, and no mirror branches exist on the fork yet); the build PR carries a distilled `packages/SwingSet/docs/parked-vats.md` derived from it.

**Recommended approach (grounded in the fork's actual code at `kriscendobot/agoric-sdk` master, 37a4fa3196):**
- A new reversible per-vat kernel state **`parked`**, sibling to `vats.terminated` (`vats.parked` + `${vatID}.parked` reason record). Everything is retained (vatstore, c-lists, transcript, snapshot, incarnation); the worker is evicted; deliveries are **deferred into a per-vat park queue** rather than splatted, so a parked vat is caller-observably just a very slow vat — no new error contract.
- **Detection**: (1) `processUpgradeVat`'s `abortUpgrade` branches gain an `onUpgradeFailure: 'rollback' | 'park'` policy (default rollback = today's behavior), with the park recorded post-`abortCrank` the same way `terminate` survives the unwind; (2) the `ensureVatOnline` replay-divergence/re-create **kernel-panic** paths park non-critical vats instead of halting the chain (deterministic, hence consensus-safe); critical vats keep panic in v1.
- **Resume via the admin facet**: relax `assertRunningVat` so the existing `adminNode.upgrade(bundlecap)` works on a parked vat (new incarnation from baggage, no old-engine replay, pre-upgrade BOYD skipped), plus new `restart()` (snapshot+replay resume, re-parks on repeat divergence) and `parkStatus()`. Authority model unchanged — the adminNode holder; static vats route via `controller.upgradeStaticVat` / new `controller.restartVat`; the non-upgradable bootstrap vat degrades to parked-but-alive with `restart()` as its only escape (gap surfaced, owned by upstream Epic #10905).
- **Variant composition (#11031)**: `WorkerOptions.variant` plumbing; rollback stays safe because it resumes on the recorded legacy binary; upgrade may switch `legacy → latest`, and a failed promotion parks that one vat instead of halting the chain — shrinking the XS release-validation gauntlet to per-vat, at-leisure fixes.

**Follow-on build jobs implied** (new PR on `kriscendobot/agoric-sdk`, branch `kriskowal-park-on-upgrade-failure`, base `master`, serial orchestration): 1) `xst-park-on-fail-build-kernel` — park state/queue/hooks/facet/tests/docs, independent of the mirrors; 2) `xst-park-on-fail-build-variant` — after the `xst-mirror-agoric-11031` peer lands its mirror: variant plumbing + divergence-fixture tests. Copy into each follow-on job verbatim:

```
----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-33
issue_url: https://github.com/kriskowal/garden/issues/33#issuecomment-4910381116
submitter: kriskowal
----- END ISSUE NOTE -----
```

**Not verified** (design-only job): no code was built or executed; all code citations were read directly from the fork checkout, and PR #11031's diff was consulted read-only as untrusted data. Open questions for the maintainer are in the doc (default-park for latest-targeting upgrades, critical-vat policy, park-queue growth, park push-notification, naming).
