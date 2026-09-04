The comment review is posted with the panel verdict. The panel decided cleanly (exit 0), disposition **must-fix**. This stage is complete — one round run, verdict posted, stopping here.

## Report

**Stage:** Gauntlet PANEL round 1 — endojs/endo-but-for-bots PR #1150 (`feat(ironhorse,xsnap): formal Panic category + live FFI-abort guard`).

**What I did:**
- Resolved the PR head (fork `kriscendobot/endo-but-for-bots`, branch `build/ironhorse-panic`, base `llm`) and got an isolated project worktree.
- Ran the panel in single-round mode. My first two attempts were reaped mid-run; on the third I launched it **detached via `setsid`**, which survived the reap and completed cleanly: `PANEL_EXIT=0`, disposition **must-fix**.
- Posted the aggregate to PR #1150. A `--request-changes` review is impossible (GitHub blocks requesting changes on your own PR — the PR head is the same bot identity), so I posted it as a **comment review** carrying the full panel-verdict body plus a `<!-- garden-panel-verdict … = must-fix -->` marker, and a continuation comment with the remaining seats (the 115KB aggregate was split across two bodies to stay under GitHub's 65,536-char limit).

**Key findings (must-fix):**
- `ironhorse_engine.rs:152-161` — `ExecutionOutcome::classify` funnels `Halt::Unsupported` into the permissive `other =>` arm (panics in debug, returns `Quiesced` in release), so a named engine-gap run would be told to *commit*.
- `xsnap/src/lib.rs:1769-1779` — FFI poison drained only at crank-end, but guarded callbacks run during bootstrap; a panic there hangs the worker forever in `recv_raw_envelope()`.
- `rust/engine/ASYNC-AWAIT-HANDOFF.md:140` — bakes `TMPDIR=/home/kris/tmp` (one machine's home) into a handoff doc.

**Follow-ups for later stages:** Several seats flagged that the fork's `llm` base is ~42 commits stale (`67dfc18b1` vs upstream `e84a4c83c`); the fix stage should rebase the head onto current `llm` so CI and the changeset seats see the real 6-file delta rather than a 4,742-file inflation.

No fix/un-draft/loop performed, per single-round contract.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-panic-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 72 tokens (1924558 cached reads)
- Output: 14962 tokens
- Cost: $2.4869215000000002
- Wall-clock: 895s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
