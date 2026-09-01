Corroborated current PR head `c32e6b97664d69c1eca1da8a23240b17226c5605`:

- Promise capability graph validation, guard coherence, VM rechecks, fuzz generation, and regression locks landed.
- Exact `remaining == pending` was correctly declined: the design records an honest post-GC counterexample where a swept element removes its reaction while `remaining` persists.
- Canonical atom ordering and unknown-tag rejection landed with regression locks.
- Present-but-empty `ESTK` rejection landed with a regression lock.
- No additional push was needed. PR comments `5486439971` and `5486465531` record the disposition and corroboration.
- Verification: `cargo test --manifest-path rust/engine/Cargo.toml -p ironhorse-snapshot --test crafted_row_refusals` passed all 16 tests on `c32e6b9766`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1059-fd3c3617.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1262s

<!-- garden-usage-end -->
