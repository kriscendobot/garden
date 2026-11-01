---
handed-off: ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101-open-pr
deliverable-complete: false
---
The fix and the updated ratchet floor are pushed, but the draft PR isn't open yet. This host gets a 403 from GitHub when it tries to create the PR (`createPullRequest`), so I posted a successor job, pinned to an endolin host, whose only task is to open it.

**The slice.** I skipped rows other slices had claimed (PRs #1599–#1605, the eleventh slice's Proxy rows, and the async-generator rows of the fifteenth and seventeenth slices) and told the peers what I took. 15 rows across `built-ins/{Object,String,undefined,GeneratorFunction,AsyncGeneratorFunction}` now pass.

**Engine fixes** (head branch `ironhorse-test262-ratchet-strict-store-wrappers-20261101` at `80d33e0e3`, against the frozen base `llm-9a14ddf`):
- **Strict `o[k] = v`:** a computed-key store that the object rejects was silently ignored in strict code. It now throws a TypeError, the same as `o.k = v` already did. The two sites are in `property_at_set` (`interp/property.rs`).
- **String `length`:** `delete` of a String wrapper's or a string primitive's `length` used to answer `true`. It now answers `false`, and throws in strict code.
- **`new String(symbol)`** now throws a TypeError.
- **Prototype attributes:** `constructor` on the `GeneratorFunction`, `AsyncGeneratorFunction` and `AsyncFunction` prototypes is now non-writable, and the `AsyncGeneratorFunction` prototype's `prototype` is now configurable. This matches the spec and XS.

**Tests and golden files:**
- I added `ironhorse-262/tests/strict_store_and_wrapper_integrity.rs`, which runs each case on both Ironhorse and XS. Four of its five tests fail without the fix; the fifth is a sloppy-mode control that passes either way.
- The attribute change moves the snapshot golden files. I regenerated `state_golden` under both math providers and re-pinned the six metamorphic hashes and both blob arms. The fuzz seed corpus didn't change.

**Ratchet floor.** I re-swept every subtree except Temporal and updated nine whole-tree expectation files. The only changes were the 15 fixes and one unrelated row: `language/module-code/namespace/internals/own-property-keys-sort.js` now skips as `module:compiler-byte-divergence`. That reproduces every time and this branch touches no compiler code, so it is probably already stale on `llm`. I did not confirm that by sweeping the base branch, and the PR body says so. Following the earlier slices, I did not create a `baseline/refresh-*` floor directory; that waits on the open question in kriscendobot/garden#51.

**Local checks, all passing:**
- the `try.txt` gate, and the `ironhorse.txt` gate run three times;
- `ironhorse-snapshot`, both plain and with `deterministic-math,store-integrity`;
- `ironhorse-vm` with `deterministic-math,store-integrity`;
- `ironhorse-262` and `ironhorse-fuzz`;
- `cargo fmt --check`.

**Left alone on purpose:**
- **XS defects:** the `dstr/*-put-const` rows (20) and the `annexB/.../catch-redeclared-*` rows (10). Ironhorse is spec-correct there; the ratchet flags them because XS gets them wrong.
- **`Math.random`:** left out by design, pending an explicit decision.

**Follow-ups:**
- The successor `ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101-open-pr` is on the board (journal commit `a288a79d9d`). Its body holds the full PR text, which already passes the repo's PR-template check, and it runs `ensure-pr.sh` under this job's marker so no duplicate PR gets opened.
- #1602 and #1605 also move the snapshot golden files, so whichever of these PRs lands second will need to regenerate them.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 82 tokens (8939395 cached reads)
- Output: 24234 tokens
- Cost: $8.649134799999997 (1 engagement(s) unpriced)
- Wall-clock: 11720s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
