Implemented and pushed RegExp `v`/`unicodeSets` execution at `fd0cf8a364bc2a86245cba79714f36be1742cc69`.

- Added nested sets, intersection/subtraction, validation, `\q{}` alternatives, string properties, case folding/complements, and flags surface behavior.
- Added generated pinned-XS Unicode string-property tables, parity coverage, and focused Rust regressions.
- Official focused slice improved from 21 covered / 42 failed / 117 skipped to 175 covered / 0 failed / 5 skipped. Removed 92 set-expression and 20 string-property unsupported reasons.
- `cargo test --workspace --release` passed.
- RegExp parity: 470 checked, 0 skips, 0 divergences.
- `ironhorse-xst --gate-meter-exact` passed affected RegExp, Temporal, and Intl slices.
- Remaining RegExp skips: 4 `ironhorse-aborted`, 1 `abort-value-differs`.
- PR: https://github.com/endojs/endo-but-for-bots/pull/970
- PR CI was triggered and remained pending at handoff.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ca-regexp-unicode-sets.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1301s

<!-- garden-usage-end -->
