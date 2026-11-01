The third slice is done. `%TypedArray%.prototype.toReversed`, `toSorted` and `with` now exist in Ironhorse, all 43 cases in their test262 directories pass against the XS oracle, and the draft PR is open: https://github.com/endojs/endo-but-for-bots/pull/1600.

**Why this slice.** I counted failing rows in the committed whole-tree expectation shards, skipping Temporal. The first sibling slice already had RegExp accessors (`built-ins/RegExp/prototype`, 172 rows). The second sibling slice had AsyncFromSyncIterator (#1599). The next largest was `built-ins/TypedArray/prototype`, with 80 rows, almost all of them from these three methods. They were missing outright: `typeof` returned `"undefined"`.

**Engine change (`rust/engine/ironhorse-vm`).**
- **The three methods.** They are modeled on XS's versions in `xsDataView.c`. All three build their result with the receiver's own constructor and never consult `constructor` or `@@species`. They are installed where `intrinsic_order.rs` had already reserved their places.
- **`toSorted`.** It checks the comparator before the receiver, as the spec orders it, then sorts a copy using the existing sort routine.
- **`with`.** It converts the index and then the value exactly once, and checks the index against the array's *current* length. My first version crashed when that conversion grew the buffer. It now writes only within the length captured at the start.

**Snapshot and test fallout.** Three new built-in functions change the boot heap, so I followed the same procedure as #1599:
- Regenerated the `state_golden*` fixtures and the boot fingerprint under both math providers.
- Re-pinned the metamorphic hashes; the boot geometry goes from 1100 to 1103 slots.
- Rewrote the fuzz seeds with `write-seed-corpus`.
- Removed the now-closed "known gap" rows from `intrinsic_key_order.rs` and `xs_departures.rs`.

**Ratchet.** Four `whole-tree` shards change, moving 76 case/mode rows (38 cases) from fail to pass:

| Subtree | Before | After |
| --- | ---: | ---: |
| `toReversed` | 1 / 9 | 9 / 9 |
| `toSorted` | 3 / 12 | 12 / 12 |
| `with` | 1 / 22 | 22 / 22 |

I regenerated every `built-ins/TypedArray` shard (77) and every `built-ins/TypedArrayConstructors` shard (81). All the others came out byte-identical, so nothing regressed in either tree. As #1599 did, I left out the `baseline/refresh-*` floor directory, which waits on the open question in kriscendobot/garden#51.

**Tests.**
- **New test.** `ironhorse-262/tests/typed_array_change_by_copy.rs` has 4 tests, each checking agreement with XS.
- **Release suites.** `cargo test --release` passes for `ironhorse-vm`, `-262`, `-fuzz`, `-runtime`, `-snapshot` and `-compile`.
- **Second math provider.** The snapshot suites also pass under `--features ironhorse-vm/deterministic-math`.
- **Lint and format.** Clippy reports nothing in the touched files, and `cargo fmt --check` is clean.

**PR.** Head `ironhorse-test262-ratchet-typedarray-change-by-copy-20261101` (`a3482481`), base `llm-9a14ddf`. This host's bot token gets 403 when creating endojs PRs, so I posted a relay job pinned to the endolin host, `ironhorse-test262-ratchet-typedarray-change-by-copy-20261101-open-pr`. It opened #1600 with this job's marker, so this job's gauntlet will pick it up.

**Follow-ups.**
- #1600 and #1599 both change the boot-heap fixtures, so they will conflict there. Whichever merges second has to rerun the regeneration under both providers, `write-seed-corpus`, and the hash re-pin. Their expectation shards don't overlap.
- My FYI to the #1599 job about that conflict timed out under journal contention and may not have been delivered; the PR body documents it either way.
- Two `built-ins/TypedArray` cases still fail; they were already failing on `llm` before this change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-third-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 252 tokens (15944999 cached reads)
- Output: 52653 tokens
- Cost: $5.796179800000002
- Wall-clock: 6994s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
