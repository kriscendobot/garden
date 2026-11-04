---
posted_at: 2026-11-04T00:40:36Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: https://github.com/kriscendobot/minion.town
related: https://github.com/kriscendobot/minion.town/pull/235 (audit table), https://github.com/kriscendobot/minion.town/pull/233 (invite, cancelInvite tools)
tracker: https://github.com/kriscendobot/minion.town/issues/227
task: Maintainer decision (2026-11-03/04): steer toward MCP tool minimalism. Remove every MCP tool that is redundant with `evaluate` plus the getting-started guide. For `invite` and `cancelInvite` (shipped by PR 233): remove them WHEN they become redundant, i.e. when the invite/accept workflow is driven successfully through `evaluate` end to end, including the case PR 235 found: a locator produced by `evaluate` cannot be accepted from the web page, while the `invite` tool's locator can. Close that gap first (investigate why the two locators differ and make the web accept path take the evaluate-made one), then remove the two tools.

Do:
1. Take the audit table in PR 235's description as the starting list. For each tool, decide redundant or not, with a one-line justification and a verified `evaluate` recipe for each one you remove (the guide in PR 235 already carries recipes; add any missing). Keep a tool only if evaluate genuinely cannot do its job (state why).
2. Audit every caller of the removed tools before removing them: the garden-side scripts and skills (scripts/jobs/minion-mcp-*.sh, the watchdog `status` probe, skills/minion-town-clip-publishing, context/operations/minion-town-mcp.md in the garden repo main2), the primer, tests, and the prod probe. Update or migrate each caller in the same change, or report it as a blocker. The garden repo is kriscendobot/garden, direct to main2 for library edits.
3. Make the web-accept gap fix, then prove with a production-shaped test (real daemon, Playwright for the web accept): evaluate mints an invitation, a fresh guest accepts it from the web page, mail flows both ways.
4. Remove the tools in draft PR(s) on kriscendobot/minion.town; update the MCP `instructions` string and resources so the surface the agent sees matches. Report the before/after tool list and the tools/list size in bytes.
Constraints: draft PRs, no secrets in logs, create no persistent production guests. The maintainer does not review minion.town PRs; write the PR description as a production-outcome report (what changes on production, how verified).
