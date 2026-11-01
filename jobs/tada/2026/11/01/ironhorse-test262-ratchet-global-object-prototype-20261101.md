I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1610 (head `ironhorse-global-object-prototype`, base `llm-9a14ddf`). It fixes CORE-4 / PROP-7 / ONT-17: the global object and every Compartment global now inherit from `%Object.prototype%` instead of having a null prototype. All tests and the local whole-tree sweep pass with no regressions; CI on the PR hasn't been checked yet.

**Code changes** (`rust/engine/ironhorse-vm/src/interp/`):
- **`boot.rs`:** `create_intrinsics` sets the default global's prototype to `%Object.prototype%` as soon as that object is created.
- **`realm.rs`:** `create_environment` creates each Compartment global with `%Object.prototype%` as its prototype.
- **`dispatch/environment.rs`:** the `GET_VARIABLE` and `SET_VARIABLE` code that looked names up on `%Object.prototype%` directly now looks them up on the global object itself. Bare-name lookup and `name in globalThis` now give the same answer, and metering is unchanged.
- **Snapshots:** restore keeps the link, because the prototype is stored in the global object's slot. The state_golden round-trips cover this.

**Tests and regenerated files:**
- **New tests:** `ironhorse-vm/tests/global_object_prototype.rs` checks each behavior from the review's probe (`instanceof Object`, `this.hasOwnProperty`, `'toString' in globalThis`, `String(globalThis)`, and so on). `guest_compartment.rs` has a new test checking the same link for a Compartment global. I also updated a stale comment in `strict_unresolvable_assignment.rs`.
- **Regenerated for the boot-heap change:**
  - state_golden fixtures and `math-platform-boot.bin`, under both math providers.
  - `metamorphic_determinism` hashes, under both providers, with a history comment added.
  - fuzz seeds, via `write-seed-corpus`.
- **Unchanged:** the hardened262 baselines needed no update, and `native_lockdown_corpora` passes as is.
- **Results:** `cargo test --release --workspace --no-fail-fast` is green. `ironhorse-snapshot` and `ironhorse-vm` are also green with `deterministic-math`. `cargo fmt --check` is clean, and my changes add no clippy warnings.

**Whole-tree test262 sweep** (all 1930 batches, `--case-timeout 60`, about 5 minutes): 10 shard files changed. 18 rows went from fail to pass, one went from fail to skip, and nothing regressed. The six rows the job listed all moved:
- `Object/getPrototypeOf/15.2.3.2-2-30` now passes.
- `Object/defineProperty/15.2.3.6-4-625gs` passes in sloppy mode. In strict mode it is now skipped as `oracle-xs-script-decl-eval-framing`.
- `parseInt/S15.1.2.2_A9.5` and `parseFloat/S15.1.2.3_A7.5` pass.
- `global-code/decl-lex` passes.
- `statements/function/S13.2.2_A19_T7` passes in sloppy mode.

The four `{encode,decode}URI{,Component}` `S15.1.3.*_A5.5` files also pass now.

**Follow-ups:**
- The PR is a draft. Finishing this build job should automatically start the usual chain (cleanup, panel review, fix loop, un-draft).
- Expect the `stage3-math/054`/`055` failures in the oracle CI lanes. They predate this PR (#1585).
- I did not run the SES/thixotrope JS suites locally. `generate-preludes.js` failed because the `prelude/` directory is missing, so CI is the check for those.
- The boot fingerprint changes, so snapshots taken before this change won't restore against the new engine. The PR description says so.
- At the start I sent the five live coverage-crank slices the list of rows and files I was taking. None of them replied.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-global-object-prototype-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4053360 cached reads)
- Output: 23279 tokens
- Cost: $2.15674
- Wall-clock: 1207s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
