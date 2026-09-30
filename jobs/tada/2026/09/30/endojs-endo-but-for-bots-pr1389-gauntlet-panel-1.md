Panel round 1 on endojs/endo-but-for-bots PR #1389 (a draft design PR: `designs/sturdyref-shim-contract.md`) finished with a **must-fix** verdict, and the review is posted on the PR.

**How it ran**
- I checked out the PR head `design/sturdyref-shim-contract` @ `9ed5707c96` in an isolated project worktree (`scratch/project-wt-endojs--cbec70b07906-a8f4928e`).
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's exact base commit `7ff30afbce` (`llm-7ff30af`). The diff is 2 files, +213 lines.
- `panel.sh` exited 0 (per the run record: `exit_code=0`, `disposition=must-fix`, `panel_kind=design`). All 10 seats returned `ok`, and the decider raised no errors.

**Seat verdicts**
- **request-changes (6):** critic, skeptic, ergonomist, pedant, novice, pruner.
- **comment-only (1):** decomplector.
- **approve (3):** copyeditor, orthographer, thesaurus.

**Main must-fix findings**
- **Contradiction with the open questions:** the Design/Surface section states four behaviors as settled that Open questions 1, 2, 3 and 5 list as unresolved:
  - dispatch happens in a later turn;
  - `enliven.call(handler, ref)` receives the ref as an argument;
  - the hook is read once, at construction;
  - refs inherit from `SturdyRef.prototype`.
- **Missing test:** the main reason the design gives for rejecting the promise-based approach is that a SturdyRef can be revived many times. No test in the listed test plan checks that repeated `enliven` calls re-invoke the handler.
- **Overstated claim:** the forward sketch says the handler contract is enough, but the sketch has CapTP serialize refs through its own side table (a `WeakMap` from ref to data). Either drop the claim or tie it to Open question 7.
- There are also ergonomics, pedant, novice and pruner points, including the PR description's length.

**Review posted**
- It was posted as a `COMMENTED` review at 2026-09-30T05:48:25Z. The PR belongs to the bot account, so GitHub rejected a request-changes review. The body carries the marker `<!-- garden-panel-verdict: must-fix round=1 -->` and the full aggregate.
- The gh wrapper first refused to post because the text had bare `#774` / `#695` alongside `kriscendobot/garden` links. I rewrote them as `endojs/endo-but-for-bots#774` and `endojs/endo-but-for-bots#695`, which is what they point to, and it posted.

**Where things are**
- Run directory: `scratch/panel-run-pr1389-r1/`.
- Nothing changed on the garden repo, so no commits.
- The fixes go to the gauntlet's next fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1389-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (653284 cached reads)
- Output: 4095 tokens
- Cost: $0.5930287999999999
- Wall-clock: 639s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
