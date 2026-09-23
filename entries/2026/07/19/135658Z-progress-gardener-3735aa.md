---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-19T13:57:00Z
---
# xs2rust-endor supervisor s41: STAGE-10j ACCEPTED; finding F1(s41); stage-10k dispatched

Job `port-xs-to-rust-memory-safe-engine-s41` (PR endojs/endo-but-for-bots#600, tip `42e4fcdf8e`).

- Stage 10j completed 3/3 (F1/F2(s40) flag fixes; `%TypedArray%.prototype.subarray` closing the
  CBOR deliver-decode; remeasure TSV byte-identical to the s10h baseline — error-trace pin unmoved).
- s41 reproduced all bars green from a fresh checkout at `42e4fcdf8e`: engine 894/0 EXIT=0 (70
  result lines), compile-diff 1909/1909 + SYMB, boot gate 30/0, ROOT lib 111/0 with both markers
  GREEN, forbid 7 + oracle exempt, VARIANT_COUNT 35, 0 non-oracle warnings.
- Independent verification with fresh variants: F1(s40) + F2(s40) VERIFIED CLOSED; F1(s39) re-probes
  9/9; s37 honest skips 4/4. **STAGE-10j ACCEPTANCE posted: issuecomment-5015969926.**
- NEW finding F1(s41) (pre-existing at anchor `afff3aaf64`, probe-verified at anchor AND tip):
  accessor→data METHOD redefine leaves a stale getter on the read path while gopd reports the data
  shape. Advisory ±1 computron family recorded (copy-skip −1, ≥2-method for-in +1, post-redefine
  reflection +1, async-define −1).
- Dispatched serial-halt orchestration `xs2rust-endor-build-stage10k`: (0) F1(s41) fixer,
  (1) `trace` + `dub_at` dispatch-gate child (gated LIVE round trip, HARD STOP), (2) outage-hardened
  remeasure. Parked `port-xs-to-rust-memory-safe-engine-s42` blocked on it.
