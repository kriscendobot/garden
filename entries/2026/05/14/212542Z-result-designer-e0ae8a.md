---
ts: 2026-05-14T21:25:42Z
kind: result
role: designer
project: endo-but-for-bots
refs:
  - entries/2026/05/14/211859Z-dispatch-liaison-e0ae8a.md
---

# Result: OCapN-Noise session-reconnect design opened as draft PR #252

Dispatch root: `dispatches/designer--e0ae8a/`. Branch `design/ocapn-noise-session-reconnect` pushed; draft PR opened at https://github.com/endojs/endo-but-for-bots/pull/252 against `llm` per the new designer policy.

## Layout choice

New sibling design at `designs/ocapn-noise-session-reconnect.md` rather than in-place amendment of `ocapn-noise-network.md`. The new content is substantial (six concerns, two mermaid diagrams, seven open questions) and reads cleaner as a standalone document with a forward `See also` link from the primary design. The primary design's metadata `Updated` field was bumped to 2026-05-14 and a one-paragraph cross-link inserted; `designs/README.md` gained a summary-table row, an entry in the front-matter "added" list, and a node + two edges in the OCapN dependency subgraph.

## Abstract of the amendment

The OCapN-Noise network gains a meta-TCP session layer that decouples the CapTP session lifetime from the TCP transport instance. Each side emits an `op:ping` (proposed OCapN extension) every 5 s; if no traffic arrives within 30 s the session is declared lost on the current TCP pipe and a reconnect begins. Reconnects are transparent: the CapTP session continues uninterrupted, with a session epoch counter incremented per reconnect. Crossed-hellos are resolved by deterministic lexicographic comparison of the two Ed25519 designators (smaller is responder). Noise nonce continuity is preserved by a Resume path (continue the existing CipherState with `nonce = max(local_send, peer_acked_recv) + 1`); a Rekey path (fresh full handshake) is offered as a configurable cap, gated on the security review. The non-negotiable rule: no `(key, nonce)` pair is ever reused under ChaCha20-Poly1305, on any path.

## Open questions for maintainer / OCapN-org

Seven, consolidated in the design's Open Questions section:

- **P1**: single `op:ping` heard as pong vs. distinct `op:pong`. Amendment leans toward single.
- **P2**: heartbeat inside Noise vs. below Noise. Amendment leans toward inside.
- **P3**: designator-comparison vs. transcript-hash tiebreaker. Amendment leans toward designator.
- **C1**: Resume vs. Rekey (most security-sensitive; defer to `ocapn-noise-cryptographic-review`).
- **C2**: implicit ack of nonces via traffic vs. explicit `op:ack`. Amendment leans toward implicit.
- **T1**: defaults of 5 s / 30 s and whether OCapN spec recommends a profile range.
- **T2**: fixed vs. adaptive heartbeat. Amendment leans toward fixed.

## Files

- `designs/ocapn-noise-session-reconnect.md` (new, 597 lines)
- `designs/ocapn-noise-network.md` (cross-link added, `Updated` bumped)
- `designs/README.md` (summary table row, dependency subgraph node, totals updated)

## PR

https://github.com/endojs/endo-but-for-bots/pull/252 (DRAFT, base `llm`, head `design/ocapn-noise-session-reconnect`).

Self-improvement: nothing this time.
