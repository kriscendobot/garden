orchestration note: CI is still running, so this stage did not record `clean=done`. Two oracle checks are already red, but the cause is the CI runner image, not this PR.

**Clean stage for endojs/endo-but-for-bots#1617** (draft, head `80d33e0e32`, base `llm-9a14ddf`)

**Coverage pass (no changes):** I read through the four touched source files in `ironhorse-vm` against the new `ironhorse-262/tests/strict_store_and_wrapper_integrity.rs`. The new tests reach every new branch:
- **Strict computed-key stores:** a rejected strict store now throws, in both `ordinary_set` arms of `property.rs`, for string and symbol keys. The tests cover frozen, sealed and non-extensible objects, an inherited getter with no setter, and the global `undefined`.
- **Sloppy stores:** a rejected store still fails silently.
- **Deleting a String's `length`:** `delete` refuses on both a `new String` object and a primitive string, in sloppy and strict mode. Deleting an added property or a missing key still works.
- **`new String(symbol)`:** it now throws, while `String(symbol)` keeps working.
- **Generator, async-generator and async function prototypes:** the `constructor` and `prototype` attribute flags match the spec.

Every case is checked against the XS oracle. The change left no dead code behind, so nothing was pushed.

**CI:** `ci-wait-merge.sh --no-merge` returned **rc 4** after the full 3600s limit, with 1 of 38 checks pending (`test (24.x, macos-15)`). Two checks are already red:
- `ironhorse-oracle-sanitizers`
- `test-ironhorse-oracle`

Both fail only on `stage3-math/054.js` (`Math.asinh(1.7)`) and `055.js` (`Math.acosh(2.3)`). The XS oracle returns `1.300820426840647` and `1.475044781241425`; Ironhorse returns the stored values `1.3008204268406467` and `1.4750447812414251`. The cause is already known: the oracle uses the system math library, and `ubuntu-latest` is now Ubuntu 26.04, whose glibc rounds asinh/acosh differently from the version the expected values were recorded on. This PR doesn't touch Math. All other checks pass.

**Follow-up for the driver/maintainer:** the fix is PR #1613 ("fix(ci): run the XS oracle lanes on Ubuntu 24.04"), which targets the same base `llm-9a14ddf` and is **still OPEN**. Until it merges and #1617 is woven onto a base that includes it, a re-posted clean stage will end RED (rc 3) on these two checks. The quickest path is to merge #1613, then weave #1617 onto the new base, or rerun the failed checks if #1613 lands on `llm-9a14ddf` itself.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1617-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1635759 cached reads)
- Output: 6376 tokens
- Cost: $1.0259438
- Wall-clock: 3696s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
