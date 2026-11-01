I fixed one Ironhorse bug and opened two draft PRs that raise the ratchet by 14 rows in total. The engine fix passed every local check. The other PR only re-baselines expectations, and I didn't wait for CI on either one.

**Which rows I took.** About 2,056 rows in the committed whole-tree lists fail. Leaving out the shards that open Ironhorse PRs already touch, and Temporal/Intl, almost all the rest are cases where the XS oracle is wrong and Ironhorse is right. Two sets were real work:
1. `built-ins/RegExp/match-indices/indices-groups-object-undefined.js`, an actual Ironhorse bug.
2. 12 rows that the RegExp accessors fix in #1605 makes pass but that #1605 never recorded: `Object/getOwnPropertyDescriptor/15.2.3.3-4-212..215` and `Proxy/{has,set}/trap-is-missing-target-is-proxy`.

**PR 1: https://github.com/endojs/endo-but-for-bots/pull/1619** (draft, base `llm-9a14ddf`)
- **The bug:** a regex match result only got `index`, `input`, `groups` (and `indices` with the `d` flag) if the program's source happened to spell those names. Code that reached them indirectly, like `Object.keys` or a computed key, found them missing.
- **The fix:** the exec code in `ironhorse-vm/src/interp/natives/regexp.rs` now registers those names before it builds the result. The replace path already did the same thing.
- **Ratchet:** +2 (the match-indices row now passes in both sloppy and strict).
- **Snapshot tests:** the `regexp` row of the state goldens changes, so I regenerated it under both math providers; nothing else in them moved. I also had to move the RegExp line in `streaming-baseline.js` below the Intl lines. Otherwise that test fixture stops producing one of the snapshot sections its test checks for (`NFLR`).
- **New test:** `ironhorse-vm/tests/regexp_exec_unnamed_result_keys.rs`, with expected values checked against the XS oracle.
- **Checks:**
  - All 1,930 whole-tree shards meet their expectations, and match-indices is the only shard that changed.
  - The whole engine workspace test suite passes, and the vm and snapshot tests also pass with deterministic math.
  - `cargo fmt` is clean, and clippy with the pinned 1.88 toolchain shows no warnings.

**PR 2: https://github.com/endojs/endo-but-for-bots/pull/1620** (draft, stacked on #1605's branch)
- Expectation updates only, no engine code: +12 rows, all fail → pass, generated at #1605's head.
- Without this, those 12 rows would show up as gate drift once #1605 lands. #1605 needs to fold it in or merge it first.
- `ensure-pr.sh` didn't record it on the board, because I opened it under a sub-job name (`…-accessors-collateral`) that has no claimed job.

**A mistake to clean up.** I sent my announcements to the 10th and 15th slices, and later updates to the 16th and 18th, without checking first whether they were still running. All four had finished, so each message became a "deadmail" job in the todo queue:
- `deadmail-20261101T150553Z-9c10ce`
- `deadmail-20261101T150558Z-91f0ef`
- `deadmail-20261101T155047Z-c1804f`
- `deadmail-20261101T155052Z-5d5ca8`

They carry no work. There's no tool to withdraw a todo job, so I messaged the maintainer to say they can be dropped. If a worker claims one first, it could take the message as an instruction to redo these rows.

The 18th slice told me it had opened #1618 and released the rest of its rows; nothing there overlaps my work. I added notes to the slice-coordination memory: check which peers are still running before messaging them, look for rows a peer PR makes pass outside its own shards, and the snapshot-fixture fix above.

**Follow-ups**
- #1619 and #1620 now go through the automatic review and fix pipeline.
- #1605's owner needs to fold #1620 in.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-nineteenth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 172 tokens (10075087 cached reads)
- Output: 41281 tokens
- Cost: $4.112813400000001
- Wall-clock: 2845s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
