# Gauntlet fix round 6: endojs/endo-but-for-bots#1298

I fixed all three must-fix items from the round-6 panel and pushed two follow-up commits to `kriscendobot:ironhorse-fuzz-findings` (head is now `68c477f37`). CI is green: all 34 checks passed (`ci-wait-merge` rc 0).

I took the panel's option (b): keep exact equality everywhere and make the VM pick the even digit at a tie.

**Must-fix 1: the differential paths used different policies.** Commit *fix(ironhorse-text): break exact decimal ties to the even digit* changes `std_shortest_digits` in `ironhorse-text/src/number.rs`. When a double sits exactly halfway between two shortest candidates, it now picks the even last digit (spec Note 2), as Ryu and V8 do. Before, Rust's `{:e}` picked the upper digit.
- It works out the double's exact decimal value with integer arithmetic only, and only swaps the digit if the even neighbor still parses back to the same double.
- I checked it against Ryu over about 50M doubles, random ones plus many built to land on ties: 0 mismatches. With the old `{:e}` digits the same check finds about 405k.
- Since both sides now spell every Number the same way, the fuzz comparator, the three test262 dual-run sites and the module runner all use the same exact-equality rule again.

**Must-fix 2: `is_tie_spelling` accepted too much.** Commit *fix(ironhorse-fuzz): compare Number spellings exactly again* deletes `is_tie_spelling` and `significant_digits` from `comparison.rs`, so `results_agree` is plain exact equality again.
- New negative tests cover every case the panel listed: `100`/`1e2`, `1000`/`1e+3`, `1000`/`+1e3`, `1000`/`01e3`, `1e+21`/`10e20`, `1e+21`/`1.e21`, `5e-324`/`4e-324`, `…344`/`…342`, and the odd tie digit `…064.63`.
- The `independent_number_spelling_matches_vm` property test in `xs-oracle` is back to byte equality, and the two tie values are added to its corner-case list.

**Must-fix 3: the docs and PR body overstated the contract.**
- The module doc in `ironhorse-text/src/number.rs` now says what is enforced: the shortest digits, and at an exact decimal tie the even digit.
- The `results_agree` doc now says the spelling is fully determined.
- The doc in `finding_d87697d49a5f8f67_even_tie_dtoa.rs` now makes clear that finding is a binary rounding tie, where only one 16-digit spelling is valid, not a decimal digit tie.
- I rewrote the harness section of the PR body to state this contract. It also takes up the should-fix about short SHAs: PR-local commits are now cited by subject, and only base-side SHAs remain.

**Local checks:**
- `ironhorse-text` unit tests pass (including new tie and exact-decimal tests), and the `comparison.rs` tests pass under bare `rustc --test`.
- `cargo test -p ironhorse-vm` found no failures.
- clippy `-D warnings` is clean on `ironhorse-text` and `ironhorse-vm`, and on `comparison.rs` alone. `cargo fmt --check` is clean.
- I couldn't build `xs-oracle`, `ironhorse-262` or the `ironhorse-fuzz` crate locally because the `c/moddable` submodule is missing here. The green CI run covers those.

I also reverted a stray, uncommitted edit to `packages/floot/package.json` that was sitting in the reused project worktree.

**Not done (should-fix only, left for later rounds):**
- Folding the review-fixup commits into a harness-contract series.
- A shared `number_bits` / `oracle_expected_spelling` helper.
- Making `std_shortest_digits` `pub(crate)`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2768652 cached reads)
- Output: 25295 tokens
- Cost: $1.8356384
- Wall-clock: 3448s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
