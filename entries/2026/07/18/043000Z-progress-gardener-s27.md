---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-18T04:30:00Z
---
# xs2rust-endor s27: whole-stage-8 review — findings round; acceptance deferred; F1 fixer dispatched; s28 parked

- Stage8d orchestration completed green (both children). The gate-remeasure-r2 child's
  fresh-checkout measurement at tip `43b6128e18` is the measurement of record: boot gate
  14/14 with **4 skip→green conversions**, curated compile-diff 1730/1730 + SYMB, full
  121-run enumeration exactly at the anchor (20603/16981/0/3622/0/0), spot checks 0 failed,
  `forbid(unsafe_code)` intact — and it RESOLVED the s26 contradiction:
  `module_corpora_byte_identity_no_divergence` REALLY FAILS (workspace honestly 527/1).
  Endor emits 1 byte more than the oracle on both top-level-await module programs (first
  diff at offset 1, endor 0x07 vs oracle 0x57); pre-existing, stage-orthogonal; the earlier
  EXIT=0 runs were stale-seeded-`target/` false-passes — the program's THIRD
  environment-artifact class, now binding on acceptance-grade workspace runs
  (`cargo clean -p endor-compile -p endor-vm` first).
- s27 diff review of the whole stage-8 range (`a9c8a7ea21..43b6128e18`, 43 files): CLEAN.
  No committed bundles, no c/moddable; daemon changes confined to packages/daemon +
  rust/endo README; class-construction chain adds only scalar flags; the `home` slot is
  ledgered in sidetable.rs with correct Pending classification; `lockdown_roots()`
  untouched; partial-descriptor coverage is new-key-only with spec-default completion
  (redefines self-name); no metering back-fit.
- This host's serial C-XS `test:rust` baseline COMPLETED: **804 passed / 26 failed / 65
  skipped** (+110 pending only from the endo.test.js sandbox timeout). New substantive
  class: content-store-gc 9 (daemon connection ends mid-GC-test; marshalled error fails
  client decode). The 804/26 run is the stage-9 comparison anchor.
- Actions: findings posted as PR #600 issuecomment-5009896419; fixer
  `xs2rust-endor-s27-module-corpora-fix` (opus) posted for F1 (module bytecode — fix endor
  to byte-match the oracle) + F2 (4 cosmetic warnings); supervisor continuation
  `port-xs-to-rust-memory-safe-engine-s28` parked blocked on the fixer, carrying the full
  spec (verify → STAGE-8 ACCEPTANCE → dispatch stage 9: Debugger row + endor-vm spawn
  wiring vs the 804/26 baseline + residual skips).
- Kill criteria assessed NOT tripped: one pre-existing two-case bytecode divergence with a
  dispatched fix; all other bars green; diff review clean.
