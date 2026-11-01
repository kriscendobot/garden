---
posted_at: 2026-11-01T04:58:44Z
role: builder
arc: ironhorse-test262-ratchet
requires: host=endolin-garden-ece02cb4
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Open the draft PR for the TypedArray change-array-by-copy ratchet slice

Repo: https://github.com/endojs/endo-but-for-bots. Relay from job `ironhorse-test262-ratchet-coverage-crank-third-slice-20261101` on oros-studio-garden-ce242c49, whose bot PAT gets 403 on createPullRequest for endojs.

The head `ironhorse-test262-ratchet-typedarray-change-by-copy-20261101` (a3482481fc0992542d1edd5aeae296475d20bd36) and the frozen base `llm-9a14ddf` (9a14ddf660912ed624e2d9047671d43e3a2f0cec) are ALREADY pushed. Do not modify the branch. Your only task is to open the DRAFT PR, from a project checkout of the head made with ensure-project-worktree.sh (cwd = that checkout). The body goes into a file verbatim. Use the ORIGINAL job's base as the marker key so its gauntlet adopts the PR:

    /Users/dom/garden/scripts/jobs/gardening/ensure-pr.sh ironhorse-test262-ratchet-coverage-crank-third-slice-20261101 endojs/endo-but-for-bots ironhorse-test262-ratchet-typedarray-change-by-copy-20261101 llm-9a14ddf --title "fix(ironhorse-vm): add %TypedArray%.prototype toReversed, toSorted and with" --body-file <file>

Report the PR URL. If ensure-pr.sh finds an existing PR (marker `garden-job: ironhorse-test262-ratchet-coverage-crank-third-slice-20261101`), adopt it. Completion stages the gauntlet as for any builder PR.

PR body (between the BODY markers, verbatim):

----- BODY -----
Refs: https://github.com/kriscendobot/garden/issues/51

<!-- garden-job: ironhorse-test262-ratchet-coverage-crank-third-slice-20261101 -->

## Description

`%TypedArray%.prototype` gains the three change-array-by-copy methods, `toReversed()`, `toSorted(comparefn)` and `with(index, value)`. Until now they were missing outright (`typeof` was `"undefined"`), so every case under their three test262 directories failed. This follows XS's `fx_TypedArray_prototype_toReversed`, `_toSorted` and `_with` (`xsDataView.c`), with the spec's ordering where the two differ.

- **Allocation.** All three methods call a new `typed_array_create_same_type` helper (`TypedArrayCreateSameType`). It constructs the receiver's concrete intrinsic constructor directly and never reads `constructor` or `@@species`. That is what the `ignores-species.js` cases check.
- **`toReversed`.** Validates the receiver and copies its elements into the result in reverse order, as raw same-type bytes, so NaN payloads and `-0` survive. Constructing the intrinsic runs no guest code, so the receiver cannot shrink in the middle of the copy.
- **`toSorted`.** Rejects a comparator that is neither `undefined` nor callable *before* it validates the receiver, which is the spec's step order. It then copies the receiver into the result and runs the existing `typed_array_sort` on the copy. That reads the same values in the same order as sorting a list taken from the receiver, keeps the stable insertion sort and the NaN/`-0` ordering, and writes only to the result.
- **`with`.**
  - Coerces the index (`ToIntegerOrInfinity`) and then the value (`ToNumber`/`ToBigInt`) exactly once, before allocating.
  - Checks `IsValidIntegerIndex` against the *live* length, because either coercion can resize the buffer, and throws `RangeError("invalid index")` as XS does.
  - Copies the receiver's surviving prefix. Indices a shrink removed read `undefined`, which becomes NaN or 0 in a Number view and a `TypeError` in a BigInt view.
  - Writes the replacement only when the index is below the captured length. A view that *grew* during coercion (`valid-typedarray-index-checked-after-coercions.js`) returns a result of the old length.
