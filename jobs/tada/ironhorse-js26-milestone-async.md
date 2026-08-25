Implemented and pushed commit `695a627996790d7615723956358f9199028adc14`:

- Added specified async-generator constructor/prototype metadata, method names and arities, and `Symbol.toStringTag`.
- Preserved assignability of each async-generator function’s own `prototype`.
- Added focused oracle-backed Rust regression tests.
- Re-pinned the deterministic snapshot blob/seal for the intentional intrinsic boot-state change.

Coverage at test262 `be13516f` with XS `23b4d6b`:

- `Array.fromAsync`: 79/95 → 79/95; 16 residual: 12 async failures, 3 ToPrimitive gaps, 1 abort.
- `for-await-of`: 1170/1234 → 1170/1234; 64 residual: 29 aborts, 16 Symbol gaps, 8 primitive-box gaps, 6 async failures, 2 unhandled rejections, 2 exotic-copy gaps, 1 parse/decode gap.
- `AsyncGeneratorPrototype`: 28/48 → 38/48; 10 residual: 3 async failures, 6 invalid-receiver gaps, 1 abort.
- Promise and await/AsyncFunction residue remains for later milestone work.

Verification passed:

- Affected `full-run.sh` slices: zero Ironhorse failures or infrastructure results.
- `cargo test --workspace --release`.
- `ironhorse-xst --gate-meter-exact rust/engine/ironhorse-262/cases`: 1712/1712.
- Focused async-generator tests: 8/8.

PR #970 had already merged before this claim, so the required script opened successor draft PR https://github.com/endojs/endo-but-for-bots/pull/1060. CI was running at handoff.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js26-milestone-async.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 994s

<!-- garden-usage-end -->
