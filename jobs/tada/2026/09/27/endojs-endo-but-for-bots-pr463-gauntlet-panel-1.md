The panel for endojs/endo-but-for-bots#463 (a design doc: AWS Marketplace publishing path for the gateway) came back **must-fix**, and I posted the verdict on the PR.

- **Checkout:** I made an isolated worktree of the PR head (`endojs:design/gateway-aws-marketplace-publishing-path` @ `3741a137`) with `ensure-project-worktree.sh`. For the base I passed the real merge-base `5be43923` instead of the bare `llm` branch name.
- **Panel:** I ran `panel.sh` in single-round mode. It exited 0 with `design-panel single-round — must-fix`. All 9 seats returned results: critic, skeptic, novice, pedant, ergonomist, decomplector, copyeditor, orthographer and thesaurus. The ownership-map pre-pass flagged a cross-boundary issue, so it forced the decomplector review on.
- **Main must-fix findings:**
  - The buyer onboarding flow never gives the buyer the node URL or node id.
  - The first-boot setup has no failure or recovery path, and the hardened image has no SSH access to fall back on.
  - The document's central term, "Capability Bridge", is never defined or linked.
  - The rejected alternatives for per-node certificates leave out the obvious middle option, a wildcard certificate.
  - The claim that GitHub lacks narrow per-repository permissions ignores GitHub Apps.
  - The new design is missing from `designs/README.md`.
  - The "max length 12" claim in the Locked sections is wrong: `bytes_network` is 13 characters.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/463#pullrequestreview-5328411838. It is a **comment** review, not request-changes, because GitHub refuses a request-changes review on the bot's own PR. The body states the must-fix verdict up front and carries the markers `<!-- garden-panel-verdict: must-fix round=1 -->` and the job marker. The full panel output is included in the review.

Nothing was fixed, un-drafted or committed, and I deleted the scratch panel run directory afterwards.

**Follow-up:** check that the next-stage heuristic treats a comment review with a must-fix body as the must-fix verdict. This case (the bot's own PR) can never produce a request-changes review.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr463-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s)
- Input: 22 tokens (723305 cached reads)
- Output: 3730 tokens
- Cost: $0.7377490000000002
- Wall-clock: 345s
- Model(s): claude-opus-4-8 ×6, claude-opus-5-5 ×1

<!-- garden-usage-end -->
