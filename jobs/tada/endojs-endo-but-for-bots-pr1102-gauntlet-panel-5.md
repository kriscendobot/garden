Round 5 review posted successfully. The panel decided (exit 0), disposition is must-fix, and the verdict is on the PR.

Round 5 panel stage complete for endojs/endo-but-for-bots PR #1102 (design: introduced special names).

**What I did:**
- Resolved the PR head (fork `kriscendobot/endo-but-for-bots`, branch `design/claude-agents-capability`) and got an isolated project worktree.
- Passed the true merge-base SHA (`0eb88836d6`, from `gh api pulls/1102 --jq .base.sha`) to panel.sh rather than the bare upstream branch name, per the base-normalization gotcha.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` — the design panel fanned all seats and returned **must-fix** (exit 0, decided).
- Posted the aggregate as a COMMENTED `gh pr review` on #1102, matching prior rounds' shape (the bot authors the PR, so GitHub rejects request-changes on it; the must-fix disposition is stated in the review header the next-stage heuristic reads).

**Verdict:** must-fix. Substantive request-changes from critic (existing-agent exact-equality forecloses monotonic growth; miscited indelibility write-path lines), skeptic (forward-compat invariant enforced only for the embedder-supplied `specials` half, not daemon-owned hardcoded names), decomplector (label derivation duplicated across two tables — pin a shared helper); copyeditor on six prose issues; novice on a reversed roadmap edge (`eclaude --> isn` should be `isn --> eclaude`); ergonomist/pedant comment-or-approve.

No fix, no un-draft, no loop — this stage stops here.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (666355 cached reads)
- Output: 4384 tokens
- Cost: $0.8978164999999998
- Wall-clock: 344s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
