---
orchestration-failed: true
---
orchestration-failed: true

**Clean stage for endojs/endo-but-for-bots#1603 (head `33f6efe2`): CI is RED, so this stage fails.** `ci-wait-merge.sh --no-merge` returned rc=3 with 2 of 38 checks failing. I pushed nothing.

**Coverage and dead-code pass: no changes needed.**
- The change to `promise.rs` removes the old custom-`then` bridge path in `await_finally_result`. That leaves nothing unused: `await_reaction`, `new_promise_capability` and `register_native_reaction` are all still called elsewhere.
- The new `combinator_aggregate_error` replaces code that used to be inline, so there is no duplicate left behind.
- The new `tests/promise_finally_any.rs` and the updated `promise_combinators.rs` exercise every new branch: subclass `finally` (fulfilled and rejected), a replaced `then` receiving the value thunk, subclass adoption through species `then`, and `any` reporting rejections that happen during iteration.
- `lint`, `test-ironhorse`, all `test` and `cover` legs, and fuzz and cross-target all passed.

**The failing checks:**
- `test-ironhorse-oracle`: `corpus_conversion_equivalence`, test `generated_cases_reproduce_corpus_coverage`.
- `ironhorse-oracle-sanitizers`: the same test, plus `generated_multi_crank` (`converted_corpus_runs_as_crank_sequences`).

Every failure is in `built-ins/stage3-math/054.js` or `055.js`. Ironhorse and the XS oracle disagree on the last printed digit of `Math.asinh(1.7)` (ironhorse `1.3008204268406467`, oracle `1.300820426840647`) and `Math.acosh(2.3)` (`1.4750447812414251` vs `1.475044781241425`).

**This red is not caused by #1603.**
- The PR touches only Promise code and Promise expectation files.
- The "IronHorse oracle sanitizers" workflow has failed on every recent `ironhorse-test262-ratchet-*-20261101` PR: iterator-tags, resource-disposal, with-binding-deleted, typedarray-change-by-copy and async-from-sync.
- On the frozen base `llm-9a14ddf`, CI skipped `test-ironhorse-oracle`, so the base never showed this red.
- This matches the earlier note that the stage3-math 054/055 red already existed before these PRs.

**Follow-up:** someone needs to fix the stage3-math 054/055 asinh/acosh mismatch on `llm`, in the math code or with a documented exception for that divergence. Once that lands, re-weave #1603 and the sibling ratchet PRs and rerun this stage. Until then, every ironhorse ratchet gauntlet will stop at the clean stage.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1603-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1004106 cached reads)
- Output: 5138 tokens
- Cost: $0.8638212000000002
- Wall-clock: 94s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
