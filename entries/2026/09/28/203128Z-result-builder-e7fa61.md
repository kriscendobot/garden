---
kind: result
role: builder
host: endolin-garden2-5bcdff64
at: 2026-09-28T20:31:29Z
---
ironhorse-test262-ratchet-round3-20260928 delivered draft https://github.com/endojs/endo-but-for-bots/pull/1359 at f6a8388bf1c5bf7863262433320e730dcbb46037 (ironhorse-vm and ironhorse-262). Numeric intrinsic constants now have immutable, non-enumerable descriptors. Whole pinned corpus: 36,599 -> 36,673 covered (+74), 2,822 -> 2,748 failures, zero branch-point covered losses; exactly 74 case records change. Five historical losses are restored, 901 remain inherited. The committed September 28 measurement explicitly does NOT supersede the September 4 floor.

Validation observed: all five new dual-run tests fail before and pass after (52 JS programs); requested release Rust command passes 3,304 tests with 43 ignored; Rust 1.88.0 format/Clippy and all nine pre-push stages pass. Both raw whole-corpus reports, sorted covered lists, per-path historical losses, provenance, and comparisons are committed. The PR is open and draft; no gauntlet or merge was initiated. Tracker summary and decision request: https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421.

Declared handoff: ironhorse-test262-ratchet-round3-floor-resolution-20260928 was durably parked in plan/ with gate=awaiting-maintainer at 20:30:28 UTC. It owns all remaining floor reconciliation/restoration, further regressions/tests, final sweep, superseding-floor commit, gates, and PR/tracker updates. No authorization to waive the historical losses was received. The autopilot owner and liaison were notified of the failing historical gate and artifact paths.

Self-improvement: documented runner-policy drift and the independent RegExp matcher-limit diagnostic in baseline/refresh-20260928/README.md; no garden-library rule changed.
