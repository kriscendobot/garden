# Fix round 2 for endojs/endo-but-for-bots PR #1298: fixes pushed, CI green

I applied the round-2 panel findings to the PR head (`kriscendobot:ironhorse-fuzz-findings`) and pushed them with `safe-push-pr-head.sh --mode advance` (1b2faf3f7 → 30e8df35c). CI finished green: 34 checks, 0 failed, `ci-wait-merge` rc=0.

## Commits pushed
1. **`cd914ae28` refactor: shared ECMA Number digit placement (purist, must-fix).** The ECMA-262 `Number::toString` placement logic had three copies. It now lives once in a new `ironhorse_text::number` module, exposed as `number_to_ecma_string_with(number, shortest_digits_fn)` plus `std_shortest_digits`. `ironhorse-vm`, `ironhorse-compile` and `xs-oracle` all call it. The oracle still gets its digits from its own Ryu source, so a bug in the VM's dtoa (float-to-decimal) still shows up in the differential. `xs-oracle` now depends on `ironhorse-text`, and I regenerated `CRATE-GRAPH.md`.
2. **`a3e1fa629` docs: shorter comments (pruner).** The `results_agree` doc comment is reduced to its contract. The 23 per-finding dtoa test narratives are replaced by one section comment and a one-line doc per test.
3. **`f54f445a8` test: property and boundary tests (fast-checker, corner-prober, breaker).**
   - `proptest` is a new dev-dependency of `xs-oracle` and `ironhorse-fuzz`.
   - Property tests over arbitrary doubles check that the oracle's spelling round-trips and matches the VM's spelling, and that `results_agree` accepts two spellings exactly when their doubles are equal.
   - Direct tests cover the placement corners: `f64::MAX`, `MIN_POSITIVE`, `5e-324`, negative numbers, and multi-digit fixed-notation cases.
   - Non-finite results (`1/0`, `-1/0`, `0/0`) are captured as Numbers.
   - BigInt, string, boolean, `undefined`, `null` and `Object(42)` results are checked not to be captured as Numbers.
4. **`30e8df35c` chore: lockfiles in their own commit (packager).** It updates both `rust/engine/Cargo.lock` and `ironhorse-fuzz/fuzz/Cargo.lock`. The earlier commits in the PR that mixed lockfile changes in were left alone, because fixing them would mean rewriting history.

## Local checks before pushing
- These tests pass: `xs-oracle` (28), `ironhorse-fuzz` (101), `ironhorse-text`, `ironhorse-compile`, and the `ironhorse-vm` number tests.
- The standalone `rustc --test comparison.rs` run passes. `comparison.rs` still has no dependencies.
- `cargo +1.88.0 fmt --check` is clean.
- `clippy --workspace -D warnings` is clean.

## Not done
- **Proptest dependency weight:** `proptest` adds about 160 lines to `Cargo.lock`. I used `default-features = false`, so it only pulls in `std`.
- **Cross-reference comments:** the purist's comment-only suggestion to cross-link the three copies no longer applies, because they now call one shared helper.
- **`debug_assert!` comment:** the breaker's comment-only note about it is also covered: that check is now a real `assert!` with a message, in the shared helper.
- **Inbox:** the inbox drain at the start timed out on the journal clone, so I couldn't read any messages; nothing else depended on it.

I did not re-run the panel; the driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (4058000 cached reads)
- Output: 23928 tokens
- Cost: $2.164576
- Wall-clock: 3295s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