- **Boot heap.** The three natives join `%TypedArray.prototype%` at the places `intrinsic_order.rs` already reserved for them (after `values`). That moves the golden vectors, the platform boot fingerprint, the `state_golden*` fixtures, the snapshot fuzz seeds, and the epoch-3 geometry (1100 → 1103 slots, 17184 → 17240 chunk bytes). The fixtures were regenerated with `regenerate_persistence_identities` under **both** math providers, the metamorphic markers were re-pinned under both providers, and the seeds were rewritten with `write-seed-corpus`. Runtime costs are unchanged: the regeneration tool asserts this before it writes.

**Coverage (test262 `be13516f`, XS oracle on).** Before this change is `llm` 9a14ddf; after is this branch.

| Subtree | Before | After |
| --- | ---: | ---: |
| built-ins/TypedArray/prototype/toReversed | 1 / 9 | **9 / 9** |
| built-ins/TypedArray/prototype/toSorted | 3 / 12 | **12 / 12** |
| built-ins/TypedArray/prototype/with | 1 / 22 | **22 / 22** |
| built-ins/TypedArray (whole) | | +38 cases, 0 lost |
| built-ins/TypedArrayConstructors | 710 / 738 | 710 / 738 (unchanged) |

This PR raises the committed ratchet. It re-measures the four affected `expectations/whole-tree` shards, where 76 case/mode rows move from fail to pass. I regenerated all 77 `built-ins/TypedArray` shards and all 81 `built-ins/TypedArrayConstructors` shards from this branch. Every other shard was byte-identical to the committed list.

The new `ironhorse-262/tests/typed_array_change_by_copy.rs` runs oracle-backed checks of the descriptors, the own-key order, species independence, NaN/`-0` handling, the comparator check order, and the coercion-time resize cases under both engines.

Not in this PR:

- No `baseline/refresh-*` floor directory. That needs a whole-tree sweep at the merged head, and the open floor-resolution question on https://github.com/kriscendobot/garden/issues/51 governs it. https://github.com/endojs/endo-but-for-bots/pull/1599 made the same call.
- This PR overlaps https://github.com/endojs/endo-but-for-bots/pull/1599 (AsyncFromSyncIterator) on the boot-heap identities: `metamorphic_determinism.rs`, `state_golden*.tsv`, `math-platform-boot.bin`, the fuzz seeds and the epoch-3 geometry. Whichever lands second must rerun `regenerate_persistence_identities` under both providers, `write-seed-corpus`, and the marker re-pin. Their expectation shards do not overlap.

### Security Considerations

None. The methods allocate only a fresh view of the receiver's own element type and run no guest code beyond what the spec requires: the index/value coercions and the comparator.

### Scaling Considerations

Each call allocates one view of the receiver's length, which is the cost the specification requires. `toSorted` keeps `sort`'s quadratic insertion sort, so its comparator call sequence is fallible and deterministic.

### Documentation Considerations

None. The methods are standard ECMAScript 2023 built-ins and need no Ironhorse-specific documentation. The closed gap rows leave `xs_departures.rs` and the `KEY_SET_DIFFERENCES` table of `intrinsic_key_order.rs`.

### Testing Considerations

The new `typed_array_change_by_copy.rs` runs oracle-backed checks against XS. The whole-tree expectation shards gate the 43 test262 cases, and every `built-ins/TypedArray` and `built-ins/TypedArrayConstructors` shard was regenerated and compared. `cargo test --release` passes for `ironhorse-vm`, `ironhorse-262`, `ironhorse-fuzz`, `ironhorse-runtime`, `ironhorse-snapshot` and `ironhorse-compile`, and the snapshot suites also pass under `--features ironhorse-vm/deterministic-math`.

### Compatibility Considerations

Snapshot images gain three boot slots. The format version is unchanged.

### Upgrade Considerations

The snapshot format and store schema are unchanged. The boot fingerprint moves, so images taken by an earlier build meet the same fingerprint check as after any other boot-heap change. Nothing else changes.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
