Review posted as a comment (request-changes is blocked on own-authored PRs; the body's title and disposition make the must-fix verdict explicit, and my stage-result marker below is the authoritative gauntlet signal).

## Completion report

**Job:** endojs/endo-but-for-bots PR #735 — gauntlet PANEL stage, round 3.

**What I did:**
- Resolved PR #735 head (`endojs:design/chat-http-controller-ui`, base `llm`, draft) and got an isolated project worktree at head `f5bba5bb90`.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against merge-base `6beb4e5bf7`. The PR is a design-only change (`designs/chat-http-controller-ui.md` + `designs/README.md`), so the design panel fired (critic, skeptic, decomplector, copyeditor, ergonomist, novice, pedant).
- Panel disposition: **must-fix**. Multiple seats independently flagged the same load-bearing defect: the design's "static-vs-pinned" Policy-row marking is not derivable from `listBindings()` because the landed exo pins *every* allowed origin into the binding table (`http-client.js:772`, `decidedBy: 'constructor'`), so the real discriminator is `Binding.decidedBy`/`decisionMode`, which the design never names. Additional should-fix findings on mode-validation, capability-boundary contradictions, interface-tag over-claim, and phasing-value claims.

**What changed:** Posted the aggregate verdict to PR #735. `gh pr review --request-changes` is blocked by GitHub (can't request changes on an own-authored PR), so I posted it as a `--comment` review; the review title and body state "must-fix" explicitly.

**Stage boundary:** Ran exactly one panel round; did not fix, un-draft, or loop, per the single-stage contract.

**Follow-ups:** The gauntlet's next stage (fix-loop) owns addressing the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr735-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (473329 cached reads)
- Output: 3860 tokens
- Cost: $0.5776935
- Wall-clock: 363s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
