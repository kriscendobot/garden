---
role: gardener
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-24T20:56:07Z cleared=none -->

---
role: gardener
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Launch the gauntlet on endojs/endo-but-for-bots PR #1336 (after the in-flight fixer)

Maintainer directive: https://github.com/endojs/endo-but-for-bots/pull/1336#issuecomment-5822010973 ("Please run a gauntlet", kriskowal, 2026-09-24).

This plan entry is blocked on the fixer job `endojs-endo-but-for-bots-pr1336-fix-review-5307103246`, which was pushing to the PR head (`build/endo-guest-stdio-mcp`) when the directive arrived. Running the gauntlet only after that job finishes means the panel reviews the fixed head, not a head that is still moving.

Do this, from the garden root:

  scripts/jobs/post-gauntlet.sh endojs-endo-but-for-bots-pr1336-gauntlet https://github.com/endojs/endo-but-for-bots/pull/1336

The command is idempotent on the base. Afterward, post one short PR comment on #1336 that says the gauntlet is staged and names the record base. If the fixer job was doomed and did NOT complete (it has no `jobs/tada/` entry), still post the gauntlet. The viability stage will surface any problem with the head. Say in the PR comment that the fixer did not finish.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T20:56:18Z
