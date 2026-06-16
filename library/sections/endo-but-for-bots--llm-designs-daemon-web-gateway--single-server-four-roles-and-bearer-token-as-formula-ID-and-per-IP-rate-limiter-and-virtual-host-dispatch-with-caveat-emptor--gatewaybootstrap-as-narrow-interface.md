---
title: §GatewayBootstrap as §narrow-interface
source-slug: endo-but-for-bots--llm-designs-daemon-web-gateway
section-id: single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-web-gateway.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-web-gateway.md
total-lines: 185
status: Complete (2026-03-11)
ingest-cycle: 224
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-web-gateway--single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
---

```js
const GatewayBootstrapI = M.interface('GatewayBootstrap', {
  fetch: M.call(M.string()).returns(M.promise(M.remotable())),
});
```

§Single-method-interface — `fetch(agentId)` returns the agent's powers. §Borrowable-pattern: §the-entry-point-to-a-protocol-should-be-as-narrow-as-possible. §A-one-method-interface-is-easy-to-audit + §every-additional-method-widens-the-attack-surface.

§Sibling to cycle 154 @endo/captp trap.js's §narrowed-API-for-narrower-semantics + cycle 217 @endo/errors' §the-Rejector-typedef as one-line-API.
