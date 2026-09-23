---
ts: 2026-06-04T05:39:26Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/04/045730Z-dispatch-liaison-931744.md
  - entries/2026/06/04/052933Z-result-fixer-931744.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
---

# result: #417 second-round scope-trim applied; new head e1f4541ab

Fixer `931744` closed. All 4 asks from kriskowal review
`4424846301` addressed across 7 commits.

## Per-ask status

| Ask | Disposition | Commit |
|---|---|---|
| 1 (1460 symbol-form permits) | applied (deleted) | `5cfbb0569` |
| 2 (1434 concatImmutables spackle) | dropped entirely | `e6a6c1d7d` |
| 3 (1281 text-codec permits) | dropped (module-local capture suffices) | `b8ec65ee4` |
| 4 (389 brand-check spackle) | not needed (explained) | `ec546d2b6` |

Plus three follow-ups: `4386b1bc6` (prettier), `1e54211c2`
(JSDoc), `e1f4541ab` (CI fix for installable heuristic).

## Per-package changes

- **packages/bytes**: removed `install-concat-immutables.js`,
  `install-from-string.js`, `install-to-string.js`. Rewritten
  to module-local captures or pure JS. `install-to-immutable.js`
  + `install-transfer-to-immutable.js` switched to string-key
  rendezvous. Tests refactored; installable heuristic fixed
  to check a registered-symbol slot.
- **packages/ses**: `permits.js` lost 7 RegisteredSymbol
  entries; `RegisteredSymbol(freezable)` + `RegisteredSymbol(fromImmutable)`
  retained.
- **packages/immutable-arraybuffer**: `DESIGN.md` spackle
  section rewritten + new brand-check section explains why
  no intrinsic install is needed.

## Gates

All 0 (ses pre-existing `Compartment` duplicate unchanged).

## Reply IDs

- Ask 1: `3353667449`
- Ask 2: `3353668041`
- Ask 3: `3353668998`
- Ask 4: `3353669886`
- Top-level summary: `4619219343`

## Judgment calls

### Ask 3 verdict: confirmed

`bytesFromText` / `bytesToText` already capture
`TextEncoder` / `TextDecoder` at module load via
`install-helpers.js`. The capture is the load-bearing
protection against endowment override; the install at a
registered symbol on `Uint8Array` was redundant. Eval twins
each capture their own instance — constructors are stateless
by spec, equivalent. Dropped install modules + permits.

### Ask 4 verdict: no brand-check spackle needed

Internal brand check uses the `hiddenBuffers` WeakMap
shared with `@endo/immutable-arraybuffer` via the narrow
`private-for-bytes.js` subpath. External code uses
`isBufferImmutable` free function OR the standard-track
`ArrayBuffer.prototype.immutable` getter from the shim.
Rationale in DESIGN.md § Brand-checking.

## CI

The fix commit `e1f4541ab` addressed a real test issue
that surfaced under the lockdown ses-ava config (prior
`installable` heuristic confused immutable-arraybuffer
shim's pre-lockdown install of `sliceToImmutable` with the
spackle's post-lockdown install of registered symbols).

CI still running at fixer return; re-request review
pending green.

## Teardown

`dispatches/fixer--931744` torn down.

## Steward queue post-engagement

- **#417** at `e1f4541ab` (significantly trimmed spackle
  scope); CI running; awaits green + maintainer reassessment.
- **#244** driver-lane handling.
- **#411** at `56c3e9ddb` (timeout extended); CI re-queued.
- **#418** MERGED earlier.
