---
role: fixer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
dispatch: automatic
---
**Role: fixer.** Resolve **stale panel coverage** on five open PRs, where the last panel reviewed an older head than the current one. Maintainer approved (liaison muster, 2026-10-07). Apply the same rules as the readiness orchestration `pr-readiness-arc-plan-20261007`. Assign each PR its arc from journal `config/arc-budgets/` and `config/foreman-mandate`, then:

- **No CHANGES_REQUESTED** (endojs/endo-but-for-bots#1403, draft): park a budgeted gauntlet plan, `post-plan.sh --deferred --arc <arc> endojs-endo-but-for-bots-pr1403-gauntlet-plan-20261007`, whose body runs `post-gauntlet.sh --arc <arc> endojs-endo-but-for-bots-pr1403-gauntlet-20261007 <url>` on promotion.
- **CHANGES_REQUESTED** (endojs/endo-but-for-bots#1348, endojs/endo-but-for-bots#695, kriscendobot/agoric-sdk#10, kriscendobot/minion.town#85): verify, request by request, whether the latest CHANGES_REQUESTED review was applied (cite commits).
  - If all are applied, send ONE maintainer review-request message per PR (`send-msg.sh maintainer`, key `review-request-<owner>-<repo>-pr<N>`) with the checklist.
  - Otherwise park a fixer plan on the PR's arc (`post-plan.sh --deferred --arc <arc> <owner>-<repo>-pr<N>-address-review-20261007`) listing what's unaddressed.
  - agoric-sdk#10 is on the kriscendobot fork. Do not touch upstream agoric/agoric-sdk.

Then archive each PR's `stale-panel-head-*.md` maintainer notice.
