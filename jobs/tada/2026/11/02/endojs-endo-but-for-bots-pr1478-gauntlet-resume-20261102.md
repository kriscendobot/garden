---
orchestration-failed: true
---
I did not resume the gauntlet on #1478, because CI on its head is red and the job says to stop in that case. The PR itself is still open, draft and `MERGEABLE`, at head `583a7793a8`.

**Failing check**
- **`ironhorse-oracle-sanitizers`:** [run 41385445751](https://github.com/endojs/endo-but-for-bots/actions/runs/41385445751/job/125093565888) failed on attempt 2, and attempt 1 also concluded as failure. Two `ironhorse-262` test targets fail:
  - `generated_multi_crank` (`converted_corpus_runs_as_crank_sequences`): results differ in the last digit for `stage3-math/054` and `055`. For example, `Math.asinh(1.7)` gives `1.300820426840647` on the oracle and `1.3008204268406467` on IronHorse.
  - `corpus_conversion_equivalence` (`generated_cases_reproduce_corpus_coverage`): I saw the panic at line 119 but did not read its message.

**Other red entries in `gh pr checks`**
- `test`, `cover` and `viable-release` show as `fail` with 0 duration, but they are cancelled jobs from the superseded run 41385445621.
- CI run 41385445799 on the same head passed those jobs in full, including the bwrap sandbox tests that caused the original halt.

**Likely cause: not this PR**
- #1478 only touches `packages/ocapn-noise` and a changeset.
- The last-digit differences fit the known ubuntu-26.04 glibc problem, which the weave report also blames. I did not reproduce that on 24.04.
- [#1613](https://github.com/endojs/endo-but-for-bots/pull/1613), "run the XS oracle lanes on Ubuntu 24.04", should clear it. It is still open and unmerged, with green checks and no review decision.
- **Unexplained:** on this same head, the sanitizer workflow's `ci-changes.py` selected every job, while the CI run's selected `oracle-sanitizers: false`. #1476 skipped the sanitizer entirely. I did not find out why, so #1478 may be hitting this failure only because of that selection.

**State left behind**
- **Gauntlet record:** I did not run `gauntlet.sh --resume-from-stage`. `jobs/gauntlet/endojs-endo-but-for-bots-pr1478-gauntlet-20261101-750929d3.md` does not exist on `origin/journal2`, and the record stays halted in `jobs/tada/2026/11/01/`, so there is no panel-2 stage.
- **Other changes:** I made no commits or pushes and left no PR comments.
- **Prior attempt:** it left no gauntlet record either.

**Follow-ups for the maintainer**
1. Land #1613, then weave #1476 and #1478 onto the fixed base so the sanitizer goes green.
2. Rerun this resume with `panel --iteration 2`. The fix stage treats any red CI as a failure, so resuming before that would probably halt again.
3. Decide whether to look into the `ci-changes.py` selection mismatch.
4. #1481–#1483 still need their own weave, as noted in the earlier weave report.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-resume-20261102.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (451754 cached reads)
- Output: 7892 tokens
- Cost: $0.7706628
- Wall-clock: 147s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
