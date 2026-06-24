---
ts: 2026-05-21T12:08:00Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
dispatch: 115333Z-dispatch-liaison-c3c0dc
---

# Result: builder c3c0dc — Endo Gateway implementation (slice 1, scaffolding-only)

Builder dispatch `c3c0dc` complete. **DRAFT PR [endo-but-for-bots#337](https://github.com/endojs/endo-but-for-bots/pull/337)** open, branch `feat/endo-gateway`, head `3e3468638`. Self-report at `journal/entries/2026/05/21/120400Z-result-builder-c3c0dc.md`.

## What landed

`designs/endo-gateway.md` (997 lines, 11 slices identified) is too large for one PR. The builder picked the smallest coherent scaffolding slice and surfaced the rest as a numbered follow-up plan.

**Slice 1 (this PR):** new host-scope path functions in `@endo/where` — the foundational path module every later slice needs to write canonical Gateway paths to (registrar socket, host-scope CAS, host-scope sqlite, weblets dir, OCapN endpoint URL).

- Single commit: `feat(where): Endo Gateway host-scope path functions`
- Tests: `@endo/where` 28 pass (16 new across 4 test files); lint clean
- Regression evidence: each platform branch perturbed locally to confirm test fails, then reverted
- Zero daemon-side behavioural risk — leaf package only

## Deferred slices (named for followup ledger)

Builder enumerated, with design-section anchors:

- **Slice 2** — gateway-mode daemon entrypoint (§ Architectural Shape, § Lifecycle)
- **Slice 3** — Registrar / Registration / UserDaemon exos; CapTP/netstring on registrar socket; Ed25519 proof-of-possession (§ Registration Protocol)
- **Slice 4** — Host-header HTTP router with `handleHttp` fallback (§ Weblet Registration)
- **Slice 5** — WebSocket relay (`handleWebSocketUpgrade`)
- **Slice 6** — CAS-direct static-asset delivery (§ Routing an HTTP request)
- **Slice 7** — `ws://<host>/ocapn` endpoint with Noise handshake + pubkey demux (§ OCapN endpoint, separately)
- **Slice 8** — sqlite formula store at host scope
- **Slice 9** — local-vs-remote attestation tag + cross-host policy file (§ Open Question 4)
- **Slice 10** — Familiar packaging integration (rendezvous-socket detection)
- **Slice 11** — cross-platform service manifests (systemd, launchd, Windows Service)

Open questions carried unchanged: OQ 1 (Pass-Invariant-Eq under key rotation), OQ 2 (daemon-hosting variant), OQ 3 (host-scoped CAS write path).

## Builder's self-improvement worth gardener attention

Builder's pre-push-gates skill flagged three findings as pre-existing rather than new, and surfaced them in the result rather than fixing them on a feature PR (per `chore:`-prefers-separate-PR norm). The gate's `filename-no-stutter` probe in particular fires against the established `packages/where/test/where-*.test.js` convention — the builder recommends an allowlist mechanism so legitimate per-package naming conventions don't accrue recurring false-positives. Worth a gardener pass on `skills/pre-push-gates/`.

## Next step — your call

The Gateway is a multi-PR project. Three orchestration options:

- **A**: I dispatch the gauntlet on PR #337 now. It's a small leaf-package addition, the gauntlet will be brief, the un-draft puts it in your review queue. Subsequent slices each get their own PR.
- **B**: I hold the gauntlet on #337 and dispatch the next slice (Slice 2: gateway-mode daemon entrypoint) as a stacked PR on top of `feat/endo-gateway`. Lets the whole stack accrue before any review queue traffic.
- **C**: You pick a different slice ordering or shape (e.g. land 2-3 slices in #337 before un-drafting, or split the work between this session and a separate dispatch).

Awaiting your direction.

## Teardown

Dispatch root `/home/kris/dispatches/builder--c3c0dc/` torn down by the liaison after this entry lands.
