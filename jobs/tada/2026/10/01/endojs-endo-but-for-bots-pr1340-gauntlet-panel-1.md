## Panel round 1 for endojs/endo-but-for-bots#1340 (design: agent makers for confined applications): **must-fix**

The panel ran once and finished cleanly (exit 0). All 10 seats returned. I posted the full results to the PR as a review, but only as a comment: GitHub refuses a "request changes" review when the bot reviews its own PR. The review says at the top that the verdict is must-fix.

- **Setup:** reviewed head `f871ea6737` against base `llm-6726b0f` (`6726b0fba2`). I passed the exact base commit to `panel.sh` rather than the branch name.
- **Seats:** five asked for changes (critic, skeptic, ergonomist, pedant, integrator), two only commented (decomplector, novice) and three approved (copyeditor, orthographer, thesaurus).
- **PR description:** must-fix regardless of the seats. It is missing all seven headings from the repo's PR template (Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade considerations) and adds a "Summary" heading the template doesn't have.
- **Main must-fix findings from the critic:**
  - The design makes the tree `ReadPowers` field `canonical` do nothing. But the compartment mapper relies on its real-path lookup to recognise one package reached through two `node_modules` paths. Without it, such a package would quietly get two copies.
  - Design Decision 4 says pnpm's links point outside the mounted directory. That isn't true of pnpm's default layout, which keeps them inside the project.
- **Review:** posted 2026-10-01T02:13:40Z by kriscendobot. The panel run was also recorded in the journal at `panel-runs/endojs-endo-but-for-bots-1340/38448ee81be4.md`.

I made no fixes, left the PR in draft and pushed nothing to garden `main2`. The next gauntlet stage (fix-1) should apply the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (763865 cached reads)
- Output: 3799 tokens
- Cost: $0.651209
- Wall-clock: 250s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
