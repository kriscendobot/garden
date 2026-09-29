# Gauntlet fix round 5: endojs/endo-but-for-bots PR #1298

CI is green on head `4adb8f633` (34 checks, 0 failed). All three must-fix items from the latest panel verdict (round 4) were already done, but CI on that head was red, so this round fixed the CI failures.

## Panel must-fix items (latest verdict: round 4, on `c9accbf5`)
Fix-4 had already handled all three after the review was posted. I checked each one:
1. **Wrong commits cited in the description:** the description has been rewritten. Every commit it cites from the branch is on the branch. The fix commits it credits to the base (`c8497fd88`, `7fae4aea2`, `8fdef95f3`, `de1698920`, `dbdddec76`) are all ancestors of `387ea66`.
2. **Description didn't match the diff's scope:** it is now a short summary grouped by finding class, and each class names its fix commit.
3. **`ctor` abbreviation:** renamed in `faa086ab8` (`…_regexp_constructor_frame.rs`).

No push was needed for these.

## CI failures on `faa086ab8`
- **`test-ironhorse-oracle`:** a real failure. The `decimal_numbers_agree_exactly_when_their_doubles_are_equal` property test found a false divergence at `-125343939420064.625`. That double sits exactly halfway between two shortest spellings. Ryu (the oracle's digit source) spells it `…062`, and Rust's `{:e}` (IronHorse's source) spells it `…063`. The spec (ECMA-262 `Number::toString`) accepts either: step 5 doesn't pick a unique digit, and Note 2 only recommends the even one.
  - **Fix, `fef22cc4d`** (`fix(ironhorse-fuzz): accept either shortest spelling of an exact tie`): `results_agree` in `comparison.rs` now also accepts a spelling that parses to the same finite double and has the same length and number of significant digits.
  - The digit-count check keeps XS's non-minimal spellings (such as `57632001481506816`) counting as divergences.
  - I added a unit test. All the existing `comparison.rs` tests still pass under a bare `rustc --test`.
- **`ironhorse-oracle-sanitizers`** (failed once `fef22cc4d` was pushed): the same tie problem, at `-614423824407840.25`. It was in the xs-oracle property test `independent_number_spelling_matches_vm`, which required the Ryu and VM spellings to be byte-identical.
  - **Fix, `4adb8f633`** (`test(xs-oracle): …allow either tie digit`): when the two spellings differ, the test now requires the same length and that the VM spelling parses back to the same Number.
- **`test-thixotrope-ironhorse`:** a `yarn install` crash from a timeout during dependency resolution. It's an infrastructure flake and passed on the rerun.
- **`test (24.x, macos-15)`** (on `fef22cc4d`): a timeout in the unrelated `provider-listener-runtime` JS test. It passed on the rerun.

Neither property test could run locally because the XS submodule isn't built here. I checked both fixes in a separate test harness that uses the real `ironhorse-text` speller and Ryu: both properties held over about 9M cases, including 761 genuine tie spellings and both counterexamples from CI.

Both commits were pushed with `safe-push-pr-head.sh`. `ci-wait-merge.sh --no-merge` returned rc 0.

## Follow-up
- The `ironhorse-262` dual-run checks (`lib.rs:598`, `lib.rs:950–962`, `xst.rs:1782`) still require the spelling to match the oracle's exactly. They will report the same false divergence on exact ties. They should use the tie rule too, ideally through one shared helper. I left them alone to keep this round small.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (3782484 cached reads)
- Output: 23129 tokens
- Cost: $1.9375808
- Wall-clock: 4504s

<!-- garden-usage-end -->
