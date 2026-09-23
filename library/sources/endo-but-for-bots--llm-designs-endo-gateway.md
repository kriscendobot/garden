---
title: "endo-but-for-bots — designs/endo-gateway.md — host-scope Gateway + per-user Daemons as two modes of one binary"
source-slug: endo-but-for-bots--llm-designs-endo-gateway
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-gateway.md
authors: [Kris Kowal (prompted)]
status: Proposed
created: 2026-05-10
updated: 2026-05-10
repo: endojs/endo-but-for-bots
path: designs/endo-gateway.md
total-lines: 997
ingest-cycle: 283
ingest-date: 2026-06-10
lane: designs
---

# `endo-but-for-bots/designs/endo-gateway.md`

A 997-line Proposed design (Source: extracted from issue #173, itself extracted from PR #134 review at 2026-05-10T06:14:41Z). Splits the existing per-user Endo Daemon into a **host-scope Gateway + N per-user Daemons**, both as **two modes of the same generic binary**, with a public-key-keyed registration table, frame-level HTTP/WebSocket relay, and an OCapN endpoint where session confidentiality comes from the Noise netlayer rather than TLS.

## Key moves

- **§the-same-binary-two-configurations** — one binary, `--mode=gateway` vs `--mode=user` (default `user` for backward compatibility).
- **§the-host-scope-vs-user-scope split** — three named policy-domain criteria for why the per-user daemon is the wrong place for multi-user virtual-host service: OS-user-privilege boundary + per-host-singleton-vs-per-user-multiplicity + host-administrator-policy-vs-user-policy.
- **§outbound-registration-from-many-to-one** — User Daemons converge on a well-known local rendezvous (`/run/endo-gateway/registrar.sock` Linux; named pipe Windows); Gateway never discovers.
- **§public-key-keyed-routing-table** — Ed25519 public key (the same identifier OCapN uses as node-id) is the join key across local IPC registration and the remote OCapN endpoint; one lookup, two paths.
- **§the-local-IPC-socket-IS-the-local-attestation** — the channel-IS-the-property shape; two named rejected alternatives (loopback TCP + kernel credential check; cryptographic attestation backed by host-only secret) cited with rejection rationale.
- **§the-proof-of-possession-step-IS-distinct-from-local-attestation** — one-handshake-two-distinct-concerns pattern; channel-attests-local + signature-attests-key-ownership.
- **§the-domain-separation-prefix-on-the-nonce** — literal `endo-gateway:registrar:nonce` prevents signature cross-replay between protocol steps.
- **§the-Noise-not-TLS-decision** — three named consequences: no-certificate-management + authentication-by-Ed25519-public-key-not-hostname + browsers-out-of-scope-for-OCapN-endpoint.
- **§the-ciphertext-passing-relay** — the-relay-IS-incapable-of-reading shape; Noise terminates at endpoints, not at Gateway.
- **§the-frame-level-relay-without-CapTP-inspection** — named-protocol-layer-ownership-split (HTTP/WS-IS-Gateway + CapTP-IS-User-Daemon + Noise-IS-User-Daemon).
- **§the-content-addressed-cache-served-direct-from-the-relay** — Gateway serves CAS for static assets without User Daemon RTT; User Daemon only invoked for dynamic-path fallback (three-tier cache-then-relay-then-CapTP shape).
- **§the-rebuild-from-registrations-on-restart** — the-state-IS-rebuildable-from-clients; Gateway state is not its source of truth.
- **§the-404-not-503-for-absent-daemon** — error-code-choice-IS-a-privacy-decision (cacheable + no signal about which users exist).
- **§the-fall-back-when-no-Gateway-detected** — Familiar binds its own per-user port if no Gateway is reachable; discovery-IS-the-feature-toggle.
- **§the-`Resolved by review`-section** — design carries inline acceptance-tracking; pairs with `## Open Questions` as a two-named-design-tracking-sections-as-decision-pair.
- **§one-process-many-keys registration multiplicity** — `addPublicKey` allows one Daemon to host more than one agent.
- **§the-`Pass-Invariant-Eq`-named-open-question** — capability-system property cited by name as a constraint that the deferred rotation story must preserve.
- **§the-deferred-virtual-users-variant** — second mode-pair (Gateway-with-virtual-users) deferred but explicitly preserved in the interface shape.
- **§the-reverse-proxy-as-optional-operator-add** — TLS termination delegated to named external software (Caddy + nginx + Traefik), not a built-in knob.
- **§five-distinct-platform-service-manager-targets** — systemd + launchd + Windows Service + container-runtime + AppImage; the-platform-singleton-by-supervisor (singleton-IS-the-thing-that-started-the-process).
- **§the-Affected-Designs-table** — 15-row dependency-and-affecting-relationship table; third named blast-radius shape (extends 275 `Affected packages` and 281 `What changes in the existing library`).
- **§the-Source-field-with-provenance-chain** — design ← issue ← PR-review-comment(timestamp); three-link provenance chain in design metadata.

## Section files

- [§the-same-binary-two-configurations + §the-host-scope-vs-user-scope-split + §outbound-registration-from-many-to-one + §public-key-keyed-routing-table + §the-Noise-not-TLS-decision + §the-content-addressed-cache-served-direct-from-the-relay + 18 more first-explicit-observations](../sections/endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay.md) — full 997-line design in scope.

## Ingest scope

Cycle 283 (designs-lane after cycle 282 chat-lane @endo/zip/src/types.js). Full 997-line design in scope. **First-explicit-observations (twenty-four)**: same-binary-two-configurations + host-scope-vs-user-scope-split-with-three-named-policy-domains + outbound-registration-from-many-to-one + the-rendezvous-shape-named + public-key-keyed-routing-table + the-single-lookup-serves-both-paths + the-local-IPC-socket-IS-the-local-attestation + three-named-rejected-alternatives-with-reasons + the-proof-of-possession-step-IS-distinct-from-local-attestation + one-handshake-two-distinct-concerns + the-domain-separation-prefix-on-the-nonce + the-Noise-not-TLS-decision-with-three-named-consequences + the-ciphertext-passing-relay + the-frame-level-relay-without-CapTP-inspection + the-content-addressed-cache-served-direct-from-the-relay + the-publish-then-no-round-trip + the-three-tier-cache-then-relay-then-CapTP-shape + the-rebuild-from-registrations-on-restart + the-404-not-503-for-absent-daemon + the-fall-back-when-no-Gateway-detected + the-`Resolved by review`-section + two-named-design-tracking-sections-as-decision-pair + one-process-many-keys + the-`Pass-Invariant-Eq`-named-open-question + the-deferred-virtual-users-variant + the-reverse-proxy-as-optional-operator-add + five-distinct-platform-service-manager-targets + the-platform-singleton-by-supervisor + the-Affected-Designs-table + the-Source-field-with-provenance-chain.
