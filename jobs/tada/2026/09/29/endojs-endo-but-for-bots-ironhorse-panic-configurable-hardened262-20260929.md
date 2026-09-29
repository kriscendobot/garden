---
handed-off: endojs-endo-but-for-bots-ironhorse-resource-limit-policy-open-pr-20260929
deliverable-complete: false
---
# Completion report: endojs-endo-but-for-bots-ironhorse-panic-configurable-hardened262-20260929

The code, tests and diagnostics are done and pushed, but the draft PR is not open. This host's bot token is refused on PR creation (`GraphQL: Resource not accessible by personal access token (createPullRequest)`), a known limit of `oros-studio-garden-ce242c49`. I handed that one step to a successor job pinned to another host.

## What changed
Branch `feat/ironhorse-resource-limit-policy` (tip `716cbf202`) on endojs/endo-but-for-bots, with a new frozen base `llm-3aa902d` (the current `llm` tip). 4 commits:

- **Engine setting.** `ResourceLimitPolicy::{Panic, Throw}` is a runtime setting on `Interp` (`set_resource_limit_policy`). I chose a runtime setting over a Cargo feature so one binary can run both configurations.
  - **`Panic`** is the default and behaves exactly as before, matching XS, which also aborts uncatchably at its limits.
  - **`Throw`** turns three limit stops into a catchable guest `RangeError`: the re-entry limit, the stack overflow, and heap exhaustion reported by the storage or regex-matcher caps. The conversion happens at one spot in the dispatch loop.
  - **Stays an abort under both:** the meter, the step limit, refusals, internal errors, and memory-arena refusals that unwind mid-operation (the heap is not in a safe state there).
- **Runner flag.** `endot-ih --resource-limits panic|throw`, plus the same flag on `full-run.sh`. The default adds nothing to a sweep's recorded settings, so the ratchet gate's existing baselines stay comparable.
- **hardened262.** This uses the existing agent matrix, not a new harness:
  - A new agent, `ironhorseThrowOnLimit`, and three cases under `test/ironhorse/resource-limits/`.
  - At the ceilings, the `ironhorse` baseline records the over-limit cases as failures and the new agent records them as passes. On the rest of the 123-file corpus the two baselines are identical, so the policy changes nothing below the limits.
  - The Rust-side check (`native_lockdown_corpora`) now re-runs a limit-aborted case under `throw` and checks the result against the new agent's baseline.
- **Tests.** A new `ironhorse-vm/tests/resource_limit_policy.rs` (10 tests) and a unit test in `xst` for how each policy's result is classified. With the conversion switched off, exactly the three throw-policy tests fail.

## Rust gates (Rust 1.88.0)
- `fmt --check` and `clippy --workspace --all-targets -D warnings` are clean.
- `cargo test --release --workspace` gave **3,511 passed, 0 failed, 43 ignored**. This local run had no `TEST262_DIR` or SES bundle, so tests needing those were skipped.
- The garden's pre-push checks pass. One of them also replaced three existing curly-quote/arrow/ellipsis characters in `rust/engine/README.md`, since it checks whole touched files.

## Findings for the parked floor-resolution job
I ran the 443 `ironhorse-aborted-limit` cases from #1359's `historical-losses.json` at the test262 pin. All 443 are RegExp tests (435 are `property-escapes`).

| policy | covered | fail | still aborted |
|---|---|---|---|
| panic (control) | 0 | 0 | 443 |
| throw | 0 | **439** | 4 |

- **439 become classifiable, all as failures, none as passes.** Each is `RangeError: resource limit: heap exhausted` from the matcher or storage caps, including `generated/ASCII.js`. The tests don't catch the error, so getting them to pass needs a matcher that fits these inputs under its caps, not a policy change.
- **4 still abort under `throw`:** `Grapheme_Extend`, `Case_Ignorable`, `General_Category_-_Mark` and `General_Category_-_Nonspacing_Mark`. Each ends in an uncatchable `HeapExhausted`, meaning either an arena refusal or a failed allocation of the `RangeError` itself. I didn't determine which.

I did not touch #1359, any baseline pin, or the parked floor-resolution job. I messaged `activate-ironhorse-ratchet-autopilot-20260929` that this work is on a separate branch and leaves the default behavior and recorded run settings unchanged.

## Handoff
- **Successor:** `endojs-endo-but-for-bots-ironhorse-resource-limit-policy-open-pr-20260929`. It is confirmed on `origin/journal2` `jobs/todo/`, pinned with `requires: host=endolin-garden-ece02cb4`, and carries the full PR body. Its only task is opening the draft PR through `ensure-pr.sh` against `llm-3aa902d`.
- **Memory:** I updated the host note to record that PR creation is also refused here, and the pinned-successor workaround.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-configurable-hardened262-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 292 tokens (24663628 cached reads)
- Output: 81373 tokens
- Cost: $8.5498896
- Wall-clock: 5009s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
