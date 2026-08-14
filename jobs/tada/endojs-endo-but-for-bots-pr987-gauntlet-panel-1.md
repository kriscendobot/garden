Panel stage complete. The verdict is posted and verified on PR #987.

## Completion report

**Job:** Gauntlet PANEL stage, round 1 — endojs/endo-but-for-bots PR #987 (`design(endor): bind libgit2 with Zig cross-builds`).

**What I did:**
- Obtained an isolated project checkout of the PR head (`design/endor-git-bindings-zig`, base `llm`).
- Ran the panel once in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`). The PR is a pure **design** change (all diffs under `designs/*.md`), so the panel correctly sensed the 7-seat **design** panel: `critic skeptic decomplector ergonomist copyeditor pedant novice`. All 7 seats reported `ok`; panel.sh exited 0.
- **Disposition: `must-fix`** — 5 seats requested changes (critic, skeptic, ergonomist, copyeditor, novice), 2 comment-only (decomplector, pedant).
- Posted the aggregate verdict as a `gh pr review` on PR #987. A `--request-changes` review is rejected by GitHub because the bot authors the PR, so it was posted as a `--comment` review whose body header states the `must-fix` verdict (verified landed: author `kriscendobot`, state `COMMENTED`).
- Stopped there — no fix, no un-draft, no loop, per the single-stage contract.

**Notable operational issue (for the fleet):** this stage was reaped and requeued twice before succeeding. Root cause: in `claude -p` handler mode, ending a turn to "wait for a background notification" exits the handler and SIGKILLs any backgrounded `panel.sh` (a child of the session's process group), and my `pgrep -f 'panel.sh.*987'` monitor falsely matched my own resumed `claude -p` cmdline (the job spec text embeds `panel.sh <worktree> 987`). Fix that worked: launch the panel via `setsid` (survives session teardown), monitor the concrete top-level PID with `kill -0`, and stay in foreground blocking waits rather than yielding the turn. Possible follow-up: panel stages should either run the panel in a detached/`setsid` wrapper by default or the seat monitor should key on a rundir sentinel, not a cmdline pattern.

**Follow-ups:** none owed by this stage. The gauntlet driver reads `must-fix` and owes the next (fix) stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr987-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 78 tokens (2596528 cached reads)
- Output: 24868 tokens
- Cost: $3.1091060000000006
- Wall-clock: 1733s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
