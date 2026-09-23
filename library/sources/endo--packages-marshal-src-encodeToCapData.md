---
title: "@endo/marshal/encodeToCapData — encode Passable to CapData (JSON-representable structure); QCLASS discriminator; canonical-JSON discipline"
source-slug: endo--packages-marshal-src-encodeToCapData
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
status: shipping
ingest-cycle: 231
ingest-date: 2026-06-08
lane: chat
---

# @endo/marshal/encodeToCapData

A 443-line file that encodes a Passable to CapData (a JSON-representable structure that `marshal.js` then stringifies). §Companion to cycle 229's marshal-justin.js — cycle 229 decodes CapData to Justin source; cycle 231 encodes Passable to CapData. §The-encode-decode-pair-is-now-complete.

## Key design moves

- **§QCLASS-as-special-property-name** (`@qclass`) — §the-discriminator-prefix.
- **§Dont-encode-defaults-that-throw** — strict-by-default with opt-in extension.
- **§The-canonical-JSON-discipline** — `JSON.stringify(encode(v1)) === JSON.stringify(encode(v2))` for equivalent inputs.
- **§Sort-copyRecord-property-names** — the only case where order is not implicit in the code.
- **§Honest-disclosure-about-non-determinism-mitigation** — *We impose this requirement mainly to reduce non-determinism exposed outside a vat*.
- **§TODO-noting-could-use-canonical-JSON-encoder** for modular encapsulation.
- **§Eleven-cases-in-encode-switch** with §defense-in-depth-validation-of-callback-return-shape via `qclassMatches`.
- **§`-0`-special-case** normalizes to `0` (canonical encoding).
- **§The-Hilbert-Hotel encoding (third instance in library)** — cycle 148 (symbols) + cycle 229 (decode) + cycle 231 (encode).
- **§isErrorLike-tolerance at root only** — §lenient-at-the-root + §strict-deeper.
- **§The-`@@asyncIterator` deprecated-qclass** with §three-phase-deprecation (currently accepted + TODO env-option-conditional + eventually remove).
- **§The-explicit-BEWARE-comment** for slot-decode with §deprecation-rationale-for-not-fixing-it-immediately.
- **§Implementation-restriction** (promise-vs-remotable must use same callback) with §named-issue-tracker-link.
- **§The-`ibid`-removed-but-still-rejected case** with §explicit-rejection-with-named-error.
- **§The-don't-harden-since-we're-not-done-mutating-it (hilbert decode)** — §the-comment-IS-the-protocol-against-premature-hardening.

## Section files

- [§QCLASS-discriminator + §canonical-JSON-discipline + §dont-encode-defaults-that-throw + §Hilbert-Hotel-third-instance + §isErrorLike-tolerance-at-root-only](../sections/endo--packages-marshal-src-encodeToCapData--QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only.md) — full source ingest.

## Ingest scope

Cycle 231 (chat-lane): full 443-line ingest. §The-marshal-package-now-comprehensively-ingested across seven cycles (69 + 74 + 81 + 84 + 158 + 229 + 231). §The-encode-decode-pair with cycle 229 marshal-justin is now complete.
