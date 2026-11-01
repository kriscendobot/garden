orchestration stage result: **clean = still pending.** I pushed a fix to PR #1618, but CI hadn't finished after the 3600 s deadline (`ci-wait-merge.sh` returned rc 4).

**Coverage and dead-code pass** (on PR head `cd17f5938b`, files under `rust/engine/`):
- **Broken audit test, fixed.** The PR removed `save_captures` from `ironhorse-regexp/src/matcher.rs` (replaced by `StateStack::push` / `admits`). But `ironhorse-vm/tests/declared_width_audit.rs` still listed `save_captures` in `MATCHER_CHARGES`, so `matcher_charges_declared_widths` panicked with "declaration must be unique: fn save_captures". I reproduced that locally. The table now points at `admits` and checks it charges both `STATE_CHARGE` and the new `OFFSET_CHARGE`. This would have turned the `test-ironhorse` lane red.
- **Untested branch, now covered.** No test reached the path where a compressed push is refused for hitting `MAX_MATCH_BYTES`. I added a unit test, `compressed_offsets_are_charged_against_the_byte_ceiling`, covering both the compressed push and the new-record push being refused at the limit.
- **Nothing else orphaned.** The other references to `save_captures` are in the dated `architecture-review/2026-10-16` docs, which I left alone.
- **Local checks:** `cargo test -p ironhorse-regexp` passes (51 + all integration tests), `declared_width_audit` passes 10/10, and clippy with `-D warnings` and `cargo fmt` are clean.
- **Pushed** commit `89e7260f8c` to `fix/ironhorse-regexp-compressed-backtrack-runs` with `safe-push-pr-head.sh` (a fast-forward from `cd17f5938b`).

**CI at head `89e7260f8c`:** 7 of 37 checks were still pending at the deadline (`test` on 22.x macOS and both 24.x legs, `test-thixotrope-ironhorse`, `test-ironhorse`, `test-ironhorse-release`, `test-ironhorse-macos`). Three checks are red:
- **`ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`:** the failing tests are `corpus_conversion_equivalence` and `generated_multi_crank`. For the sanitizer lane, the log shows the failing rows are stage3-math `054.js` / `055.js` (`Math.asinh` / `Math.acosh` last-digit divergence, the known Ubuntu 26.04 glibc issue). The `test-ironhorse-oracle` log can't be read until the run finishes. I'm attributing it to the same cause because a peer ratchet branch failed the same test today. The real fix is #1613 ("run the XS oracle lanes on Ubuntu 24.04"), which is still open. This PR's base `llm-9a14ddf` matches `llm` and doesn't have that fix.
- **`test (22.x, ubuntu-latest)`:** I haven't identified the cause, because the logs stay locked until the CI run completes. The next pass needs to look at it.

**For the next pass of this stage:**
1. Re-wait on the remaining checks.
2. Find out what failed in `test (22.x, ubuntu-latest)`.
3. Unless #1613 has landed and the PR is re-woven onto a base that includes it, the two oracle lanes will keep this stage red (rc 3). That's a call for the maintainer, not something this PR's diff can fix.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1618-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2969407 cached reads)
- Output: 12128 tokens
- Cost: $1.5520094
- Wall-clock: 3848s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
