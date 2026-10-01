---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Remove guests' ability to produce or consume formula identifiers and locators

Repo: endojs/endo-but-for-bots, base branch `llm` (pin a frozen `llm-<sha>` base per frozen-base-branch). Open a DRAFT PR via ensure-pr.sh.

Directive (maintainer kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1371#issuecomment-5925033783): remove the ability of a **guest** to produce or consume identifiers or locators, consistent with distributed confinement. The maintainer anticipates this may break some usage patterns, to be recovered with sturdy refs or by other means.

Motivating finding (#1371 live turns, 2026-09-30): a confined guest calling `storeIdentifier` with a host formula id copied from its prompt succeeds and the guest then holds `?type=host`, so an identifier carried as data escalates into authority. A guest that can mint identifiers/locators (`identify`, `locate`, `reverseLocate`, …) can also leak designations out of confinement.

Scope:
- Audit the guest powers surface in `packages/daemon` (the guest interface/guard and its maker; compare with the host surface) for every method that RETURNS a formula identifier or locator, or ACCEPTS one (for example `identify`, `locate`, `reverseLocate`, `followLocatorNameChanges`, `storeIdentifier`, `adoptFromLocator`, and any locator-accepting `lookup`/`provide` paths). Remove them from the guest (host keeps them). Update the guest interface guards, TypeScript types, the CLI/MCP surfaces that expose guest tools (`@endo/agent-mcp-stdio`, `@endo/mcp`, and the `@endo/claude` catalog), and docs/designs that describe the guest API.
- Tests: assert the guest no longer exposes these methods, and that the #1371 escalation (guest storing a prompt-borne host id) is impossible.
- Breakage ledger: enumerate in the PR body every in-repo caller/test/design that relied on guest identifiers or locators, and for each say how it is recovered (sturdy refs — see the in-flight `ebfb-sturdyref-layer*` stack — pet-name paths per #1390, or host-mediated) or left as a named follow-up. Do NOT silently keep a guest escape hatch. Note the in-flight Minion Town guest-locator federation campaign (orchestration `endo-minion-town-guest-locator-federation`, design PR #1332) as a known affected consumer; flag the conflict in the PR body rather than resolving it unilaterally.
- Changeset per affected published package.
