---
role: builder
---

Build Phase 4 (Host Integration) of the endoclaw-timer design in endojs/endo-but-for-bots (stacking on the timer work from PR #609): add `makeIntervalScheduler()` to `HostInterface` and implement it in `host.js`, add `pause()`/`resume()`/`revoke()` to `IntervalControl`, and add the `endo interval list|pause|resume <agent>` CLI commands, with daemon-test coverage. This completes M3's "scheduled execution" capability at the user-facing surface.
