---
title: "@endo/errors — Public API for SES assert + Rejector + hideAndHardenFunction canonical definitions"
source-slug: endo--packages-errors
url: https://github.com/endojs/endo/tree/master/packages/errors
authors: [Endo contributors]
repo: endojs/endo
path: packages/errors
total-lines: 155 source (132 index.js + 23 rejector.js) + ~15 README
status: shipping
ingest-cycle: 217
ingest-date: 2026-06-07
lane: chat
---

# @endo/errors

The public-import-surface for SES's `assert` substrate. Re-exports the underlying `globalThis.assert` with renamed and split utility functions, conventional abbreviations, and the canonical definitions of `hideAndHardenFunction` and the `Rejector` typedef.

## Key design moves

- **§Public-API-for-SES-assert** — the package exists because §host-vs-guest-information-leaks-are-a-security-problem; provides §utilities-for-constructing-errors-with-redacted-messages.
- **§Resource-module-disclaimer** — depends on `globalThis.assert` being installed by SES first; §entangled-with-console for redaction-vs-debug-channel separation.
- **§Strict-fail-on-load-if-missing-prerequisite** with §error-message-tells-the-user-what-to-do.
- **§Enumerate-required-methods-and-tolerate-missing-ones** — §pre-1.13.0-SES-Agoric-bootstrap-vat-tolerance with §load-bearing-comment.
- **§Rename-utilities-split-from-assertions** via destructure + rest-spread.
- **§Honest-fallback-policy** — `bare = globalBare || quote`, `makeError = globalMakeError || globalError`.
- **§Conventional-abbreviations** (b/X/q) + **§named-aliases** (annotateError/redacted/throwRedacted).
- **§hideAndHardenFunction canonical definition** with §`__HIDE_`-prefix-protocol interlocking with cycle 93's stack-trace censor.
- **§Rejector canonical home** in rejector.js — §`cond || reject && reject\`...\`` three-line-idiom with §three-cases (truthy / false-reject / Fail-reject).
- **§Tests-as-illustrative-examples** — *See rejector.test.js for illustrative examples*.
- **§Two-channels-for-two-audiences** — thrown-Error (redacted; for caller) + console-log (full; for debugger).

## Section files

- [§public-API-for-SES-assert + §rename-utilities + §tolerate-missing-bare-and-makeError + §Rejector-canonical-home + §hideAndHardenFunction-canonical-definition](../sections/endo--packages-errors--public-API-for-SES-assert-with-renamed-utilities-and-tolerate-missing-bare-and-makeError-and-Rejector-canonical-home.md) — full source ingest covering index.js + rejector.js + README.

## Ingest scope

Cycle 217 (chat-lane): full ingest of the two-file source package + README as one section. The package is the public-API-surface that other @endo packages import the Rejector typedef and hideAndHardenFunction from. §Four-different-runtime-version-or-environment-compat-hacks family now four members (cycles 199 / 205 / 213 / 217).
