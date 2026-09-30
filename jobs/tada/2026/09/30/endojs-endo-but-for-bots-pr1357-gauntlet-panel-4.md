PR #1357 panel round 4 came back **must-fix**. `panel.sh` exited 0, and I posted the verdict to the PR.

**What I did**
- **Checkout:** made an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `design/endo-claude-inference-backends`, head `d53fa42dff`).
- **Base:** used the PR's `baseRefOid` (`47f6965d88`, `llm-47f6965`) as the base. The files it diffs against match GitHub's file list for the PR: `designs/README.md` and `designs/endo-claude-inference-backends.md`.
- **Panel run:** ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh`. It picked the design panel and ran 10 seats, all of which finished without error.
- **Seat verdicts:**
  - Request changes: critic, skeptic, decomplector, pedant, copyeditor.
  - Comment only: ergonomist, novice, orthographer, pruner.
  - Approve: thesaurus.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1357#pullrequestreview-5361670721, on head `d53fa42dff`. It has a round-4 summary header, then the full panel output.
- It posted as COMMENTED, not request-changes. GitHub doesn't let the bot request changes on its own PR, so the `**must-fix**` in the header is what marks the verdict.
- The first post attempt was blocked because the text had a bare `#87` that would link to the wrong repo. I put it in backticks and reposted.

**Main blockers raised**
- **Unchecked prompt label (critic and skeptic):** Decision 9 lets a request skip OS containment based on `promptOrigin`, a label the caller sets for itself. No gate checks that the factory sets it correctly, so the reviewers want an end-to-end gate, or at least a Known Gap entry.
- **Deploying before the gates (skeptic):** Phase 3 deploys on the subscription credential before Phase 4 runs gates 1–4, even though the design says those gates must pass before production use.
- **Split ownership (decomplector):** two components classify results (the credential source and the plugin). The prompt-origin refusal is reported as `unavailable` with a reason string that callers would have to parse. Decision 8's usage record lists fields the recorder can't see.
- **Prose (copyeditor and pedant):** a grammar ambiguity at line 206, missing serial commas in several lists, and some smaller clarity edits.

**Follow-ups:** none from this stage. The driver decides whether to run the next fix round.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (798860 cached reads)
- Output: 4902 tokens
- Cost: $0.743268
- Wall-clock: 687s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
