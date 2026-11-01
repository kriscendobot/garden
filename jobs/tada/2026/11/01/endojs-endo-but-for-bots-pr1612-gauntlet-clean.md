---
orchestration-failed: true
---
orchestration-failed: CI on PR #1612 is RED. Four checks failed, and as far as I can tell none of the failures come from this PR's change.

**Note on the CI wait:** `ci-wait-merge.sh` returned rc 4 (still pending) only because one macOS leg, `test (22.x, macos-15)`, was still running at the 3600s deadline. The four failed checks were already final, so re-posting this stage would only reach the same red result. I'm reporting this as a failure rather than still-pending.

**Coverage pass**
- The PR fixes strict computed-key stores at two `property_at_set` sites in `ironhorse-vm/src/interp/property.rs`. The ordinary-object site was well tested, but no test reached the TypedArray named-key site.
- I added `strict_computed_named_store_on_typed_array_throws` to `ironhorse-262/tests/strict_set_string_wrapper_generator_links.rs`. It runs a strict computed store to a non-writable named key and to a new key on a non-extensible `Uint8Array`, and compares the result against XS.
- With the TypedArray-site fix temporarily removed, the new test fails (XS returns `true`, ironhorse returns `"stored:1"`), so it really tests that fix. With the fix in place, all 10 gate tests pass.
- `cargo fmt --check` passes. The touched test target is clean under clippy 1.88.0 `-D warnings` (the CI toolchain).
- The PR only adds code, so there was no dead code to remove.
- Pushed to the PR head as `ef25da3638` using `safe-push-pr-head.sh`, advancing it from `a65f16a6f7`.

**Failing checks** (all four also failed before my push, except the macOS 24.x leg, which was still running then):

| Check | Failure | Cause |
| --- | --- | --- |
| `ironhorse-oracle-sanitizers` | `stage3-math/054.js` and `055.js` (`Math.asinh`/`Math.acosh` last-digit differences) in `corpus_conversion_equivalence` and `generated_multi_crank` | Known ubuntu-26.04 glibc issue; the fix is #1613, still an open draft |
| `test-ironhorse-oracle` | Same `stage3-math` 054/055 failures | Same; #1613 |
| `sandbox-drivers` | bwrap test "timeout and repeated cancellation reap process groups" | Known runner issue; the fix is #1566, still an open draft |
| `test (24.x, macos-15)` | `packages/daemon` `test/http-content-plane.test.js` exited with code 1 | A JS daemon test, while this PR only changes Rust; probably flaky, and I didn't investigate further |

**Follow-ups**
- This gauntlet will keep going red until #1613 and #1566 land, or until their changes are brought into this PR's base. After that, re-run the gauntlet (or just CI).
- Re-run the macOS `http-content-plane` leg to confirm it's a flake.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1612-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3087487 cached reads)
- Output: 12652 tokens
- Cost: $1.5605214
- Wall-clock: 4026s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
