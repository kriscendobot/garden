Clean stage for endojs/endo-but-for-bots PR #1533 (TUI region store and text/buffer bus verbs, endor-bus-tui Phase 1) is done. Nothing needed changing, so I pushed nothing to the PR, and CI is green.

**What the PR touches:** five Rust files under `rust/endo/src/` (`codec.rs`, `tui_store.rs`, `supervisor.rs`, `endo.rs`, `lib.rs`), at head `3ffd8867` on base `llm-54d3d2a`. It is still a draft.

**Coverage pass:**
- I ran the TUI and codec unit tests (`cargo test --lib --no-default-features -- tui codec`) in an isolated checkout: 37 passed, 0 failed. The PR adds 18 tests covering the codec round trips, missing or wrong-typed keys, store behavior (scrollback eviction and clamping, wrong-role rejection, IDs scoped per owner, owner sweep, oversized text, a full dispatch sequence, unknown verbs) and the sweep on unregister.
- No Rust coverage tool is installed on this host (no `cargo llvm-cov` or tarpaulin), so I couldn't produce a line-coverage number. Instead I checked by hand which new public functions have callers. All the main paths are tested. The one gap is the `tui.` routing branch at `endo.rs:700`, which has no test of its own; the `dispatch()` function it calls is tested directly. I judged that enough and added no tests.

**Dead code:**
- Neither the test build nor a normal `cargo check --lib --bins` reports a warning in any file this PR touches. The only Rust warnings are two unused functions in `assemble.rs`, which this PR doesn't touch.
- Four client-side codec functions (`encode_tui_request`, `decode_tui_reply`, `decode_tui_error`, `tui_request_verb`) are only called from tests for now. They are the other half of the new protocol rather than code the change left unused, so I kept them.

**CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1533 --no-merge` returned rc 0: 35 checks, 0 failed.

**Local setup:** building locally needed `git submodule update --init c/moddable` in the scratch checkout. The build also expects four generated JS bootstrap files, so I created empty placeholders to compile, then deleted them; none of this was committed. Build output went to `scratch/cargo-target-pr1533`.

**Follow-ups:** none for this stage. The panel stage is next.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1533-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (729050 cached reads)
- Output: 5875 tokens
- Cost: $0.6753260000000001
- Wall-clock: 1119s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
