---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet CLEAN stage: endojs/endo-but-for-bots#1609 failed (CI RED)

The clean stage failed because CI is red. The coverage pass is clean and I pushed nothing.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1609, "fix(ironhorse-vm): the global object inherits from %Object.prototype%". It is a draft, head `9ab51376c4` on `ironhorse-test262-ratchet-global-object-proto-20261101`, based on `llm-9a14ddf`.

## Coverage pass
- **What changed:**
  - In `ironhorse-vm`, `boot.rs` now links the global object to `%Object.prototype%`.
  - `realm.rs` gives compartment globals that same prototype.
  - A new helper, `environment.rs::global_inherits`, makes bare-name reads and strict-store checks walk the global object's actual prototype instead of the fixed `%Object.prototype%`.
- **Coverage:** the new `ironhorse-262/tests/global_object_prototype.rs` covers every new branch:
  - the default global's prototype
  - a compartment global's prototype
  - an inherited bare name after the prototype is replaced
  - a null prototype making the name unresolvable
  - a strict store to an inherited name (allowed) versus an unresolvable one (ReferenceError)
- **Dead code:** the change orphaned none; `object_proto` is still used.

## CI
`ci-wait-merge.sh` returned **rc 3 (RED)**, with 2 of 38 checks failing:
- `test-ironhorse-oracle`: FAILURE
- `ironhorse-oracle-sanitizers`: FAILURE

Both fail only on `built-ins/stage3-math/054.js` and `055.js`. `Math.asinh(1.7)` and `Math.acosh(2.3)` differ from the XS oracle in the last digit:
- 054: `1.3008204268406467` vs `1.300820426840647`
- 055: `1.4750447812414251` vs `1.475044781241425`

They show up in two tests: `corpus_conversion_equivalence` and `generated_multi_crank`.

**This is very likely not caused by #1609.** The diff touches nothing in Math. My notes already record the stage3-math 054/055 CI failure as pre-existing. Every other recent ironhorse-test262-ratchet branch on 2026-11-01 also has a red CI run, including object-builtins, iterator-tags, regexp-accessors, promise-finally-any and resource-disposal.

The fix belongs in the shared Math (libm) code or in the oracle pin, not on this PR. Until that lands, every ratchet gauntlet will stop at this stage.

## Follow-ups
- A single fix for stage3-math 054/055 on `llm` would unblock all the ratchet gauntlets.
- After that, run #1609's clean stage again; the PR itself needs no changes.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1609-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1112778 cached reads)
- Output: 5478 tokens
- Cost: $0.8701635999999999
- Wall-clock: 3205s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
