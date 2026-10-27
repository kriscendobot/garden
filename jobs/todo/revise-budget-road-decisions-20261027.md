---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-27T04:29:01Z cleared=none -->

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Revise designs/budget-road.md with the maintainer's decisions, then close out review PR #127

The maintainer (kriskowal, liaison session 2026-10-27) answered the design's three open questions. Record them in `designs/budget-road.md` and clear the open-questions section:

1. **No dedicated library lane.** There is no ongoing curation yet. Drop the library lane and the `garden-library` arc recommendation; the road has two lanes. Re-split the arc share between them (default 0.6 primary / 0.4 secondary, keeping `lanes` configurable via `set-road.sh lanes`; say plainly that the exact split is the designer's choice, not the maintainer's, and easy to change). Leave a note that a library lane can be added when curation is ongoing.
2. **90% is the ceiling.** The fleet never plans past 0.90 of any subscription. Make 0.90 the fixed ceiling in the formulas (`u < 0.90 − R_k` shape, or equivalent), not an optional field. Reconcile with the "reaches 100% at reset" wording so the doc is consistent, and keep the 2026-10-02 directive cited.
3. **Focus on minion.town.** `set-road.sh init` pins, in order: `minion-town-claude-api`, `minion-town-mcp-ocapn`, `minion-town-git-remote`, `minion-town-ui`. The rest rank by recent activity.

Then set the doc's status to Accepted, remove the empty Open questions section, update the index rows, push to main2. Comment on https://github.com/kriscendobot/garden/pull/127 recording the three decisions and close it as resolved (the content is on main2 already). Design only: do not implement.

