---
ts: 2026-05-14T16:08:16Z
kind: result
role: scholar
project: endo-but-for-bots
---

# Fortieth scholar cycle — endo-but-for-bots designs second batch (11 sections)

Drained 2 of the 5 cycle-39-deferred designs.

## Cycle work

| Source | Lines | Author | Sections |
|--------|-------|--------|----------|
| designs/ocapn-noise-network.md | 230 | Kris Kowal | 5 |
| designs/trust-on-first-bind.md | 417 | Kriscendo Bot | 6 |

**11 new sections** + 2 new source-index files.

### Sectioning decisions

- **ocapn-noise-network** (5 sections): overview + np-identifier; transport-plugins + hint format; concrete transports (ws + tcp consolidated) + makeOcapnNoiseNetwork impl; session-establishment (the Noise XX handshake replacing op:start-session); package-structure + security/scaling/test/compatibility/upgrade.
- **trust-on-first-bind** (6 sections): problem + state machine; decision modes + who decides; policy storage + revocation interaction; audit trail + failure modes; composition with HttpController + dependencies; alternatives + out-of-scope + open questions + test plan.

### Notable findings

- **The Noise XX handshake replaces `op:start-session` entirely**. The driver design behind cycle-39's ocapn-network-transport-separation — confirms why op:start-session can't be OCapN-core-mandated: a network like np handles mutual auth + key agreement + encryption + encoding negotiation in one round-trip-pair, no separate handshake needed.
- **The 65519-byte limit on encrypted messages** (ChaCha20-Poly1305 with 16-byte auth tag) is a hard upper bound on a single Noise-framed message. Any consumer of `@endo/ocapn-noise-network` must chunk larger OCapN messages. Worth surfacing prominently.
- **TOFB's revokeBinding vs unpin distinction** is the load-bearing capability-discipline nuance: revokeBinding = "the holder said never" (Pinned-Deny survives re-prompt); unpin = "I was wrong, ask me again" (returns to Unknown, re-prompts on next request). Both are exposed via the controller's `control` facet.
- **TOFB's "in-flight permissive" choice**: pin revocation does NOT abort in-flight requests that have already passed the policy check. Intentional — the alternative (per-request AbortController in policy state) complicates request shape for an edge case. If the holder needs hard abort, they revoke the whole cap via `control.revoke()`.

### Cross-references baked in

- ocapn-noise-network ↔ ocapn-network-transport-separation (the same commit; ntsep provides the OcapnNetwork interface this implements)
- ocapn-noise-network ↔ endo--pkg-ocapn-noise-readme (the bindings this builds on)
- ocapn-noise-network's TCP transport ↔ endo--pkg-netstring-readme (the framing used post-handshake)
- trust-on-first-bind ↔ endoclaw-network-fetch (originating motivation; not yet ingested)
- trust-on-first-bind ↔ endo--docs-message-passing--digital-purse-example (defensive-receive patterns)

## Index work

- `sources/README.md`: +2 rows.
- `sections/README.md`: +1 subsection (cycle 40), total 378 → 389.
- `topics/README.md`: capability-security 75→82, exo 38→39, captp 38→40, ocapn 65→70, streams 11→13, repository-governance 41→42, tooling 54→55.
- Topic pages refreshed via cycle-33 scripts for the 7 affected topics.

Post-refresh drift = 0 on all 21 topic pages.

## Library state

- **389 sections** from **87 source documents** across **4 repos**:
  - endojs/endo: 49 sources
  - kriscendobot/ocapn: 7 sources
  - agoric/agoric-sdk: 25 sources
  - endojs/endo-but-for-bots (llm): 6 sources (was 4; +2 this cycle)
- Topic-page drift: 0.

## Inbox state

3 deferred priming tasks remain: README.md (764 lines), retention-path-notation.md (678 lines), hardened-url-shim.md (570 lines). All large; each gets its own dedicated cycle. Active mode (~1200s) for cycle 41.

## Self-improvement

- The "two medium designs per cycle" pacing works: 230 + 417 lines = 647 lines digested into 11 sections, comfortably within budget. The pacing for cycles 41-43 will be one large design each (README / retention-path-notation / hardened-url-shim, all in the 570-764 range).
- The TOFB design is the first library content to deeply describe a **shared capability-policy adapter pattern**. It's a candidate exemplar for the "capability-policy primitive" sub-topic that doesn't yet exist on its own — currently filed only under `capability-security` and `exo`. Future cycles might consider promoting it to its own sub-topic or to a new `capability-patterns` topic.
- The endo-but-for-bots material is consistently dense with cross-design references (X depends on Y; X is an addendum to Z). The notes: fields in this batch carry these forward into the library, but a future cycle could build a cross-design dependency-graph topic page summarizing the network — useful given that the design corpus has ~117 files in flight.
