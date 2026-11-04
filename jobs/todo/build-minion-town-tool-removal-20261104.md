---
posted_at: 2026-11-04T01:53:46Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: https://github.com/kriscendobot/minion.town
predecessor: build-minion-town-tool-minimalism-20261104 (closed the web-accept gap in draft https://github.com/kriscendobot/minion.town/pull/239)
related: https://github.com/kriscendobot/minion.town/pull/235 (audit table, guide, recipes), https://github.com/kriscendobot/minion.town/pull/233 (invite, cancelInvite)
tracker: https://github.com/kriscendobot/minion.town/issues/227
task: Maintainer decision (2026-11-03/04): MCP tool minimalism. Remove every MCP tool redundant with `evaluate` plus the getting-started guide. This job carries the remainder of build-minion-town-tool-minimalism-20261104.

State at hand-off:
- Web-accept gap FIXED in draft #239 (accept route takes `{ locator, petName }`; page reads `#v=1&locator=<endo://…>`; real-daemon test proves evaluate mint -> web accept -> mail both ways -> replay 404). #239 must be green and merged (deploys) before invite/cancelInvite go.
- The guide/recipes that replace the tools live in draft #235, not yet on main (stop gate: cold-agent baseline). Removals must land with or after the guide, or the agent loses the tools with no instructions.

Decision table (verify each recipe through evaluate before removing):
- REMOVE (proven in #235 recipes): status (E(agent).list()), list, writeText (E(agent).writeText(name, text)), readText (E(E(agent).lookup(name)).text() / maybeReadText), listMessages, send, dismiss, adopt.
- REMOVE (verify first): has (E(agent).has(name)), remove (check the tool's indelible @main guard is enforced by the daemon through evaluate), resolve, submit (guest has submit).
- REMOVE after #239 is deployed and proven on prod: invite (E(E(agent).invite(n)).locate(), link https://minion.town/#v=1&locator=<encoded>), cancelInvite (E(E(agent).lookup(n)).cancel() or E(agent).remove(n)).
- KEEP: evaluate; publish, listSites, unpublish, upgrade (they act on the app's clip store/billing, not a guest method); claudeStatus, createClaudeAgent, dismissClaudeAgent, infer (root-only; pinned Endo cannot introduce the factory to a guest).

Do:
1. Playwright proof against a real daemon (production-shaped): evaluate mints, a fresh browser guest opens #v=1&locator=… and clicks accept on the card, mail flows both ways. Then a production run after #239 deploys (throwaway invitation, no persistent prod guest; delete any browser guest created).
2. Garden callers on kriscendobot/garden main2 (direct push): skills/minion-town-clip-publishing/SKILL.md (uses writeText, readText, has, status, list), context/operations/minion-town-mcp.md (status, writeText, remove, send, invite), scripts/jobs/minion-mcp-watchdog.sh (uses only tools/list count; adjust any expected-count/threshold), scripts/jobs/minion-mcp-lib.sh. Migrate to evaluate recipes in the same change window.
3. minion.town callers: primer/, resources/, tools/guide-recipes/recipes.ts (uses writeText/remove/send tools directly), src/endo/mcp-tool-names.ts manifest, tests (test/endo-guest-tools.test.ts, guest-web-daemon invite-tool test), prod probe, MCP `instructions` string.
4. Remove the tools in draft PR(s); report before/after tools/list and its size in bytes. PR description = production-outcome report.
Constraints: draft PRs, no secrets in logs (a locator is a bearer), no persistent production guests.
