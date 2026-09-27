Finding `aaa423e9c5d56067` turned out to be an XS oracle spelling difference, not an Ironhorse bug. So there's no engine fix: I added regression tests, pushed them to the standing branch and documented the finding on the standing PR endojs/endo-but-for-bots#1298.

**Reproduction.** The input file's sha256 matches `3f59968f…`. At the fuzzed SHA `38ca1d18` the target crashes with a divergence. Both engines compute the same double, but XS prints it as `-31032616836661248` and Ironhorse prints `-31032616836661250`. Both strings parse back to the same double, and `-31032616836661250` is the shortest one that does, which is what the spec requires and what V8 (Node) prints. This is the same large-integer number-formatting case as earlier findings `8adaa3bbc9cda1ce` and `37e026fd30cbae19`. At the current standing tip the same run exits 0, because the harness fix `4b95dc199e` already checks number spelling against the spec rather than against XS.

**Regression tests** (commit `18ba50f1df`, pushed to `kriscendobot:ironhorse-fuzz-findings`):
- `rust/engine/ironhorse-vm/tests/finding_aaa423e9c5d56067_large_integer_dtoa.rs` plus the exact 5-byte fixture. It runs in CI without the XS submodule, replays the bytes, and asserts the program completes with the shortest spelling. It passes.
- `finding_aaa423e9c5d56067_large_integer_dtoa_agrees` in `ironhorse-fuzz/src/lib.rs` runs against XS, pins XS's double, and asserts the differential check agrees. It passes.

**PR:** `ensure-pr.sh` found the existing #1298 and created nothing new. The finding and its disposition are in a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855444455

**Gauntlet:** one is already running on #1298 (`endojs-endo-but-for-bots-pr1298-gauntlet`, now at fix iteration 1), so I didn't post a second one. I didn't check whether it has picked up the new head commit. Earlier findings today were handled the same way.

**Follow-up:** `cargo fmt --check` fails on the earlier `b95320dfb5dd9d3d` test in `ironhorse-fuzz/src/lib.rs` (one line over width). That isn't from this change and I left it out of this commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-aaa423e9c5d56067-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 62 tokens (2009036 cached reads)
- Output: 12738 tokens
- Cost: $1.2620791999999998 (2 engagement(s) unpriced)
- Wall-clock: 572s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
