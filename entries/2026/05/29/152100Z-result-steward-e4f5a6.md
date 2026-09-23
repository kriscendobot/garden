---
ts: 2026-05-29T15:21:00Z
kind: result
role: steward
host: endolinbot
to: "*"
refs:
  - entries/2026/05/29/150500Z-dispatch-steward-d2e3f4.md
  - entries/2026/05/29/151900Z-result-designer-d77cfc.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: target
---

# result: designer on #343 — endo-gateway.md merged + removed; @endo/platform/ws placeholder added

Designer dispatch `d77cfc` returned cleanly. PR #343 head advanced to
`5ada59b4f586ec9d0858bd0b8bd2de1b64aa27ac`.

## Outcomes (per result `d77cfc`)

Two commits pushed:

- **`adafd6f59`** — folds endo-gateway material into gateway-package
  and removes the old document (4 files, +401/-1076):
  - New §§ Lifecycle, Cross-platform service shape in
    `gateway-package.md`
  - Feature 4 expanded with `GatewayBootstrap`, `Registration`,
    `UserDaemon` subsections + proof-of-possession nonce shape
  - New §§ "Familiar app packaging impact" under Feature 5
  - Three new Open Questions (Q8 cross-host policy, Q9 daemon
    service mode, Q10 host-scoped CAS write-path)
  - Dependencies table extended with 8 rows
  - `designs/endo-gateway.md` removed (1011-line deletion)
  - References updated in `designs/forge-gap-analysis.md` +
    `designs/README.md`
- **`5ada59b4f`** — `@endo/platform/ws` forward-pointer placeholder
  (+23 lines) under § Package Shape in `gateway-package.md`.

Top-level summary comment: 4576840227.
Inline thread replies: 3325268939 (on 3324924389, cites adafd6f5),
3325270172 (on 3324935450, cites 5ada59b4).
Re-request review: HTTP 201, kriskowal back in `requestedReviewers`.

## Designer's recommendation (surfaced for steward decision)

The designer recommends dispatching a separate `endo-platform-ws`
designer to factor the WebSocket powers into a platform-agnostic
module. Rationale: it's independent of #343's lifecycle (the
placeholder lets gateway-package proceed without it), and a parallel
designer can produce the WebSocket-abstraction design while
gateway-package continues through review.

**Steward disposition**: deferred. The user directive was specifically
"respond to #343"; the designer's response is complete (placeholder
captured in-design). Dispatching a separate `endo-platform-ws`
designer is initiating new design work, not continuing #343's
established work. That decision is for a future user directive or
the contractor's design-queue slot machinery.

## Cleanup

Tearing down `/home/kris/dispatches/designer--d77cfc/`.

## Steward queue post-engagement

- **#343** awaiting kriskowal re-review of designer's update.
- **#358** awaiting kriskowal re-review (from 142800Z designer).
- **#377** awaiting kriskowal reply to fixer's response.
- **#357** rebased onto `llm-5b1361d`; CI running (lint failing on
  pre-existing css drift per weaver heads-up — next cycle decides
  conductor vs. shepherd).
- **#79** unchanged.

Self-improvement: nothing new. The forward-pointer-as-placeholder
pattern (vs. dispatching the implied follow-up immediately) preserves
the user's authorization scope.
