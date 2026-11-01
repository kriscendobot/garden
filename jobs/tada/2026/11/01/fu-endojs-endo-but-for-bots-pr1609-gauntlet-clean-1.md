## Fix for the stage3-math 054/055 failures: draft PR #1613

The fix is in draft PR https://github.com/endojs/endo-but-for-bots/pull/1613, on branch `fix-ironhorse-oracle-ubuntu-2404` against frozen base `llm-9a14ddf` (the current `llm` tip). Both previously red jobs pass on it: `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`.

**Cause:** nothing in the repo changed; the CI runner image did. `ubuntu-latest` now gives ubuntu-26.04, whose newer system C library rounds `asinh` and `acosh` exactly. The XS oracle uses the host's math library, so it now returns results one ULP off from what 054.js (`asinh(1.7)`) and 055.js (`acosh(2.3)`) expect. Iron Horse still produces the expected values. The test `corpus_conversion_equivalence` therefore reported "over-acceptance" in both oracle jobs on every PR, including #1609 and #1548. A 50-digit reference calculation confirms that 26.04 gives the correctly rounded results and the pinned values are the older glibc 2.39 ones.

**Change:**
- `.github/workflows/ci.yml` (`test-ironhorse-oracle`) and `.github/workflows/ironhorse-sanitizers.yml` now run on `ubuntu-24.04`, each with a two-line comment saying why. `depcheck.yml` and `browser-test.yml` already pin 24.04 for their own 26.04 problems.
- `rust/engine/DETERMINISM-METERING.md` § C7 now records that the oracle's expected values depend on the host's math library.
- No tolerance or skip was added, so that section's "exact values only" rule still holds.

**Checks run locally (glibc 2.39, the same as ubuntu-24.04):**
- `cargo test --locked -p ironhorse-262 --test corpus_conversion_equivalence` passes: all 1711 cases covered, 0 failed, 0 skipped.
- The workflow YAML parses.
- zizmor couldn't check `ironhorse-sanitizers.yml` because it can't parse that file's `uses: $/…` line. The unmodified file fails the same way, so that predates this change.

Midway through, I accidentally discarded my edits with a stray `git checkout`. I re-applied them and checked the diff before committing.

**Follow-ups:**
- PRs stay red on these two jobs until #1613 merges into `llm` and they are woven onto it, #1609 included.
- When GitHub retires ubuntu-24.04, 054/055 will need new expected values, or the oracle will need a fixed math library instead of the host's.
- The "Ironhorse full test262 sweep" on `llm` is failing for an unrelated reason (GC performance baselines over the 1.25× limit), which this PR does not address.
- I updated my memory note on this failure with the cause and PR #1613.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1609-gauntlet-clean-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2682853 cached reads)
- Output: 16734 tokens
- Cost: $1.5717226000000004
- Wall-clock: 2005s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
