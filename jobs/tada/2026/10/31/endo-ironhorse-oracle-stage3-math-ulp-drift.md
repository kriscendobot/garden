I opened draft PR [endojs/endo-but-for-bots#1585](https://github.com/endojs/endo-but-for-bots/pull/1585) against `llm-9a14ddf` (the current `llm` tip). On ubuntu-26.04, the `test-ironhorse-oracle` job passes and the `IronHorse oracle sanitizers` workflow passes over the whole suite. 22 checks have passed, 8 were still running when I stopped, and none have failed.

**Root cause:** `ubuntu-latest` now gives the ubuntu-26.04 runner image (glibc 2.43); the run logs show `Image: ubuntu-26.04`. That glibc returns correctly rounded `asinh` and `acosh`. The XS oracle uses the host's math library, so it now returns those values. The checked-in pins hold the neighbouring binary64 value, which is what glibc 2.39 and older return. Ironhorse also returns that value, because Rust's standard library computes `asinh`/`acosh` from formulas instead of calling glibc. The intermittent failures on 10-25 fit a gradual rollout of the new image. No PR diff is involved.

| Case | Exact result | Pinned value (old glibc, Rust std) | Correctly rounded (glibc 2.43) |
|---|---|---|---|
| 054 `asinh(1.7)` | 1.30082042684064683… | `3ff4d0291473fd4a` | `3ff4d0291473fd4b` |
| 055 `acosh(2.3)` | 1.47504478124142499… | `3ff799c88e79140d` | `3ff799c88e79140c` |

**The fix:** ECMA-262 lets these functions be approximate, so each case now accepts exactly two values: the two binary64 numbers either side of the exact result, computed with Python Decimal. Any other value still fails. There is no epsilon, no tolerance across all of Math, and no skip. The other 28 Math cases that depend on the math library keep their exact pins. I didn't pin the job to `ubuntu-24.04`, because that only postpones the failure and leaves the gate tied to the runner's glibc.

**What changed in the PR:**
- **`stage3-math/054.js` and `055.js`:** the assertion is now `[a, b].includes(Math.fn(x))`, with the reasoning in the `info:` block. The `Source:` line is the same expression, and the original program is kept as `Original corpus line:`. This second change was needed because CI on 26.04 then failed a second test the same way, `generated_multi_crank.rs`, which runs each case's `Source:` line on both engines and compares raw results.
- **`ironhorse-vm/tests/fixtures/math-corpus-libm.tsv`:** `055.js` changes to `pass`, because the pure-Rust libm returns the correctly rounded `acosh(2.3)`, which is now accepted. `057.js` (`exp(1)`) is the only libm difference still recorded.
- **Docs:** the C7 sections of `rust/engine/DETERMINISM-METERING.md` and `designs/ironhorse-w6-decisions.md` now record both values for each case and why. I also added a one-line note to the header of `math_corpus_profile.rs`.

**Testing locally (glibc 2.39, oracle built from `c/moddable`):**
- The CI step's full command, `cargo test -p ironhorse-compile -p ironhorse-regexp -p ironhorse-262 -p ironhorse-fuzz --features …parity`, passes.
- The corpus equivalence test covers all 1711 cases with 0 failures.
- `math_corpus_profile` passes with both the platform and the `deterministic-math` providers.

**Follow-ups:** the PR is a draft waiting for review and merge. Once it lands, re-run the PR gauntlets that halted on this check, such as #1117's clean stage and #1501.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-ironhorse-oracle-stage3-math-ulp-drift.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 8 tokens (530071 cached reads)
- Output: 1936 tokens
- Cost: $3.0722405999999998 (1 engagement(s) unpriced)
- Wall-clock: 7440s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
