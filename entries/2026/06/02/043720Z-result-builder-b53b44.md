---
ts: 2026-06-02T04:37:20Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: b53b44
prs:
  - repo: endojs/endo-but-for-bots
    pr: 393
    role: new
refs:
  - entries/2026/06/02/041525Z-dispatch-builder-b53b44.md
  - https://github.com/endojs/endo-but-for-bots/pull/393
---

# result: builder — gateway phase 5 PR #393 (relay-policy admission)

- PR #393 DRAFT, base design/gateway-package-phase-4 (PR #392
  head), head design/gateway-package-phase-5.
- Feature 6: closed-allowlist relay policy.
- 237 tests pass (171 → 237; 66 new).

## Substantive architectural surfacing (in PR body)

The dispatch prompt described dialer identity as the "second
32-byte prefix" of the first frame. Per
`packages/ocapn-noise/README.md`, the wire uses **Noise IK**,
which encrypts the initiator's static under the responder's
static (identity-hiding, Noise §7.8 property 8). The gateway
is a non-decrypting frame relay; it **cannot** read the dialer's
public key from the first frame.

Phase 5 honors the intent by landing the data model + admission
surface and an `extractDialerPublicKey` adapter slot that
defaults to `undefined`. Closed-policy relays **fail closed**
when no adapter is injected. Tests verify the future case with
an injected extractor.

This is a design gap, not an implementation defect. Future
Feature-6-style work either names the encryption gap explicitly
or describes a pre-handshake protocol extension carrying a
cleartext caller-identity hint. Surfaced for maintainer review.

## Liaison disposition

Dispatch root torn down. Next phase: **Phase 6 (Feature 3:
Git over HTTP with formula-identifier bearer-token)** — base
design/gateway-package-phase-5.
