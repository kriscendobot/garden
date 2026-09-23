---
section: three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline
source: endo-but-for-bots--llm-designs-app-sharing-milestone
topics: [daemon, agent-conventions, chat-ui]
status: current
title: The §Pillar-2-daemon-ready-shell-missing decomposition
parent: endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline
---

Pillar 2 is the §peer-deep-link mechanism. The §three-Complete
+ §one-Missing structure:

- **Complete**: Locator format + `host.invite(name)` +
  `host.accept(locator, petName)` (`packages/daemon/src/
  locator.js` + `host.js`) — accept parses, registers via
  `addPeerInfo`, binds a pet name.
- **Complete**: OCapN-Noise transport (PR #137).
- **Complete**: Familiar registers privileged custom scheme
  `localhttp://` — *a working template* for the planned
  `endo://`.
- **Missing**: `endo://` deep-link capture in the shell, a
  confirmation screen, and a naming prompt → owned by
  `familiar-deep-link-invitations.md`.

The §template-for-the-missing-piece observation:
`localhttp://` registration *already works* in Familiar; the
new scheme is the *same pattern applied to `endo://`*. The
§similar-shape-as-precedent discipline reduces design risk.
