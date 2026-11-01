---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage, endojs/endo-but-for-bots PR #1617: CI is red because of a known breakage on the base branch

The clean stage failed: CI on PR #1617 is red. The two failures come from known breakage on the base branch, not from this PR's changes, and I pushed nothing.

**PR:** draft, open, head `ironhorse-test262-ratchet-strict-store-wrappers-20261101` @ `80d33e0e3`, base `llm-9a14ddf`.

**Coverage pass:** I reviewed the changes in the four `ironhorse-vm` source files against the PR's new test file, `ironhorse-262/tests/strict_store_and_wrapper_integrity.rs`. The tests reach every new branch:
- a rejected strict computed-key store throws, for symbol and string keys, on frozen, sealed and non-extensible objects, an inherited getter, and the global `undefined`; in sloppy mode it stays silent
- `delete` of a String wrapper's `length` and of a string primitive's `length` refuses, in both sloppy and strict mode
- `new String(symbol)` throws
- the generator, async generator and async function prototypes get the spec's `constructor`/`prototype` attributes

The PR left no dead code: the old `let _ = ordinary_set(..)` lines now use the result. I made no edits, so there was nothing to push.

**CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1617 --no-merge` returned rc=3 (RED). 2 of 38 checks failed:
- `test-ironhorse-oracle`: `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage`
- `ironhorse-oracle-sanitizers`: the same test, plus `generated_multi_crank::converted_corpus_runs_as_crank_sequences`

Both failures are only in `test/ironhorse/built-ins/stage3-math/054.js` (`Math.asinh(1.7)`) and `055.js` (`Math.acosh(2.3)`), reported as "over-acceptance". Ironhorse and the XS oracle disagree on the last digit of the result (1.300820426840647 vs 1.3008204268406467), which comes from the ubuntu-26.04 runner's libm. Every `ironhorse-test262-ratchet-*-20261101` PR fails this way on the base, and this PR does not touch Math.

**Follow-ups:** these fixes are still open, all against base `llm-9a14ddf`:
- #1585 accepts both roundings for 054/055
- #1613 runs the XS oracle lanes on ubuntu-24.04
- #1591 is the bwrap process-group sweep, for a related sandbox failure

Once #1585 or #1613 merges, #1617 needs a weave (move it onto the new base) and the gauntlet needs to resume from the clean stage. I added this attempt's outcome to the host memory note `ebfb-ci-ubuntu-2604-sandbox-ulimit`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1617-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 90 tokens (2775208 cached reads)
- Output: 14267 tokens
- Cost: $2.2388056
- Wall-clock: 4100s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
