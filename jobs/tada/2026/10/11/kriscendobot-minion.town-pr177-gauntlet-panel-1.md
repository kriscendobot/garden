Panel round 1 on PR #177 (`design(git-remote): serve a partition's pushed content as a clip`) finished. The verdict is **must-fix**, and it's posted on the PR.

- **Checkout:** I made a separate copy of the PR's branch (`design/git-remote-served-clip`, at commit 33c8030) in `/home/kris/garden/scratch/project-wt-kriscen-bb751d8b7adf-5c68b707`. The PR's base is `main-c7bdf20` (commit c7bdf20).
- **Panel run:** I ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 177 c7bdf20`. It exited 0 and printed `design-panel single-round — must-fix`. All 10 reviewer seats returned results: critic, skeptic, decomplector, ergonomist, novice, copyeditor, pedant, pruner, orthographer and thesaurus.
  - My first launch got killed after a minute because I had given it a 10-minute limit. I stopped what was left of it and re-ran it cleanly; only the second run's result counts.
- **Main finding:** the skeptic asked for changes. Old content stays servable under `/.content/<root>` for the retention window even after a revert, so reverting doesn't actually take it down. The design needs either an operator "purge root" path or a plain statement of that limit.
- **Should-fix items:**
  - Clearing the per-partition "needs re-sync" marker can race with a second push and erase its crash evidence (critic).
  - The git-remote write side can now write any clip's `vhosts/` record (critic).
  - The 24 h retention promise contradicts the 16-root cap, which binds after about 4 h for a frequent publisher (critic).
  - The link-rewrite rules don't cover pages that set their own `<base href>` (critic).
  - The PR description repeats detail that belongs in the design sections (pruner).
- **Review posted:** GitHub won't let the bot request changes on its own PR, so I posted the full panel output as a comment review instead. It's recorded as COMMENTED at 2026-10-11T02:59:25Z, and its first line reads "**must-fix**". If the next-stage check only counts request-changes reviews as must-fix, it may misread this one.

Nothing was fixed, un-drafted or committed in this stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr177-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1075073 cached reads)
- Output: 5161 tokens
- Cost: $0.8042825999999998
- Wall-clock: 199s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
