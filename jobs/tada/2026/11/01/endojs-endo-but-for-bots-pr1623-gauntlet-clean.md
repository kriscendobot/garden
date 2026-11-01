---
orchestration-failed: true
---
The clean stage failed: CI on PR #1623 is red. Neither failure is caused by the PR's change.

**Starting state.** At head `98ebf8f88c` the PR was a draft with two red checks (`test-ironhorse-oracle`, `sandbox-drivers`) and the rest still pending. The stage could not be skipped.

**Coverage and dead-code pass** (on `rust/engine/ironhorse-vm` `resource.rs`/`promise.rs`):
- The PR's own tests already covered null, undefined, empty and moved stacks. The untested case was a null record on the same stack as a real disposer that throws.
- I added `null_record_beside_a_throwing_disposer_still_rejects` to `tests/async_disposable_null_resource_await.rs`. It checks that the rejection still reaches `disposeAsync`'s promise, and checks only the value, not the order of async steps. Mixed-stack ordering may still differ from the spec because each disposer's result isn't awaited, a gap that predates this PR. Locally all 6 tests pass and `cargo fmt --check` is clean.
- I pushed it as commit `a42aacdb33` with `safe-push-pr-head.sh` (fast-forward from `98ebf8f88c`).
- No dead code was orphaned. One small cleanup: the `reject` parameter of the new `settle_promise_after_await` can never be `true`. Any rejection requires a real disposer, and a real disposer sets `has_awaited`, which skips that call. Simplifying it is optional, so I left it alone.

**CI at `a42aacdb33`.** The `ci-wait-merge.sh` watch was cut off by the session's 10-minute command limit, so I polled the checks directly. Two checks are red, and the result can no longer turn green (8 checks were still pending when I stopped):
1. **`test-ironhorse-oracle`**: `corpus_conversion_equivalence` fails on `stage3-math/054.js` and `055.js`, with float last-digit differences against the XS oracle. This is the known ubuntu-26.04 glibc drift, and the PR's base `llm-9a14ddf` (= `llm` tip) has the same problem. The fix is endojs/endo-but-for-bots#1613 ("run the XS oracle lanes on Ubuntu 24.04"), which is still open and unmerged.
2. **`cover (24.x, ubuntu-latest)`**: `packages/sandbox` test `bwrap › bwrap timeout and repeated cancellation reap process groups` fails with "process group … survived bounded cleanup". This is the known flaky bwrap test, unrelated to this PR. The same test turned `sandbox-drivers` red on the previous head, and it passed there on this run.

**Follow-ups.** Merging #1613 clears the oracle red. After that, rerun the failed jobs on the bwrap flake and re-post this clean stage.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1623-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1408542 cached reads)
- Output: 8605 tokens
- Cost: $0.9751924
- Wall-clock: 1340s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
