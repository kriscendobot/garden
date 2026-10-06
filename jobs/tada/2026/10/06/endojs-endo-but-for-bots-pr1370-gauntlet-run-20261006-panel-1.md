I ran panel round 1 on endojs/endo-but-for-bots PR #1370 ("docs(ironhorse): settle panic recovery design questions"). The verdict is **must-fix**. It is posted on the PR as a COMMENTED review, not a request-changes review, because GitHub refuses request-changes on the bot's own PR.

- **Run:** I used an isolated checkout of the head `endojs/design/ironhorse-panic-answers` at `9b81fb7c53`, against the PR's base `llm-7a4e957` at `7a4e957410`. I ran `panel.sh` under `setsid`, which forked into the background, so its real exit code was not captured. I polled until it finished. The last line was `design-panel single-round — must-fix`, and all 11 seats reported `ok`, so I'm treating it as an exit-0 verdict, not a panel error.
- **Checks before the seats:**
  - The PR-body template check came back NONCONFORMING, which forces must-fix by itself.
  - The ownership-map check flagged ATTENTION.
  - The PR-body concision probe fired.
- **Seats:** copyeditor, critic, decomplector, ergonomist, integrator, novice, orthographer, pedant, pruner, skeptic, thesaurus.
- **Main finding (critic):** the PR renames the design heading "The already-live FFI abort hazard". Five source comments in `rust/endo/xsnap/src/worker_io.rs`, `powers/debug.rs`, `lib.rs` and `rust/endo/src/inproc.rs` still quote the old heading. One of them backs the `compile_error!` guard against `panic = "abort"`.
- **Should-fix:** the doc comment on `is_panic()` in `rust/engine/ironhorse-vm/src/interp.rs` contradicts the design's new "membership is settled" answer.
- **Review posted:** the 11 seat verdicts plus a header carrying `<!-- garden-panel-verdict: must-fix -->`, at 2026-10-06T15:23:31Z.
- **Changes:** none to the garden repo or the PR branch. I did not fix anything or un-draft the PR.

**Follow-up:** check that the gauntlet driver reads a COMMENTED review with the must-fix marker as a must-fix verdict.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1370-gauntlet-run-20261006-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (545868 cached reads)
- Output: 3141 tokens
- Cost: $0.5601376
- Wall-clock: 1095s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
