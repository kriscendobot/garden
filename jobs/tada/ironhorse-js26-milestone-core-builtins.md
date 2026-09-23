Implemented and pushed bounded Date-family coverage progress.

- Commit/head: `93e08776a887a8c6d97e6bfa767538a345394790`
- Added Date construction, parsing, UTC, now, TimeClip, getters, formatting, `setTime`, and `toJSON`, plus oracle-backed Rust regressions.
- Date test262 slice improved from 0 covered / 586 unsupported / 8 skipped to 263 covered / 325 unsupported / 6 skipped. Both runs had 0 Ironhorse failures and 0 infrastructure results.
- Verified:
  - `cargo test --workspace --release` passed.
  - Exact meter gate passed: 1712/1712.
  - Pinned XS `built-ins/Date` differential slice passed with no regressions.
- Residual: chiefly Date setters, `Symbol.toPrimitive`, generic coercion behavior, and legacy prototype cases. String/Number/Math/BigInt/URI and miscellaneous residue remain for subsequent increments.
- Pushed to `feat/ironhorse-262-language-completion`; remote head matches.
- PR: https://github.com/endojs/endo-but-for-bots/pull/970 — discovered at completion that it had already been merged before this push, so the new commit is on the shared branch but not contained in PR #970. A replacement PR will be needed.
- Summary comment: https://github.com/endojs/endo-but-for-bots/pull/970#issuecomment-5409381937
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js26-milestone-core-builtins.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 865s

<!-- garden-usage-end -->
