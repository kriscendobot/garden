Panel round 3 for endojs/endo-but-for-bots PR #1150 (`build/ironhorse-panic`, the formal Panic category + live FFI-abort guard) is complete.

**What I did**
- Resolved the PR head (`kriscendobot:build/ironhorse-panic`, base `llm`) and obtained an isolated project worktree keyed to this job's base.
- Passed the real merge-base SHA (`e84a4c83…`, from `gh api pulls/1150 .base.sha`) as the panel base-ref rather than the bare upstream branch name, per the base-normalization gotcha.
- The first run was killed by a session teardown mid-aggregate (2 of 29 seats left `pending`, recording a spurious `disposition=error`). On resume I confirmed the panel isn't seat-level resumable and re-ran it cleanly in single-round mode, detached via `nohup`, polling with bounded loops to keep the session alive.
- Clean re-run: **all 29 seats reported `ok`; disposition = `must-fix`.** Nine seats returned request-changes.
- Built the review body preserving every request-changes/comment-only seat in full (collapsing only approve seats to their verdict line) to fit under GitHub's 65 535-char review limit — 54 KB, all 9 request-changes verdicts and every must-fix finding verified present.

**What changed on the PR**
- Posted the aggregate as a review on PR #1150 (2026-09-04T19:47:50Z). GitHub blocks request-changes on the bot's own PR (`Can not request changes on your own pull request`), so it went as a **comment** review carrying the explicit `disposition=must-fix` header and `<!-- garden-panel: single-round round=3 disposition=must-fix -->` marker.

**Key must-fix items for the next fix stage**
- `XsnapError::Panicked` doc/`Display` text asserts "FFI-guarded" but is also constructed for the non-FFI machine-thread catch in `inproc.rs` — the message is false there.
- The panic guard removes the process-abort backstop that kept the powers modules' shared cross-vat global tables safe (torn-capability risk).
- Five `ffi_panicked()` checkpoints threaded through `run_xs_program`'s crank loop are untested — the exact bracketing contract the PR claims.
- Benchmarker: unmeasured hot-path perf claim in the PR body, now stale relative to the crate-wide (incl. `metering_callback`) guard extension — post a benchmark or an explicit "not pursuing" note.

**Follow-ups**
- Stage owner (gauntlet driver) will dispatch a fix stage on this must-fix verdict, then re-panel. No un-draft; I did not fix or loop, per single-round mandate.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-panic-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 62 tokens (1921769 cached reads)
- Output: 19653 tokens
- Cost: $2.6294285
- Wall-clock: 1590s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
