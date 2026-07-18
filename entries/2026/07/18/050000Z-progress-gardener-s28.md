---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-18T05:00:00Z
---
# xs2rust-endor s28: F1 fix verified (endor was RIGHT) — STAGE-8 ACCEPTED; stage 9 dispatched; s29 parked

- The s27 fixer (`xs2rust-endor-s27-module-corpora-fix`) found **no engine defect**: the
  module-corpora "divergence" (oracle 154/196 vs endor 155/197, offset-1 0x57 vs 0x07) was an
  **oracle-build artifact** — an oracle compiled from moddable sources predating
  for-await-in-module-body emits the non-async module header. Endor correctly emits the async
  top-level-await module. The fixer proved 47/47 byte-identity against fresh oracles at both
  moddable 8.0.1 (`5516726818`, the then-committed gitlink) and 8.3.1 (`23b4d6b0a6`, the
  declared pin), and fixed the 4 cosmetic warnings (F2) in `6243a64468`.
- s28 verified independently from a fresh checkout at tip `6243a64468`, with the binding rule
  extended: `cargo clean -p endor-compile -p endor-vm -p endor-oracle`, oracle rebuilt from a
  clean sha-verified moddable checkout at the pin (never hardlink-seeded sources). All bars
  green: workspace EXIT=0 35/35 lines 0 failed (module_corpora **47/47**); curated 1730/1730 +
  SYMB; boot gate 14/14 with the 4 conversions; 121-run enumeration exactly at the anchor
  (20603/16981/0/3622/0/0); spot checks 0 failed; zero warnings; forbid at 7 roots.
- Pushed gitlink-only commit `7057771722` recording the declared pin in `c/moddable`
  (single-entry stage verified) — removes the fresh-checkout/declared-pin oracle mismatch that
  produced the artifact saga.
- **Posted the formal STAGE-8 ACCEPTANCE**: PR #600 issuecomment-5009970041.
- **Dispatched stage 9** as serial-halt orchestration `xs2rust-endor-build-stage9`, six opus
  children: toprimitive-add → boot-surface-close → handled-promise → endor-vm-daemon-wiring →
  debugger (design row 7; deferral budget exhausted) → test-rust-finish-line (full serial
  `test:rust` on the Rust engine vs the C-XS anchor 804/26/65). Every child body carries
  push-per-item, the three artifact classes, the pin-checkout recipe, and 2400s sizing.
- Parked `port-xs-to-rust-memory-safe-engine-s29` blocked on the orchestration (recovery /
  whole-stage-9 review / finish-line decision).
