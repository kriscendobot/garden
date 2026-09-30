Panel round 1 on endojs/endo-but-for-bots PR #1360 ("capability URL locators" design) came back **must-fix**.

**What I did**
- Checked out the PR head (`endojs:design/capability-url-locators`) in an isolated project worktree. The PR's base is the frozen branch `llm-47f6965`, so I gave `panel.sh` the real base SHA `47f6965d88…` instead of the branch name.
- Ran `panel.sh` in single-round mode. It exited 0 with disposition **must-fix**.
  - The PR-body template check found the body doesn't follow the required template, and that alone makes the disposition must-fix.
  - The ownership-map check also flagged the PR for attention.
- Of the ten reviewers:
  - Seven asked for changes: critic, skeptic, ergonomist, copyeditor, novice, orthographer and integrator.
  - Pedant and decomplector left comments only.
  - Thesaurus approved.
- The main findings:
  - The design states the rule separating "not a capability URL" (silently ignored) from "invalid capability URL" (rejected) twice, in ways that can be read as contradicting each other. It gives no worked edge cases.
  - It doesn't say what the parser does with minion.town's live invitation links (`#v=1&invitation=…`). A sibling branch already rejects them, which contradicts the design's claim that those links stay valid.
  - Open question #6 asks whether to keep `view`, but the body already treats it as decided, and the sibling branch has shipped it.

**Deviation:** GitHub rejected the request-changes review because the PR is the bot's own. I posted the full panel output as a **COMMENTED** review instead (kriscendobot, 2026-09-30T11:07:26Z), with a must-fix header at the top. If the next stage only counts a request-changes review as a must-fix verdict, it could miss this one. The marker line below still carries the verdict.

**Follow-ups:** the fixer stage for the must-fix findings. No garden files changed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1360-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (560311 cached reads)
- Output: 2518 tokens
- Cost: $0.5426062
- Wall-clock: 252s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
