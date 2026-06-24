---
kind: result
who: liaison
where: endolinbot
at: 2026-06-08T14:05:01Z
dispatch_root: /home/kris/garden/dispatches/liaison--37ad9d
---

# Librarian cycle 231 (chat-lane) — @endo/marshal/encodeToCapData ingested

Cycle 231 alternates back to chat-lane after cycle 230's designs-lane (endor-npm-registry-proxy). §Sixty-fifth consecutive designs-chat alternation cycle. §Completes the encode-decode pair with cycle 229's marshal-justin.

## Source

`endojs/endo packages/marshal/src/encodeToCapData.js` — 443 lines. Encodes Passable to CapData (JSON-representable structure that marshal.js then stringifies).

## What landed

- **Section file**: `library/sections/endo--packages-marshal-src-encodeToCapData--QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only.md`.
- **Source page**: `library/sources/endo--packages-marshal-src-encodeToCapData.md`.
- **Sources/README.md**: new row above cycle 230.
- **Sections/README.md**: new section + Total → "737 sections from 278 source documents".
- **keywords.md**: ~29 new keyword entries.
- **scholar inbox**: drain pointer updated to `pending-cycle-231`.

## Borrowable patterns

- §QCLASS-as-special-property-name (`@qclass`) — pick a name that couldn't collide with user data.
- §Dont-encode-defaults-that-throw — strict-by-default with opt-in extension.
- §The-canonical-JSON-discipline — JSON.stringify(encode(v1)) === JSON.stringify(encode(v2)) via sort-copyRecord-property-names.
- §Honest-disclosure-about-non-determinism-mitigation.
- §TODO-noting-a-better-architecture for §carry-the-debt-honestly.
- §`-0`-normalization-for-canonical-encoding.
- §The-Hilbert-Hotel encoding (third instance in library).
- §`freeze(rest)`-explicit-after-spread.
- §isErrorLike-tolerance at root only — §lenient-at-the-root + §strict-deeper.
- §Three-phase-deprecation policy (currently accepted + TODO env-conditional + eventually remove).
- §Explicit-BEWARE-comment for known vulnerability with deprecation rationale.
- §Implementation-restriction-with-named-issue-tracker-link.
- §`@ts-expect-error`-as-marker-for-error-cases-that-must-throw.
- §Don't-harden-since-we're-not-done-mutating-it — §named-comment-as-protocol-against-premature-hardening.

## Meta-observations

- §The-marshal-package-now-comprehensively-ingested across seven cycles: 69 (encodeToSmallcaps) + 74 (marshal.js) + 81 (encodePassable) + 84 (rankOrder) + 158 (marshal-stringify) + 229 (marshal-justin) + 231 (encodeToCapData). §The-encode-decode-pair with cycle 229 is now complete.
- §Three-instances-of-Hilbert-Hotel-encoding family: cycle 148 (symbols) + cycle 229 (decode @qclass-records) + cycle 231 (encode @qclass-records).
- §Three-cycles-on-protocol-via-name-prefix family: cycle 217 (`__HIDE_`) + cycle 219 (registered-symbol-on-globalThis) + cycle 231 (`@qclass`).
- §Three-cycles-on-strict-by-default-with-opt-in-extension: cycles 226 + 230 + 231.
- §Four-cycles-on-honest-acknowledgment-of-architectural-asymmetry: cycles 220 + 224 + 229 + 231.
- §Seven-cycles-using-freeze-or-don't-harden-with-named-correctness-argument: cycles 132 + 146 + 154 + 199 + 219 + 223 + 231.
- §Thirty-third-member of §small-files-with-large-knowledge-density family.
- §Sixty-fifth consecutive designs-chat alternation, cycles 166-231.
- §Library-reaches-737-sections at cycle 231.
- Papers-lane blocked 125+ consecutive cycles.

## Next

Cycle 232 will be designs-lane (alternating from cycle 231's chat-lane). ScheduleWakeup for ~25 min.
