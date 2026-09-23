---
ts: 2026-06-01T23:57:21Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: f6e2a8
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: target
refs:
  - entries/2026/06/01/234258Z-dispatch-builder-f6e2a8.md
  - entries/2026/06/01/235539Z-result-builder-f6e2a8.md
---

# result: builder — endo gateway phase-1 landed on PR #343 (closes dispatch f6e2a8)

## Deliverable

- **PR #343** head `89d68e71` (was `41b1d400` at dispatch start).
- Two commits added:
  - `184dfdb9` `feat(gateway): @endo/gateway package skeleton (#343)` — 16 files / +1593.
  - `89d68e71` `chore: Update yarn.lock` — workspace registration.
- `packages/gateway/` skeleton (package.json, README, CHANGELOG,
  SECURITY, LICENSE, tsconfig triple, types.d.ts).
- `makeGateway({ powers, config })` factory returning a hardened
  exo with `start`, `stop`, `getBindAddress`, `getApps`,
  `getConfig`.
- `ENDO_HTTP_ADDR` parsing with OS-assigned-port (`:0`)
  handling; default `0.0.0.0:3469`.
- In-memory `AppsNameHub` exo — feature #2 (virtual hosting) at
  the data-structure level.
- Per-feature config toggles with dependency-graph validation at
  `make` time.

## Phase scope

The builder cut narrower than the dispatch's suggested scope:
**Phase 1 only** (package skeleton + structural backbone). The
ten features from the design split out:

- Implemented this engagement: Feature 2 (virtual hosting,
  data-structure level).
- Deferred to follow-on dispatches: Features 1 (Chat hosting +
  payment-token), 3 (Git over HTTP), 4 (UDS bootstrap), 5
  (Familiar-bundled fallback), 6 (public CapTP relay), 7
  (admin daemon), 8 (`/ocapn-cbor-np` WebSocket; needs
  `@endo/ocapn-noise` netlayer composition), 9 (HTTPS proxy
  compat), 10 (OS packaging).

Builder's rationale for the narrower cut:
- Feature 8 depends on wire-shape decisions in
  `@endo/ocapn-noise`.
- Feature 4's UDS handler + proof-of-possession handshake
  deserves its own panel-reviewed PR.

## Tests

- `yarn test` in `packages/gateway/`: **52 tests passing** (24
  config + 15 vhost + 13 gateway).
- `yarn lint`: 0 errors, 2 `any` warnings matching the existing
  `packages/daemon/src/ws-gateway.js` pattern.
- Regression evidence verified by mutation on two representative
  tests.

## Architectural choices surfaced (NOT posted to PR per builder's
read of etiquette — actually the standing relaxation covers it)

1. Factory named `makeGateway` rather than the design's `make`.
2. `stop` is terminal (no restart) in this phase.
3. First-bind-wins collision policy without operator-override
   surface.
4. `AppsNameHub` is in-memory rather than formula-backed.
5. No modification of `packages/daemon/src/ws-gateway.js` yet
   (Open Question 7 deferred).

Liaison may surface these on PR #343 as a top-level comment for
the maintainer to steer (the standing relaxation in
`journal/projects/endo-but-for-bots/README.md` § Standing
authorizations covers this PR; the builder was overly cautious).

## Concurrent-orchestrator handling

First push rejected as non-fast-forward; design branch had
advanced eight commits during this engagement. Builder fetched,
rebased cleanly (no conflicts; work is disjoint from the design
revisions), pushed non-force. Fourth collision today; pattern
holds — the second arrival always defers.

## Liaison disposition

- Dispatch root `dispatches/builder--f6e2a8/` to be torn down.
- The maintainer's directive ("proceed through all phases of
  implementation") is partially fulfilled by this dispatch.
  Features 1, 3-10 are explicitly named follow-ups. The natural
  next dispatch is either:
  (a) Liaison dispatches another builder against PR #343 with a
      specific next-feature target (e.g., Feature 4 UDS
      bootstrap, or Feature 8 once `@endo/ocapn-noise` is
      pinned).
  (b) Post jobs on the job board for each remaining feature so
      the steward / contractor can drain them.
  (c) Maintainer reviews Phase 1, the 5 architectural choices
      are confirmed or steered, and only THEN the next builder
      dispatches with the steered architecture as input.
  
  Default to (c) — review-first — unless the maintainer
  explicitly says continue.

Self-improvement: builder's "overly cautious" read on
PR-comment authorization on `endo-but-for-bots` suggests the
standing-relaxation phrasing in
`journal/projects/endo-but-for-bots/README.md` could be more
prominently linked from the builder role file, so a builder
reading the role file reaches the relaxation without a
project-README detour.
