I ran panel round 1 on endojs/endo-but-for-bots PR #690 and the verdict is **must-fix**. The PR is a design doc, "docs(designs): SQLite extended surfaces for endor beyond pet-store parity", head `f6f0753dbe`.

**What I did**
- Got an isolated checkout of the head branch `endojs/design/daemon-endor-sqlite-extended-surface` at `/home/kris/garden/scratch/project-wt-endojs--45abcfb68679-1d485d5a`. The diff is two files, +432 lines: `designs/daemon-endor-sqlite-extended-surface.md` and one line in `designs/README.md`.
- For the base I passed the real merge-base SHA `f7932ed5a9`, not the bare branch name `llm`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` as a design panel. It exited 0 with `must-fix` and recorded the run as `panel-runs/endojs-endo-but-for-bots-690/d38771dabd0b.md`. It ran 10 seats: critic, skeptic, decomplector, ergonomist, novice, orthographer, pedant, copyeditor, thesaurus, and a decider.
- Posted the full aggregate to the PR as review 5328750167: https://github.com/endojs/endo-but-for-bots/pull/690#pullrequestreview-5328750167

**The review is a comment, not request-changes.** GitHub refused request-changes because the PR belongs to the bot account ("Can not request changes on your own pull request"). I posted it as a COMMENT review instead. Its header says the verdict is must-fix (request-changes) and explains why it went up as a comment. The last line of this report carries the must-fix stage result, so the gauntlet driver gets the verdict from there, not from the review state.

**Main findings (for the fix stage)**
- **Missing source document (must-fix, raised by both critic and skeptic):** the design says it "builds on" `designs/daemon-endor-pet-store-sqlite.md` (from PR #124). That file is not in the PR's base tree or on `llm`, because #124 merged onto a separate pinned branch, `llm-a54c3ad`. The fix is either to land that document first or to cite the PR #124 discussion directly.
- **Surface list doesn't match its source:** the Motivation section lists five declined surfaces, but #124 lists six. This design has "backup API" where #124 has "iterators", and it never mentions the sibling design `design/daemon-endor-sqlite-iterate-streaming`.
- **Smaller issues:** the pedant flagged em-dash style, and the orthographer found nine British spellings, eight of which should be fixed.
- **Also noted:** the ownership-map pre-pass flagged cross-boundary changes, so the panel added the decomplector seat.

**Follow-up:** gauntlet reviews on bot-authored PRs can never be request-changes, so whatever detects the panel verdict should accept a COMMENTED review with a must-fix header.

Nothing changed in the garden repo, and I did no fixing or un-drafting.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr690-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 24 tokens (784362 cached reads)
- Output: 3947 tokens
- Cost: $0.7407723999999999
- Wall-clock: 436s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×1

<!-- garden-usage-end -->
