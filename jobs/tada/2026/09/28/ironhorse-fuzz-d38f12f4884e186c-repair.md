Finding d38f12f4884e186c (target `differential_regexp_surface`) is now locked by regression tests on the standing branch and written up on standing PR endojs/endo-but-for-bots#1298. The crash was a fault in the XS oracle, not in Ironhorse, and that fault was already fixed on the branch, so no engine change was needed.

- **Input:** I decoded the 6-byte input from the journal finding file; its sha256 matches `a28c0d27…6ed1c85e`.
- **Reproduced at `38ca1d18`:** I ran the pinned fuzz command (`nightly-2026-08-15`, `c/moddable` taken from a peer checkout) on a separate checkout of that SHA. It panics with a `result:` mismatch. The input generates `new RegExp(<nested disjunction>, "").source`, which should return a 1166-byte string. The XS oracle returned only the first ~1 KiB of it, while Ironhorse returned the whole string.
- **Cause:** the oracle used to copy results into a fixed 1024-byte buffer and cut off anything longer. Siblings `bc3d0df623811a38`, `6ba52f2bdc534545` and `9001b34fa6dd2d80` were the same problem. Commit 7fae4aea2f fixed the oracle and is already on `ironhorse-fuzz-findings`. At the branch tip the same fuzz command exits 0.
- **Regression tests (commit 12f9ffc1a3, pushed to `ironhorse-fuzz-findings` with fetch/rebase/push):**
  - `ironhorse-vm/tests/finding_d38f12f4884e186c_regexp_source.rs` builds without the oracle or submodule. It checks the input's sha256, replays the bytecode and symbols XS produced for this input, and requires the full 1166-byte result.
  - `ironhorse-fuzz/tests/finding_d38f12f4884e186c_regexp_source.rs` runs against the real XS oracle. It requires an untruncated 1166-byte oracle result that equals the VM test's expected value, and no divergence from `differential_check_meter_v4`.
  - New fixtures in `ironhorse-vm/tests/fixtures/`: input, bytecode, symbols and expected result. `vm_finding_fixtures.rs`, which regenerates these files from the input and compares them, passes.
- **Checks:** both new tests pass on the branch. `cargo fmt --check` is clean for both crates, and `cargo clippy` reported nothing in the new test files.
- **Formatting fix (commit c9c0d95d93):** the earlier `378372c8706a48a8` test file was not rustfmt-formatted, so I formatted it.
- **PR:** `ensure-pr.sh --find-only` found the existing #1298 (still open and draft), so I added to it rather than opening a new one. The write-up is at https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5866565270.
- **Gauntlet:** a gauntlet for #1298 is already running on the journal board (`endojs-endo-but-for-bots-pr1298-gauntlet`, with its `-fix-3` job in progress), so I did not start another one.

No follow-ups needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-d38f12f4884e186c-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (5 unmetered)
- Input: 66 tokens (2669948 cached reads)
- Output: 14380 tokens
- Cost: $1.5754136 (5 engagement(s) unpriced)
- Wall-clock: 998s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×1

<!-- garden-usage-end -->
