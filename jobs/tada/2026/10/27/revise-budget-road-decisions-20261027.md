**Completion report: `revise-budget-road-decisions-20261027`**

I recorded the maintainer's three decisions in `designs/budget-road.md`, marked it Accepted, pushed it to `main2` as commit aa5d10dc5f6, and closed review PR #127 with a comment. This was design work only; nothing was implemented.

**What changed in the design doc:**
1. **No library lane.** The road now has two lanes: primary 0.6 and secondary 0.4, applied to the arcs' share of 0.40 (0.24 and 0.16 of the whole subscription at the start of the week). The doc says the split is the designer's default, not the maintainer's, and can be changed with `set-road.sh lanes <primary> <secondary>`. It also notes that a library lane can be added once curation is ongoing. The library lane is gone from the lane table, the laning rules, the `road.json` example, the `lanes` command syntax and the title.
2. **0.90 is a fixed ceiling.** It is now a constant (c = 0.90) inside `budget_road`, not a field in `road.json`, so no edit to the road can raise it. The fleet admits work only while usage is below 0.90 minus the maintainer's reserve, and discretion is 0.90 − usage − all reservations, so it tops out at 0.90 at the reset.
   - With no maintainer spend, the fleet's limit now runs from 0.40 to 0.90 over the week, instead of the old ramp's 0.50 to 1.00. The doc says plainly that the 2026-10-02 directive replaces the old "reaches 100% at reset" wording.
   - Choices I made beyond the decision:
     - A manual pin can lower the limit but never raise it.
     - Codex's flat 95 limit is capped at 90.
     - The maintainer's own sessions are never blocked by the ceiling.
     - A new `ceiling` reason code marks a hold caused by the ceiling.
     - Tests for the ceiling are added to the migration plan.
     - The ceiling is added to the ownership map.
3. **Focus on minion.town.** The migration step and the `road.json` example now pin, in order, `minion-town-claude-api`, `minion-town-mcp-ocapn`, `minion-town-git-remote` and `minion-town-ui`. Any of the four that isn't already an arc gets added; the rest rank by recent activity.
4. **Status and sections.** The status is Accepted and cites #127. The Open questions section is replaced by a short "Decisions" section that records the three answers.

**Other files updated:** the `budget-road.md` row in `designs/README.md` now says Accepted, two lanes, the 0.90 ceiling and the minion.town pins. The "Superseded by" rows in `accountant-arc-apportionment.md` and `foreman-discretion-budget-pool.md` now say Accepted and two lanes.

**PR #127:** I commented with the three decisions and closed it as resolved (comment: https://github.com/kriscendobot/garden/pull/127#issuecomment-6433793221). Its head branch `design/budget-road` is still there and can be deleted whenever.

**Follow-ups:**
- `build-budget-road` can now be posted (Migration step 1).
- The `budget-level.sh` change that reads 0.90 minus the maintainer's reserve as its ceiling stays a follow-up for after the build.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/revise-budget-road-decisions-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (510886 cached reads)
- Output: 9994 tokens
- Cost: $0.8728652
- Wall-clock: 95s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
