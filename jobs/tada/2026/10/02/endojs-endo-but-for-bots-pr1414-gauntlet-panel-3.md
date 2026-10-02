## Round 3 panel report for endojs/endo-but-for-bots#1414

**Result: must-fix.** The panel ran without errors (exit 0), and I posted the verdict to the PR.

**What I did**
- **Checkout:** made a separate checkout of the PR branch `endojs:design/guest-delegated-host-channel-confinement` at head `c80950f0b5`. The diff against the pinned base `llm-afc72ca` is one file: the design document, +471 lines.
- **Panel run:** ran the panel in single-round mode against base `llm-afc72ca`. It ran 10 reviewers and returned **must-fix**.
- **Posted review:** posted the full aggregate as review 5390039443. It is a comment review headed "Garden panel — round 3 (single-round gauntlet): **must-fix**" against commit `c80950f0b5`, the same shape as rounds 1 and 2, because GitHub refuses request-changes on the bot's own PR.

**Votes**
- **Approve (3):** copyeditor, orthographer, thesaurus.
- **Comment-only (6):** critic, skeptic, decomplector, ergonomist, pedant, pruner.
- **Request-changes (1):** novice.

**The must-fix item (novice):** the design uses "pin" for three different things and never says they differ:
- `@pins`, a directory the guest can write to, which the design never defines;
- the floot registrar's private `pinDirectory`;
- the per-mount `pin` token.

The design's main claim, that no formula identifier reaches floot, depends on a reader not confusing `@pins` with `pinDirectory`.

**Main should-fix items for the fix-loop**
- **Incomplete survey (skeptic):** `packages/fae/setup-with-tools.js:60` and `:83` match the design's own grep but the design never mentions them. Also, the claim that no factory calls `provideHost` is contradicted by `floot-factory-setup.js:311`, which the design neither names nor excludes.
- **Misleading floot row (critic):** the survey table's floot row lists the controller's own host operations, which a reader could take as breaking under Recommendation 1. The design should also cite the search behind its "no peer/bootstrap authority" claim.
- **`host-agent` name (decomplector):** the pet name `host-agent` now points at a much weaker capability, so the rename in Open Question 4 is a safety question, not a style one. The design should also say why `memberId`/`replyTo` can never be accepted where a `FormulaIdentifier` is expected.
- **Ordering and naming (novice):** packages are named before they are explained, `llm` and `llm-provider` both appear for what seems to be the same thing, and Phasing cites Open Question 3 before the Open Questions section appears.

**Follow-ups:** none from this stage. The gauntlet driver posts the next stage, a fix round.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1414-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (397956 cached reads)
- Output: 2570 tokens
- Cost: $0.5424632
- Wall-clock: 345s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
