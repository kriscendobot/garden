# Ironhorse test262 ratchet, sixth slice: `with` bindings deleted mid-reference (19 rows now pass, 0 lost)

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1601. It is on branch `ironhorse-test262-ratchet-with-binding-deleted-20261101`, against the frozen base `llm-9a14ddf`, and carries the `garden-arc: ironhorse-test262-ratchet` marker.

**Choosing the slice.** I grouped the failing rows in the committed `expectations/whole-tree` shards and left out everything already taken:
- the in-flight slices: RegExp flag accessors, AsyncFromSyncIterator (#1599), TypedArray change-by-copy (#1600), resource disposal (the fifth slice's local branch), and Promise (the seventh slice told me over the inbox);
- Temporal, which is host-excluded.

The cluster I took is a `with` object binding that is deleted after the name was resolved but before the read or store. I told the seventh slice which slice I took.

**The engine fix** (`ironhorse-vm/src/interp/dispatch/environment.rs`):
- **Strict store.** When the binding has been deleted, a strict store now throws a `ReferenceError` before the store, as the spec's `SetMutableBinding` step 3 and XS's `SET_VARIABLE` both do. Ironhorse already ran the existence check but ignored the result. A comment there pointed to an "oracle-defect pin" that no longer exists, so I replaced it.
- **Read.** Reading a deleted binding on a `with` object with no Proxy on its prototype chain now throws `get x: undefined variable` in both strict and sloppy code, as XS does. `typeof` is exempt, and a Proxy `with` object still answers through its `get` trap.

**Ratchet.** I re-ran every shard under `language/` (504) and `annexB/` against the pinned test262, plus the five `built-ins` directories whose tests use `with`. Seven shards changed:
- **19 rows went from fail to pass:**
  - compound assignment: 11
  - plain assignment: 1
  - prefix and postfix `++`/`--`: 4
  - `with` statement get/set: 3
- **1 row went from fail to `skip:shared-positive-test-failure`.** XS fails that test the same way, so Ironhorse no longer accepts something the oracle rejects.
- **No losses.**

I did not create a `baseline/refresh-*` floor directory. That needs a whole-tree sweep at the merged head, and the open floor-resolution question on kriscendobot/garden#51 governs it.

**Tests.** I added `ironhorse-262/tests/with_binding_deleted.rs`, which runs each case on both Ironhorse and XS. Two of its three tests fail without the engine change.

These all passed locally:
- `cargo test --release -p ironhorse-vm -p ironhorse-262`;
- the deterministic-math with store-integrity configuration, and the cost-calibration configuration;
- the `ironhorse.txt` expectation gate (1712/1712);
- `cargo fmt --check`, and clippy on 1.88.0 run the way CI runs it.

Nothing new goes into the boot heap, so no snapshot or fuzz artifacts needed regenerating.

**CI.** These passed: `test-ironhorse`, `-release`, `-macos`, `-calibration`, `test-thixotrope-ironhorse`, `format`, `fuzz`, `cross-target`, `wasm` and `lint`.

`test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` fail, but only on `stage3-math/054.js` and `055.js`, where `Math.asinh` and `Math.acosh` differ from XS in the last digit. #1548 and #1599 fail on the same two cases, so the failure predates this PR; I noted that on the PR.

When I stopped, four JS `test` matrix jobs were still pending. This PR changes no JS.

**Follow-ups:**
- Several crank PRs are now open in parallel, and the ratchet autopilot stops when more than one is open. The maintainer will need to handle that when the delegation resumes.
- The PR stays draft until the gauntlet runs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-sixth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 174 tokens (9801289 cached reads)
- Output: 35674 tokens
- Cost: $3.868121800000001
- Wall-clock: 4236s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
