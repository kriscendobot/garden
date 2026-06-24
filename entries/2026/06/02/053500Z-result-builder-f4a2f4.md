---
ts: 2026-06-02T05:35:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: f4a2f4
prs:
  - repo: endojs/endo-but-for-bots
    pr: 396
    role: new
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/396
---

# result: builder — gateway phase 8 PR #396 (ResourceLedger exo + payment-token contract)

- **PR #396** DRAFT, base `design/gateway-package-phase-7` (PR #395 head),
  head `design/gateway-package-phase-8`.
- Feature 1: chat-hosting payment-token enhancement, gateway side
  only. The Chat-weblet purchase UI is downstream client work.
- New `ResourceLedger` exo (`packages/gateway/src/resource-ledger.js`)
  with `getBalance`, `chargeBalance`, `purchaseTokens`, `setQuota`,
  and admin-facing `listBalances`.
  - Accounts keyed by Ed25519 public key (immutable `ArrayBuffer`
    on the wire, hex-canonicalized internally).
  - `purchaseTokens(agentPublicKey, tokens, proof)` defers payment-
    proof validation to an embedder-supplied `verifyPaymentProof`
    power; the verifier may return `true` (credit caller's stated
    tokens), a `ResourceTokens` record (settle a different grant),
    or a falsy value / throw (fail the purchase, leave state
    unchanged).
  - Fail-closed everywhere: zero default balance, atomic-or-fail
    debits and credits, loud rejection of unrecognized class names.
- `index.js` adds the optional `verifyPaymentProof` power and the
  new `Gateway.getLedger()` accessor. The internal ledger also
  feeds the admin facet's `getResourceBalances` read-through that
  Phase 3 stubbed against an external handle.
- `verifyPaymentProof` and the legacy external `resourceLedger`
  power are mutually exclusive at construction time.
- Files: `.changeset/endo-gateway-resource-ledger.md`,
  `packages/gateway/src/resource-ledger.js` (new),
  `packages/gateway/test/resource-ledger.test.js` (new, 44 tests),
  `packages/gateway/index.js`, `packages/gateway/package.json`,
  `packages/gateway/test/gateway.test.js` (+5 wiring tests).
- Tests: 358 / 358 passing in `packages/gateway`.
- Lint: 0 errors (182 warnings, all jsdoc/reject-any-type pre-
  existing). `lint:types` clean.
- Saboteur-verified two key checks: the `chargeBalance` underflow
  guard and the `purchaseTokens` falsy-verdict guard both fail
  loudly when stubbed out, confirming the corresponding tests are
  load-bearing.

Stack so far: #343 -> #388 -> #389 -> #392 -> #393 -> #394 -> #395
-> **#396**. Phases 9-11 to follow per the dispatch prompt:
Feature 5, 9, 10.

Choices worth flagging:

1. Followed the design's named methods (`getBalance`,
   `chargeBalance`, `purchaseTokens`, `setQuota`) rather than the
   alternative `recordCompute/recordStorage/recordNetwork` shape
   the dispatch prompt offered as a fallback. The design's
   Capability Surface section was explicit, so the dispatch
   prompt's "if the design is light on detail" hedge did not
   apply.
2. Verifier can override the credited tokens (returning a
   `ResourceTokens` record). The design doesn't explicitly call
   this out, but it falls naturally out of the "payment processor
   settles the actual grant" framing and lets future processor
   adapters apply per-class fees or rounding without redesigning
   the verifier protocol.
3. Kept `resourceLedger` (Phase 3's external-handle path) and the
   new `verifyPaymentProof` mutually exclusive rather than letting
   one supersede the other. The design's "Gateway OWNS the
   surface" framing means a gateway has at most one canonical
   ledger handle; silent precedence would mask configuration
   errors.
4. The admin facet still tolerates "no ledger" (returns `[]`) per
   the dispatch prompt's instruction. Phase 8 keeps ledger
   optional, not required.

Pre-PR gates: yarn format, yarn lint, yarn test, yarn lint:types
all clean. Conventional commit with `(#343 phase 8)` suffix. PR
opened DRAFT. Frozen-base discipline does not apply within the
stack (the stack base is `design/gateway-package-phase-7`, itself
a sibling-branch base from Phase 7's PR).

Self-improvement: nothing this time. The phase-stack pattern,
fail-closed conventions, and admin-facet wiring are well-
established by Phases 1-7; Phase 8 followed them faithfully. One
small note worth surfacing for future builders: the `M.any()`
pattern on an exo method rejects mutable `Uint8Array` on the wire
even though the in-realm validator accepts both shapes. My initial
tests assumed `Uint8Array` worked through `E()` and had to be
rewritten to use `bytesToImmutable`. The existing `bootstrap.js`
faces the same constraint but its tests only ever use immutable
`ArrayBuffer` so the constraint is implicit. This is a property of
the makeExo / @endo/patterns layer rather than a builder-skill
issue, so the lesson does not warrant a self-improvement entry.
