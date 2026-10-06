---
orchestration-failed: true
---
orchestration-failed: true

**Fix round 1, endojs/endo-but-for-bots#1370 (gauntlet `endojs-endo-but-for-bots-pr1370-gauntlet-run-20261006`): all the panel's must-fix items are applied and pushed, but CI came back RED on one cell.**

`ci-wait-merge.sh` exited with rc 3. 34 of the 35 checks passed and only `test (22.x, macos-15)` failed. I could not read that job's log because the GitHub API rate limit for the bot account ran out. I have not established whether the failure is related to this PR. The PR changes only Markdown and one Rust doc comment, so a flake is likely, but that is not confirmed. Next step: look at the failed job in run 37487678215, or re-run it once the rate limit resets.

**Changes, pushed as follow-up commit `7a8ddf2dcc` on `design/ironhorse-panic-answers` (pushed with `safe-push-pr-head.sh`):**
1. **Broken source references (critic must-fix 1):** I put the bolded heading in `designs/ironhorse-panic.md` § Scope back to **"The already-live FFI abort hazard"**. Five source comments quote that exact text: `worker_io.rs:411,1372`, `debug.rs:124`, `lib.rs:563` and `inproc.rs:248`. They point at an existing heading again, including the one that backs the `compile_error!` guard.
2. **`is_panic()` comment vs. the design (skeptic must-fix 1):** In `rust/engine/ironhorse-vm/src/interp.rs`, the `Halt::is_panic()` doc comment now says the membership is settled per Q1. `Decode` and `StepLimit` are listed as members, and so is `HeapExhausted`, which the old "core" list left out. I removed the inline "Provisional (Open Question)" comment. No code changed.
3. **Ownership map comes too early (novice must-fix 1):** I kept the map where it is and added a short note above it. The note says to read the table as an index, and gives the section where each term is defined: `ExecutionOutcome`, the transcript and snapshot watermark, `TranscriptFault` (§ Transcript storage failures (Q6)), and retry by stable key.
4. **PR body (template pre-pass and integrator must-fixes):** I rewrote the body to use the upstream template's seven headings. I also removed the false sentence saying the PR targets `llm`; the actual base is the frozen `llm-7a4e957`. The `garden-job` marker is kept.

**Left for later:** The should-fix and comment-only items were not applied in this round. They are:
- a Q1–Q8 index or `## Resolved Questions` section;
- glosses in the Scope table for `ReentryLimit` and the other members it doesn't list;
- markdown line wrapping;
- the Mermaid edge label;
- a reverse pointer from the #989 design.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1370-gauntlet-run-20261006-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1101635 cached reads)
- Output: 7019 tokens
- Cost: $0.8163389999999999
- Wall-clock: 1988s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
