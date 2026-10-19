---
id: endo-gateway
aliases: ["Endo Gateway", "@endo/gateway", "host gateway", "gateway bootstrap registrar", "public-key-keyed routing table"]
topics: [daemon, ocapn, networking, capability-security]
status: draft
---

# endo-gateway

The **Endo Gateway** is the host-scoped boundary between public HTTP,
WebSocket, and OCapN traffic and one or more per-user Endo daemons.
User daemons register outbound through a local bootstrap socket, prove control
of their public keys, and publish weblets; the gateway routes by public key or
gateway-assigned weblet identifier, serves immutable content from a
content-addressed cache, and relays application or Noise-encrypted frames
without acquiring the user's underlying powers.
The current `@endo/gateway` package design supersedes the earlier proposal to
express the gateway merely as a second configuration of the daemon binary.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Endo Gateway original design](../sections/endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay--the-shape.md) | Introduces host scope versus user scope, outbound registration, public-key routing, and Noise rather than TLS. |
| [`@endo/gateway` package design](../sections/endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations.md) | Supersedes the original binary-mode proposal with one composable package and a phased feature stack. |

## See also

- [[per-agent-keypair]] — registration and OCapN routing are keyed by the daemon's cryptographic identity.
- [[sturdyref]] — durable OCapN locators carry the peer identity and object secret used after routing establishes a session.
- [[relative-routing]] — connection hints describe routes to the gateway-hosted peer rather than permanent addresses.
