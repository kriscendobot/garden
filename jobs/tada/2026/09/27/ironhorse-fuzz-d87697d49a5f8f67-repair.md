## Finding d87697d49a5f8f67 (`differential_source`): done, no engine fix needed

This is an XS number-spelling difference, not an Ironhorse bug. I added regression tests for it to PR #1298.

**Starting point:** the earlier attempt had committed nothing, and nothing about this finding was on the branch or in the PR, so I started fresh. I rebuilt the 7-byte input from the journal copy and its sha256 matched `b4814c1b…9311b`.

**Reproduction:** at the fuzzed SHA `38ca1d1893`, with the pinned nightly and the `c/moddable` submodule, the fuzz target panics with `result: oracle="2513641910770335700" ironhorse="2513641910770336000"`. At the tip of the `ironhorse-fuzz-findings` branch the same input runs cleanly.

**Cause:** the input turns into the program `((~(~(1585446912 / true))) * (~(~(1585446912 / true))))`. Its value is exactly the double 2513641910770335744.
- Ironhorse prints the 16-digit form `2513641910770336000`. That decimal sits exactly halfway between the value and the next double up. The value's significand is even, so round-half-even maps it back to the same double. It is therefore the shortest spelling the spec allows, and V8/node print the same thing.
- XS prints the longer 17-digit `2513641910770335700`, which is the same double but not the shortest.
- This is the mirror image of earlier findings `05264cccae42245a` and `931a687135cabb0c`. The branch already compares the exact double rather than the printed digits (commit `fdb9fef6e0`), which covers this case, so no code change was needed.

**What changed:** one commit, `d84a2d740d`, pushed to `ironhorse-fuzz-findings` by rebase-and-retry:
- **VM test:** `rust/engine/ironhorse-vm/tests/finding_d87697d49a5f8f67_even_tie_dtoa.rs`, plus the input file under `tests/fixtures/`. It needs neither the submodule nor the XS oracle. It replays the exact bytes and checks the generated program, the result `2513641910770336000`, and that this spelling round-trips and is the shortest.
- **Fuzz-crate test:** `finding_d87697d49a5f8f67_even_tie_dtoa_agrees` in `ironhorse-fuzz/src/lib.rs` checks the oracle's exact double and that the differential check passes.
- Both tests pass locally, and the pinned `cargo +1.88.0 fmt --check` is clean. I did not wait for GitHub CI on the new commit.

**PR:** `ensure-pr.sh --find-only` found the existing standing PR, endojs/endo-but-for-bots#1298, and I opened no new one. I posted the finding, its cause and the tests as a comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855786540

**Gauntlet:** a gauntlet on #1298 is already running (`endojs-endo-but-for-bots-pr1298-gauntlet`, now in its first fix round), so I did not start another. Its next review round will run on the new head, which includes this commit.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-d87697d49a5f8f67-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 9 on 2 host(s) (6 unmetered)
- Input: 62 tokens (2344280 cached reads)
- Output: 15247 tokens
- Cost: $1.4609240000000003 (6 engagement(s) unpriced)
- Wall-clock: 1358s
- Model(s): claude-opus-4-8 ×2, claude-opus-5-5 ×1

<!-- garden-usage-end -->
