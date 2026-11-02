#1476 is woven onto `llm-4ae452c` and CI is green. **The new head SHA is `e530cc47c626971c6b0383d779d402d7d57990b4`.** The PR is still a draft, and I didn't touch the dependent PRs.

**What changed**
- **Frozen base:** I pushed `llm-4ae452c` at the `llm` tip (4ae452c59c, 2026-11-01), which contains the sandbox fix 27705a4cdf.
- **Rebase:** all 12 commits went from `llm-61cd656` onto the new base with no conflicts. `git range-diff` shows every commit unchanged, the diffstat matches the old one, and the delta is only the PR's 10 ocapn and ocapn-noise files.
- **Base field:** the PAT on this host gets a 403 on `updatePullRequest`, so I posted `weave-endojs-endo-but-for-bots-pr1476-llm-20261102-retarget-base`, pinned to endolin. It finished, and the PR's base now reads `llm-4ae452c`.

**Head was pushed twice**
- **First push:** `0f2961224d` went up before the base field moved, so its CI used the old base and selected the whole 203-commit `llm` delta.
- **What that caused:** `test-ironhorse-oracle` and the IronHorse sanitizers ran and failed in `corpus_conversion_equivalence`, on the known stage3-math last-digit rounding signature from Ubuntu 26.04 (`generated_multi_crank` also failed in the sanitizers job). The PR touches no Rust. That rounding fix (#1585) is still open.
- **Second push:** a rerun would reuse the same old-base payload, so I re-committed the tip with the same tree and a new committer date, giving `e530cc47c6`. Nothing was waived: with the correct delta, those oracle jobs are skipped.

**CI on `e530cc47c6`**
- **`ci-wait-merge.sh`:** `--no-merge` reports `total=36 failed=0 → CI GREEN`.
- **CI workflow:** 15 jobs succeeded and 13 were skipped by the path filter. The jobs that were red before all passed: `sandbox-drivers`, `cover` (22.x, 24.x), and `test` (22.x, 24.x on ubuntu and macOS).
- **Other workflows:** the IronHorse sanitizers, OCapN Guile interop, Floot Android, the security audit and the dependency-version check are all green.

**Local tests**
- **`ocapn-noise`:** 97 of 97 passed in all three configs.
- **`ocapn`:** two configs passed 574 tests. The third passed 571, then `test/syrup/encode.test.js` died on an ENOENT for ava's `import-from-project.mjs` cache file. That looks like a race between ses-ava's configs on this host rather than a test failure, though I didn't confirm the cause; CI passed on the same tree.
- **Install:** `yarn install` was needed first, because the warm-cache `node_modules` predated the new `@endo/cbor-frame` workspace.

**Follow-ups**
- **Weave ordering on oros:** the base edit can't be done from this host, so a head pushed before the base moves gets CI against the old base. Expect the same false oracle reds when #1478 and later are woven from here. Either run the weave on endolin or re-push once the base has moved.
- **`llm` CI is red at the tip:** `test (22.x, ubuntu-latest)` failed on `bwrap timeout and repeated cancellation reap process groups`, the failure #1591 targets (still open). It didn't fail on #1476, but it can recur on other PRs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1476-llm-20261102.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 6 tokens (308626 cached reads)
- Output: 2442 tokens
- Cost: $2.2514356000000006 (1 engagement(s) unpriced)
- Wall-clock: 7353s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
