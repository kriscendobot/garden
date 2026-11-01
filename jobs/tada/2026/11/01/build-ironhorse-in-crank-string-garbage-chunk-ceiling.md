---
handed-off: build-ironhorse-in-crank-safepoint-collection
deliverable-complete: false
---
I built the RegExp half of the design as draft PR https://github.com/endojs/endo-but-for-bots/pull/1624. The safepoint garbage collection, the part that would fix the ~820 `skip:ironhorse-aborted-limit` rows, is not built. The design waits on the maintainer agreeing to change the quiescent-GC rule, and nobody has answered that on #1622. I parked that work as a successor job.

**What the PR changes** (branch `fix/ironhorse-regexp-catchable-limits`, base `llm-9a14ddf`, which is the same as the current `llm`):
- **Match limit:** a RegExp match that goes past `MAX_MATCH_STATES` / `MAX_MATCH_BYTES` now throws a `RangeError` the guest can catch. Before, it halted the machine with `HeapExhausted`.
- **Compile limit:** `new RegExp(...)` hitting the compiler's storage limit also throws a catchable `RangeError` now. Metering is unchanged in both cases.
- **Quantifier clamp:** bounds above 2^31-1 are clamped, as XS does, instead of halting. The `{m,n}` order check now compares the unclamped digits, so `{4294967296,4294967295}` is a SyntaxError again.
- **Test262 runner:** `ironhorse-262` treats these two fixed `RangeError` messages as the engine's limit (`ironhorse-aborted-limit`). Any other uncaught `RangeError` still counts as a failure.
- **Ratchet:** `built-ins/RegExp/quantifier-integer-limit.js` goes from aborted-limit to pass in sloppy and strict mode, with XS agreeing. That shard's expectations are re-baselined.

**Open question I decided:** the design asks whether rows that now throw this `RangeError` get a new skip class or keep `ironhorse-aborted-limit`. I kept the existing class so no expectation files churn. The PR body says so, and switching later is a one-line change in each of the three places.

**Verification:**
- `cargo test -p ironhorse-regexp -p ironhorse-vm -p ironhorse-262` passes. `cargo fmt --check` and `cargo clippy` on `ironhorse-regexp` are clean.
- Clippy on `ironhorse-vm` fails on an existing lint in `natives/base64.rs`, a file this PR doesn't touch.
- The four new VM tests fail on the base sources.
- A release-build sweep of all 61 RegExp and regexp-literal test262 shards shows only the expected two-row improvement.
- The pre-push gates pass.

**Notes:**
- #1618 (matcher run compression) is still open. This PR doesn't touch the matcher or its shards, so the two can land in either order.
- The PR-body gate couldn't read the design file because it exists only on #1622's branch. I checked that the design's wording wouldn't have triggered that gate anyway, then reworded one "step 3" phrase in the body so it passed.
- **Successor job:** `build-ironhorse-in-crank-safepoint-collection` is parked in plan/ as awaiting-maintainer, pointing at #1622. It covers the full safepoint scope and test plan.
- The design notes ropes (for NVAL-3) would need a separate design, which isn't filed yet.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-in-crank-string-garbage-chunk-ceiling.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 154 tokens (8976949 cached reads)
- Output: 40551 tokens
- Cost: $3.8384498000000002
- Wall-clock: 2293s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
