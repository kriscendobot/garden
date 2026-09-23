---
ts: 2026-06-03T02:47:07Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--9e4b4c
cycle: 136
---

# Cycle 136 — make-far.js (Kris Kowal, endo) — comments-lane

Ingested `packages/pass-style/src/make-far.js` (221 lines) from
`endojs/endo@57100aa0` (master). **Twenty-seventh comment-
fragment ingest.** One cohesion-honest section:

- **Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-
  and-mutate-harden-check-twice-discipline** — the *constructor*
  layer for remotables. Direct companion to cycle 134's
  `remotable.js` (which *validates* what this file *constructs*).
  Three exports (Remotable / Far / ToFarFunction) + GET_METHOD_NAMES
  constant.

## The single most structurally interesting move

The §three-piece prefix-handling discipline across three files:

| Cycle | File | Role |
|-------|------|------|
| 136 (this) | make-far.js | *produces* `'Alleged: '` prefix in Far() |
| 134 | remotable.js | *requires* the prefix in confirmIface() |
| 130 | message-breakpoints.js | *strips* the prefix in simplifyTag() |

The triad covers create / validate / match.

## §mutate-harden-check-twice fail-fast pattern

First call `mutateHardenAndCheck({})` on a fresh empty object
(dry run); only then on the real remotable. *The caller's
remotable doesn't get mutated mid-failure*.

## §isFrozen comparison-against-fresh

`isFrozen(remotable) === isFrozen({})` instead of
`!isFrozen(remotable)` — *because isFrozen always returns true
when using lockdown with hardenTaming set to the deprecated
'unsafe' option*. The §pattern-for-detecting-environment-quirks:
don't hard-code expected return values; compare against a fresh
control sample.

## §Allegation-not-attestation

The iface is *the originating vat's claim about the object's
identity*, not a verified attestation. *Alice can tell Bob about
Carol, where VatA (on Alice's behalf) misrepresents Carol's
iface. VatB and therefore Bob will then see Carol's iface as
misrepresented by VatA.* The `'Alleged: '` prefix is the visible
reminder consumers must not over-trust.

## §GET_METHOD_NAMES modeled on GET_INTERFACE_GUARD

The auto-method pattern that cycle 118's exo-tools.js section 2
introduced as `GET_INTERFACE_GUARD` is now applied to Far
objects as `GET_METHOD_NAMES`. The §getMethodNamesMethod is
*thisful for far-object inheritance* — `getMethodNames(this)`
walks the receiver's prototype chain so subclass remotables see
their full method set.

## Pass-style remotable surface now complete

Four pass-style files in the library:

- cycle 71 — `passStyleOf.js` (dispatcher)
- cycle 87 — `error.js` (three sections; error passability)
- cycle 134 — `remotable.js` (validator)
- **cycle 136 (this cycle)** — `make-far.js` (constructor)

The four files cover *the complete pass-style remotable surface*:
how a remotable is constructed, how it's recognized, what its
prototype chain looks like, and how its iface is named (with the
allegation-not-attestation prefix discipline).

## Rotation note

Cycle 136 was nominally **chat-lane** (cycle 135 was designs).
Chat-lane is exhausted at 20/20. Papers-lane has been blocked
for **30+ consecutive cycles** due to lack of PDF-fetching
infrastructure. Cycle 136 pivoted to comments-lane.

## Counts

- 639 → **640** sections (+1).
- 180 → **181** source documents (+1).
- Topic pages updated: `pass-style.md` (+1 row — completes the
  remotable-surface coverage).
- Keywords index extended with ~33 make-far-specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 137 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked at 30+). Many candidate paths.
