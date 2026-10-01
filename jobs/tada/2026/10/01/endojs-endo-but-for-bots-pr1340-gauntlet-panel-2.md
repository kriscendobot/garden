Panel round 2 on endojs/endo-but-for-bots#1340 returned **must-fix**. `panel.sh` exited 0 and its last line was `design-panel single-round — must-fix`.

- **Checkout:** I used an isolated checkout of `endojs/endo-but-for-bots@design/agent-confined-application-makers` at head `07768c3d44`. The base was `llm-6726b0f`, passed as the full SHA `6726b0fba2d3…`.
- **Panel:** All 10 seats returned.
  - Request-changes: critic, pedant, integrator.
  - Comment-only: skeptic, decomplector, ergonomist, copyeditor, novice.
  - Approve: orthographer, thesaurus.
- **What drives must-fix:**
  1. **PR body doesn't follow the template.** The check against the base branch's PR template, which forces must-fix on its own, failed again. Seven template headings are missing and an invented `## Summary` heading stands in their place. The round-1 fix commit changed only the design file, not the PR description.
  2. **PR body is stale (integrator).** It still says there are "four open questions" and "no new formula type". The head has since resolved those questions into Decisions 4–7, and `makeFromBundle` now creates a new `make-archive` formula record.
  3. **pnpm claim looks wrong (critic).** Decision 4 says `node-linker=hoisted` turns workspace siblings into real directories. pnpm still symlinks workspace packages under that setting; "injected dependencies" may be the mechanism the design actually needs.
  4. **Style (pedant).** Level-3 heading capitalization is inconsistent, and items 4–5 of the phased-implementation list are bare phrases unlike items 1–3.
- **Smaller points (comment-only):**
  - Skeptic: compartment-mapper's default conditions also include `endo`, which the design leaves out. The Yarn test case should name which `nodeLinker` mode it uses.
  - Decomplector: say whether the detected layout is re-detected on each restart or fixed when the formula is created.
  - Ergonomist: `makeArchive` is named differently from its new siblings `makeFromTree` and `makeFromBundle`.
- **Resolved:** The integrator confirmed every round-1 design-content finding is fixed.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1340#pullrequestreview-5384293000. GitHub won't let the bot request changes on its own PR, so it went up as a comment review that states the verdict as must-fix, the same way round 1 was posted.

**Follow-ups:** the fix stage needs to rewrite the PR description to match the template and the landed decisions, as well as fix the design file. I did no fixing and left the PR as a draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (842636 cached reads)
- Output: 3940 tokens
- Cost: $0.7059192
- Wall-clock: 432s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
