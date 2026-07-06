## Completion report

**Job:** Build `@endo/gateway` Feature 8 — the canonical `/ocapn` WebSocket endpoint on the merged `packages/gateway/` skeleton (base `llm`, bot fork only).

**Outcome: implemented and verified, but NO PR opened — a sanctioned duplicate (#577) already claims this increment.** Per the builder "verify no open PR already implements the issue; skip and surface" norm, I did not open a competing PR. I surfaced the coordination decision to the maintainer and preserved my work on a branch.

### What I built (verified)
A superset of Feature 8's Phase-1 slice, in the project worktree:
- `packages/gateway/src/ocapn-ws.js` — `matchOcapnPath` (canonical `/ocapn-cbor-np` + `/ocapn` alias, query/fragment stripping, strict otherwise), `adaptWebSocket` (WebSocket→`@endo/stream` byte-stream, binary-only, close/error routing), and `makeOcapnWebSocketEndpoint({ onConnection })` whose `accept(pathname, ws)` adapts the socket and hands the framed connection to the injected netlayer sink. Gateway is a frame relay (never inspects/decrypts).
- `index.js` — constructs the endpoint when `ocapnWebSocket` is enabled; the sink is the powers-injected seam `powers.ocapn.onConnection`, handed to the embedder via `powers.ocapn.register`. Daemon `@apps` + `@endo/ocapn-noise` wiring deferred as the named seam.
- `types.d.ts`, `README.md`, `package.json` (`@endo/stream` dep), plus 20 new tests.
- **Verified:** `yarn ava` 73 pass (20 new), `tsc` clean, `eslint` clean, `prettier --check` clean. Regression evidence: mutated the alias mapping and the non-binary rejection — each fails exactly the corresponding tests; reverted.

### Why no PR
- **PR #577** (open draft, base `llm`, "OCapN WebSocket path scheme — Phase 1 feature 8") implements only the pure-logic **path-naming half** and *explicitly defers the live socket handoff + frame relay*. It rewrites the **same files** with **incompatible symbol names** (`matchOcapnWebSocketPath`/`ocapnWebSocketConnectionHint` vs my `matchOcapnPath`/`makeOcapnWebSocketEndpoint`). Two competing draft PRs redefining `src/ocapn-ws.js` on `llm` cannot coexist.
- Related in-flight overlap on other stacks: #392 (phase-4 `OcapnWebSocketHandler`), #413 (phase-11a HTTP listener).
- My distinct value — the socket handoff #577 defers — is real, so I preserved rather than discarded it.

### Preserved / surfaced
- Branch `feat/gateway-ocapn-ws-endpoint-handoff` pushed to `endojs/endo-but-for-bots` (no PR; 2 commits: feat + separate `chore: Update yarn.lock`).
- Maintainer message sent (via liaison) with the analysis and three options; **recommended (a): let #577 land the naming, re-scope my handoff to build on #577's `matchOcapnWebSocketPath`.** No reply yet (async decision).

### Follow-ups
- Maintainer to choose: (a) rebase my handoff onto #577's path scheme, (b) supersede #577 with my superset, or (c) drop the branch.
- Whichever path: the eventual PR needs a frozen `llm-<sha>` base and a changeset entry (#577 already adds one; a rebase-on-#577 would not duplicate it).
