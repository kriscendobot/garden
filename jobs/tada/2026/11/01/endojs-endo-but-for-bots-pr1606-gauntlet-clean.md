---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage, PR #1606: coverage is fine, but CI is red (not caused by this PR)

The coverage pass found nothing to fix. The stage still fails because `ci-wait-merge.sh` returned **rc=3 (RED)** at head `7dca4f180c`, so I did not emit `clean=done`.

**Coverage pass.** I checked the PR in an isolated checkout (`scratch/project-wt-endojs--1687039c2f6d-0009ecda`). Each of the three changes has a test in the new `tests/object_builtin_conformance.rs`, and all three tests passed in CI:
- `hasOwnProperty` now converts its key before checking its receiver.
- `%Object.prototype%` now refuses a new prototype.
- A Proxy completion is no longer mistaken for a null-prototype object that can't be converted to a string.

No dead code was left behind; the key-conversion block was moved, not orphaned. I pushed nothing.

**Failing checks**, 2 of 38. Both fail on the same two test262 files, `built-ins/stage3-math/054.js` (`Math.asinh(1.7)`) and `055.js` (`Math.acosh(2.3)`):
- `test-ironhorse-oracle`: `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage` reports 1709/1711 covered. The two failures are flagged as "over-acceptance": Ironhorse prints the result one digit longer than the XS oracle (`1.3008204268406467` vs `1.300820426840647`, and `1.4750447812414251` vs `1.475044781241425`).
- `ironhorse-oracle-sanitizers`: the same divergence, plus `generated_multi_crank::converted_corpus_runs_as_crank_sequences`, which reports 4 disagreements on those same two files.

**This was already broken.** This PR doesn't touch Math or number formatting. Every recent `ironhorse-test262-ratchet-*-20261101` PR fails the same "IronHorse oracle sanitizers" workflow: async-from-sync, typedarray, with-binding, resource-disposal, promise-finally, iterator-tags, regexp-accessors, proxy-callable, proxy-revocation and global-object-proto. On `llm` / `llm-9a14ddf` these checks are skipped, which is why the base branch doesn't show the red.

**Follow-up:** the stage3-math 054/055 print-length divergence needs its own fix on `llm`, either the formatting itself or the expected results for those two files. Until then, every Ironhorse ratchet gauntlet will stop at this clean stage. I did not change PR #1606 for this, because the failure isn't in its scope.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1606-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (816698 cached reads)
- Output: 4339 tokens
- Cost: $0.7726796000000001
- Wall-clock: 87s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
