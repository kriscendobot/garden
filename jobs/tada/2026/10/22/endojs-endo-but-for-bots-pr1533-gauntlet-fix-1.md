---
orchestration-failed: true
---
I applied all the panel's must-fix items and pushed them to PR #1533, but CI came back red (`ci-wait-merge` rc=3). Every red check fails only from the known ubuntu-26.04 runner problem, not from this change.

**Round-1 verdict.** The job carried no pre-pass findings, so I used the latest panel verdict: the "Must-fix before merge" review (durable record `3fb504ea6196`, head `3ffd8867`). Its 20 published must-fix lines all come from the breaker seat. Seven other seats also voted must-fix (engine-realist, prover, pruner, purist, saboteur, warden, wire-watcher), but their items are not in the published list or the record, so this round could not address them. The driver's panel-2 will re-evaluate.

**What I pushed.** Commit `9bdad1f2a` on `endor-bus-tui/phase-1-region-store`, pushed with `safe-push-pr-head.sh` as a fast-forward of `3ffd8867`:
- **Slow map decoding (must-fix):** `read_value` now refuses any `tui.*` CBOR map claiming more than 16 entries, before reading keys (`TUI_MAX_MAP_ENTRIES`; run attrs, the largest map, have 7 keys). The duplicate-key check and `Fields::take` therefore stay cheap on the routing loop.
- **No per-worker storage limit (must-fix):** in `tui_store.rs` each owner's bytes, windows and regions are now tracked, so every limit check is constant-time. The new limits:
  - each region holds at most `MAX_TEXT_BYTES`, and a buffer evicts its oldest lines to stay under that and under its line capacity;
  - window titles are capped at `MAX_TITLE_BYTES` (1 KiB) and count toward the owner's total;
  - each owner is capped at `MAX_OWNER_BYTES` (8 MiB), `MAX_OWNER_WINDOWS` (64) and `MAX_OWNER_REGIONS` (256), all answered with `too-large`;
  - every stored run is charged 32 bytes on top of its text, so empty lines still count.

  A refused request leaves the store unchanged, and the counts are released on destroy and on `sweep_owner`.
- **Integer overflow (should-fix):** `Cursor::read_int` now converts with a range check, so a value above `i64::MAX` or a negative int with a 2⁶³ head is a `bad-argument` instead of wrapping (release) or panicking (debug). The byte, text and skip length checks no longer overflow on a huge length either. This parser is shared with the existing non-TUI decoders, so those also reject such values now.
- **`apply` skipped validation (comment-only):** `TuiStore::apply` now re-checks the window role and the layout hint (dock, non-negative sizes), using the same new `validate_tui_layout_hint` / `validate_tui_window_role` functions as the decoder.
- **Tests:** I added 8, covering the map cap, out-of-range ints, huge text lengths, the title cap, the window/region caps, buffer eviction by bytes, the per-owner byte cap and its release, and the re-validation in `apply`. All 395 `rust/endo` lib tests pass locally, and clippy shows no new warnings.

**CI.** These checks are red:
- `test (22.x / 24.x, ubuntu-latest)`
- `cover (22.x / 24.x, ubuntu-latest)`
- `sandbox-drivers`

Each fails only in the `packages/sandbox` bwrap tests: "prlimit nproc cap is enforced inside the slice" (`/bin/sh: 1: ulimit: Illegal option -u`) and "bwrap parent death leaves no owned process group". That is the ubuntu-latest switch to 26.04 that has been failing every PR since about 10:24Z today. Both macOS `test` jobs and the other checks passed. The PR's base is the frozen `llm-54d3d2a`, so no upstream fix can reach it until the base moves.

**Follow-ups:**
- The CI breakage needs a fix outside this PR, either a test change or pinning the runner image. Until then every gauntlet CI wait will go red.
- The seven other must-fix seats' items were not in the published verdict, so panel-2 should be checked for them.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1533-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (5089834 cached reads)
- Output: 29492 tokens
- Cost: $2.5736947999999997
- Wall-clock: 3247s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
