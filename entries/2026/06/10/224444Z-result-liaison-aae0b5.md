---
ts: 2026-06-10T22:44:44Z
kind: result
role: liaison
dispatch: aae0b5
host: endolin
model: opus-4-7-1m
---

# librarian cycle 283 — designs-lane — `endo-but-for-bots/designs/endo-gateway.md`

Cycle 283 (designs-lane after cycle 282's chat-lane @endo/zip/src/types.js). One source ingested: `endo-but-for-bots/designs/endo-gateway.md` (997 lines; Status Proposed; Created 2026-05-10; Updated 2026-05-10; Author Kris Kowal (prompted); Source: extracted from issue #173, itself extracted from PR #134 review at 2026-05-10T06:14:41Z). Splits the existing per-user Endo Daemon into a **host-scope Gateway + N per-user Daemons**, both as **two modes of the same binary**.

## Library state

- 789 sections (up from 788 at cycle 282).
- 330 source documents (up from 329).
- §one-hundred-and-sixteenth consecutive designs-chat alternation cycles 166-250 + 252-283 (251 was out-of-band).
- Papers-lane unblocked at cycle 251 but not yet re-blocked.

## Files written

- `library/sections/endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay.md` (new section file; 997-line design in full scope).
- `library/sources/endo-but-for-bots--llm-designs-endo-gateway.md` (new source page).
- `library/sections/README.md` (Total bumped 788 → 789; sources 329 → 330; new entry added).
- `library/sources/README.md` (new row inserted).
- `library/keywords.md` (new keyword entries for Endo Gateway vocabulary + 24 first-explicit-observations + new counter row `library-reaches-789-sections at cycle 283` + `one-hundred-and-sixteenth consecutive designs-chat alternation cycles 166-250 + 252-283`).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-282` → `pending-cycle-283`).

## First-explicit-observations (twenty-four)

1. **§the-same-binary-two-configurations** — one binary, `--mode=gateway` vs `--mode=user` (default `user` for backward compatibility); §binary-reuse-as-mode-not-fork.
2. **§the-host-scope-vs-user-scope-split** — three named policy-domain criteria (OS-user-privilege boundary + per-host-singleton-vs-per-user-multiplicity + host-administrator-policy-vs-user-policy); §the-policy-domain-IS-the-decomposition-axis.
3. **§outbound-registration-from-many-to-one** — User Daemons converge on a well-known local rendezvous (`/run/endo-gateway/registrar.sock` Linux; named pipe Windows); §the-rendezvous-shape; §the-registration-IS-a-connect-not-a-discover.
4. **§public-key-keyed-routing-table** — Ed25519 public key (same identifier OCapN uses as node-id) as join key across local IPC registration AND remote OCapN endpoint; §the-single-lookup-serves-both-paths.
5. **§the-local-IPC-socket-IS-the-local-attestation** — channel-IS-the-property shape; §three-named-rejected-alternatives-with-reasons (loopback TCP + kernel credential check; cryptographic attestation backed by host-only secret).
6. **§the-proof-of-possession-step-IS-distinct-from-local-attestation** — one-handshake-two-distinct-concerns pattern; channel-attests-local + signature-attests-key-ownership as two named mechanisms at one handshake.
7. **§the-domain-separation-prefix-on-the-nonce** — literal `endo-gateway:registrar:nonce` prevents signature cross-replay between protocol steps that share the same long-lived key material.
8. **§the-Noise-not-TLS-decision** — three named consequences: no-certificate-management + authentication-by-Ed25519-public-key-not-hostname + browsers-out-of-scope-for-OCapN-endpoint.
9. **§the-ciphertext-passing-relay** — the-relay-IS-incapable-of-reading-by-construction; stronger than the-relay-promises-not-to-read.
10. **§the-frame-level-relay-without-CapTP-inspection** — §named-protocol-layer-ownership-split (HTTP/WS-IS-Gateway + CapTP-IS-User-Daemon + Noise-IS-User-Daemon).
11. **§the-content-addressed-cache-served-direct-from-the-relay** — Gateway serves CAS for static assets without User Daemon RTT; §the-three-tier-cache-then-relay-then-CapTP shape.
12. **§the-rebuild-from-registrations-on-restart** — the-state-IS-rebuildable-from-clients; Gateway state is not its source of truth; self-healing on restart.
13. **§the-404-not-503-for-absent-daemon** — error-code-choice-IS-a-privacy-decision (cacheable + no signal about which users exist).
14. **§the-fall-back-when-no-Gateway-detected** — discovery-IS-the-feature-toggle; single-user developer flow preserved as fall-back path.
15. **§the-`Resolved by review`-section** — design carries inline acceptance-tracking; pairs with `## Open Questions` as §two-named-design-tracking-sections-as-decision-pair.
16. **§two-named-design-tracking-sections-as-decision-pair** — `Resolved by review` (closed) + `Open Questions` (still open); a design as its own changelog and to-do list.
17. **§one-process-many-keys** — `addPublicKey` allows one Daemon to host more than one agent; routing-table entry is (key, daemon) tuple.
18. **§the-`Pass-Invariant-Eq`-named-open-question** — capability-system property (object identity preserved across grants) cited by name as a deferred constraint.
19. **§the-deferred-virtual-users-variant** — second mode-pair (Gateway-with-virtual-users) deferred but preserved in the interface shape; §the-scope-cutoff-with-named-future-mode.
20. **§the-reverse-proxy-as-optional-operator-add** — TLS termination delegated to named external software (Caddy + nginx + Traefik); §named-out-of-scope-with-named-third-party-replacements.
21. **§five-distinct-platform-service-manager-targets** — systemd + launchd + Windows Service + container-runtime + AppImage.
22. **§the-platform-singleton-by-supervisor** — singleton-IS-the-thing-that-started-the-process; the binary carries no singleton-enforcement code.
23. **§the-Affected-Designs-table** — 15-row dependency-and-affecting-relationship table; third named blast-radius shape; §three-cycles-with-named-blast-radius-shapes (275 Affected-packages + 281 What-changes-in-the-existing-library + 283 Affected-Designs-table).
24. **§the-Source-field-with-provenance-chain** — three-link provenance chain in design metadata (design ← issue ← PR-review-comment(timestamp)).

## Multi-cycle pattern recognition

- **§three-cycles-with-Proposed-Status** (279 cli-edit-verb + 281 garden-driver-design + 283 endo-gateway).
- **§three-cycles-with-named-blast-radius-shapes** (275 Affected-packages + 281 What-changes-in-the-existing-library + 283 Affected-Designs-table).
- **§four-cycles-with-design-acknowledging-its-own-evolution-within-the-document** (269 + 279 + 281 + 283).
- **§explicit-confinement-by-omission** generalizes to §the-channel-IS-the-property + §the-relay-IS-incapable-of-reading (234 + 238 + 259 + 283).

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: all 24 first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §three-named-rejected-alternatives-with-reasons + §three-named-consequences-of-cryptographic-protocol-choice + §the-three-tier-cache-then-relay-then-CapTP-shape + §three-named-policy-domains-as-named-separation-criteria + §named-protocol-layer-ownership-split + §three-cycles-with-Proposed-Status (279 + 281 + 283) + §three-cycles-with-named-blast-radius-shapes (275 + 281 + 283) + §four-cycles-with-design-acknowledging-its-own-evolution (269 + 279 + 281 + 283).
- **Tier 3 (multi-cycle pattern recognition)**: §the-channel-IS-the-property-shape generalizing prior §explicit-confinement-by-omission (234 + 238 + 259 + 283).

## Synthesis target

Slot machine library `@game/server` two-mode binary: same compiled artifact as `--mode=lobby` (host-scope front-door, one TCP port, routes player sessions by public key) vs `--mode=table` (per-table game logic, registers outbound with the lobby). The lobby holds **only** the public-key → table-connection routing table; the table owns the game state, the player-action handlers, and the deterministic-replay log. Session confidentiality between player and table is provided by Noise inside a WebSocket frame (so the lobby cannot tamper with player actions even if compromised); static asset delivery (rule sheets, sprite atlas) is served directly out of the lobby's content-addressed cache after the table publishes the tree-root hash. A standalone single-table developer install runs in `--mode=table` and binds its own port; in production, the table detects the lobby and registers outbound instead. The lobby's restart re-builds the table-routing table from incoming registrations. Absent-table response is 404 (cacheable, no leak of which tables exist). The platform service manager (systemd + launchd + Windows Service + container-runtime + AppImage) IS the singleton enforcer.

## Single most structurally interesting move

**§the-same-binary-two-configurations** combined with **§the-platform-singleton-by-supervisor** — the design pushes singleton-enforcement entirely outside the binary (to whichever of five named platform service managers is running) AND keeps the host-scope and user-scope code paths fused into one compiled artifact. The result is **a binary that is mode-selectable at startup but state-light at runtime**: no PID files, no lock files, no internal singleton dance, no per-platform service-manager glue inside the daemon.

## Next cycle

Cycle 284 — chat-lane next.
