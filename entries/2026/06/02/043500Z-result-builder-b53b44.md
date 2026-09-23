---
ts: 2026-06-02T04:35:00Z
kind: result
role: builder
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--b53b44/project
---

Phase 5 of the Endo Gateway implementation stack landed as PR #393
on `endojs/endo-but-for-bots`. Feature 6: public CapTP relay with
closed-allowlist default plus opt-in open policy. Lands the data
model and admission surface on top of phase 4's
`OcapnWebSocketHandler`.

URL: https://github.com/endojs/endo-but-for-bots/pull/393
Base: `design/gateway-package-phase-4` (PR #392 head)
Head: `design/gateway-package-phase-5`
State: OPEN, DRAFT

## Files added

- `packages/gateway/src/relay-policy.js`: policy data model and
  admission predicate.
- `packages/gateway/test/relay-policy.test.js`: 31 unit tests.

## Files modified

- `packages/gateway/src/bootstrap.js`: `registerRelay` policy
  field, `Registration` mutators, admin-backplane mutators,
  `listRegistrations` / `lookupRegistrationByPublicKey` surface
  the policy.
- `packages/gateway/src/admin.js`: `GatewayAdmin` policy methods,
  `RegistrationSummary` policy fields.
- `packages/gateway/src/ocapn-ws.js`: policy admission before
  handoff, `extractDialerPublicKey` adapter slot.
- `packages/gateway/index.js`: re-exports.
- `packages/gateway/package.json`: subpath export.
- `packages/gateway/README.md`: phase-5 status and surface.
- `packages/gateway/test/bootstrap.test.js`: 18 new tests.
- `packages/gateway/test/admin.test.js`: 9 new tests.
- `packages/gateway/test/ocapn-ws.test.js`: 8 new tests.

## Test runner output

`yarn ava` in `packages/gateway`: 237 tests pass (171 pre-existing
+ 66 new). `yarn lint:types` clean. Prettier clean.

## Architectural choices for maintainer

1. **Caller-identification under Noise IK: fail closed.** Per
   `packages/ocapn-noise/README.md`, the wire shape uses Noise IK,
   which encrypts the initiator's static under the responder's
   static (identity hiding, Noise §7.8 property 8). The gateway
   peeks at exactly one cleartext byte range (the
   intended-responder prefix) and otherwise forwards ciphertext
   blobs without inspecting them. It cannot read the dialer's
   public key from the first frame.

   The dispatch prompt's hint that the dialer's key was the
   "second 32-byte prefix" presupposed a different wire shape
   (perhaps a future Noise variant or a pre-handshake protocol
   extension). Phase 5 honors the dispatch's intent by landing the
   data model and admission surface (so future caller-identity
   carriers plug in without reworking the handler), but the
   today-case defaults the `extractDialerPublicKey` adapter to
   `undefined` and closed-policy relays fail closed. Tests verify
   the future case with a test-injected extractor reading from the
   second 32-byte slot, demonstrating the allowlist-hit /
   allowlist-miss / live-mutation paths work end-to-end.

2. **Alternative considered and rejected.** Interpreting
   closed-allowlist as *the intended-responder registration is
   itself the allowlist* (phase 4 already gates by registration
   lookup) flattens the design's policy framing: it admits every
   inbound session for any registered relay target with no room
   for the registrant to restrict callers to specific peers.
   Phase 5 preserves the policy data structure rather than
   silently flattening.

3. **Closed-by-default per design Feature 6.** Every
   `registerRelay` defaults to `relayPolicy: 'closed'`; `'open'`
   is per-registration opt-in. No gateway-wide override.

4. **`register` (non-relay) entries have no policy and are
   inherently authorized.** Phase 4 behavior preserved for daemon
   registrations; only relay registrations consult the policy.

5. **Live policy entry, not a snapshot.** The handler holds the
   `RelayPolicyEntry` by reference so admin or registrant
   mutations are visible immediately. Regression test pins the
   property.

6. **Wire shape preserved.** Public keys cross the CapTP boundary
   as immutable `ArrayBuffer` per `@endo/bytes`; the policy
   module's in-process API also accepts `Uint8Array`. Hex render
   matches the bootstrap's `publicKeyToHex` for cross-module
   compatibility.

## Surface added

CapTP-facing (new methods on existing exos plus a new module):

- `Registration.setRelayPolicy(policy) -> previous policy`
- `Registration.getRelayPolicy() -> policy`
- `Registration.addCallerPublicKey(key) -> boolean`
- `Registration.removeCallerPublicKey(key) -> boolean`
- `Registration.listCallerPublicKeys() -> hex[]`
- `GatewayAdmin.setRelayPolicy(publicKey, policy) -> previous`
- `GatewayAdmin.addRelayCaller(publicKey, callerKey) -> boolean`
- `GatewayAdmin.removeRelayCaller(publicKey, callerKey) -> boolean`
- `GatewayBootstrap.registerRelay({..., relayPolicy?})` (optional
  field on existing method)
- New `OcapnWebSocketHandler` dep: optional
  `extractDialerPublicKey(firstFrame) -> publicKey | undefined`

The liaison's next dispatch is Phase 6.

Self-improvement: the dispatch prompt's "second 32-byte prefix"
description of the dialer's key disagrees with Noise IK's identity
hiding (`packages/ocapn-noise/README.md` § Handshake Protocol step
1). Future Phase 5-shape dispatches that route through Noise IK
should either name the encryption gap up front or describe a
pre-handshake protocol extension. Sending the suggestion to the
liaison via a `message` entry would be the right shape if this
pattern recurs; for a one-off dispatch the architectural-choices
explanation in the PR body and this result entry covers the gap.
