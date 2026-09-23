---
title: §Three-mode-address-filtering with §CIDR-allowlist
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

| Mode | Configuration | Allowed clients |
|------|--------------|----------------|
| Localhost only (default) | `ENDO_GATEWAY` unset or `''` | `127.0.0.1`, `::1`, `::ffff:127.0.0.1` |
| Remote | `ENDO_GATEWAY=remote` | All IPs (logs TLS warning) |
| CIDR allowlist | `ENDO_GATEWAY_ALLOWED_CIDRS='10.0.0.0/8,fd00::/8'` | Localhost + listed ranges |

§Three-mode-configuration with §default-is-the-safe-mode (Localhost only). §The-Remote-mode-logs-a-TLS-warning — §the-user-is-told-the-trade-off-they're-making.

§Borrowable-pattern: §three-named-modes-with-safe-default + §unsafe-mode-logs-a-named-warning. §Sibling to cycle 218 power-levels-as-selectable-options (four-named-levels). §Different-from-cycle-218: cycle-218 grants per-application; cycle-224 governs the listener.

§IPv4-mapped-IPv6-normalization handled in `cidr.js` — §the-`::ffff:127.0.0.1`-form-must-match-the-`127.0.0.1`-rule. §Borrowable-pattern: §address-normalization-as-a-prerequisite-for-allowlist-matching.
