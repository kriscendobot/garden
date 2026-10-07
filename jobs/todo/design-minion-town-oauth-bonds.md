---
role: designer
tier: mentor
arc: minion-town-ui
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-07T20:54:48Z cleared=none -->

---
role: designer
arc: minion-town-ui
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: clarify, list, and delete OAuth bonds on minion.town

Repo: https://github.com/kriscendobot/minion.town. Budget: the `minion-town-ui` arc.

## Problem (maintainer, 2026-10-07)

At the bottom of the minion.town guest page there is a link for connecting the guest with
OAuth, for recovery. But OAuth also serves for authenticating MCP. The page does not make
clear what a bond is for, shows no existing bonds, and gives no way to remove one. Design:

1. **Clarify the uses.** One short, honest explanation, per bond, of what each OAuth use
   does: recovery (regain the guest from a pasted URL or a fresh login) versus MCP
   authentication (an agent signing in as this guest). State which providers can serve
   which use. Ground it in what is actually implemented, not what is planned: read the
   guest recovery and bonding code and the open/merged PRs #129, #131, #133, #114 and the
   design for Ethereum identity (recovery only), and the MCP admission docs (#121).
2. **List existing bonds.** For the signed-in guest, every bond: provider, use(s), a
   non-secret display identifier (never a token), when it was created, and last use if
   known.
3. **Delete each bond.** A per-bond removal, with a confirmation that names the
   consequence (for example, "removing the only recovery bond means a lost guest URL cannot
   be recovered"). Decide and state: may the last recovery bond be removed; may the bond
   being used for the current session be removed; what happens to live MCP sessions
   authenticated through a removed bond.

## Constraints to settle in the design

- Authority: who may list and delete a bond is a capability question, not an OAuth-scope
  one (see the access-control-as-ocap direction); state which capability the page holds and
  how a delete is attenuated to one bond.
- Security: deleting must not be coercible by a cross-origin page; list/delete must not
  leak provider tokens or other guests' bonds.
- Include a UX sketch of the guest page section (mermaid for flows, no ASCII art) and the
  acceptance tests an automatic production check can run.
- Include an `## Ownership map` (gateway, daemon, auth provider records, browser).

Open the design as a PR on `kriscendobot/minion.town` (draft). Per the maintainer's
2026-10-07 standing order (journal entry
`entries/2026/10/07/203746Z-message-gardener-a253b1.md`), the arc supervisors carry minion.town
PRs through review; do not wait on the maintainer for design sign-off. Any genuine design
fork goes in the design's `## Open questions`, not a blocked job.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-07T22:33:19Z -->
