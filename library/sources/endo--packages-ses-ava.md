---
title: "@endo/ses-ava — Wrap AVA test with SES-aware error logging (deep stacks + unredacted traces)"
source-slug: endo--packages-ses-ava
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava
total-lines: 474 source (308 ses-ava-test.js + 162 command.js + 4 reexport-ava.js) + ~50 README
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
---

# @endo/ses-ava

Wraps AVA `test` functions to produce §SES-aware-error-logging — deep stacks of prior turns, unredacted stack traces, unredacted error messages. Bridges the AVA testing library and the SES causal-console substrate via a registered-symbol protocol on globalThis.

## Key design moves

- **§Registered-symbol-on-globalThis protocol** — `MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA` is the §cross-module coordination key; §third instance of cross-module-coordination-protocols in library.
- **§Privileged-API-on-start-compartment-only** — SES console-shim only puts it on globalThis if it's the start compartment.
- **§Experimental-API-flag-via-comment** with §single-intended-consumer + §co-maintenance-relationship.
- **§Feature-test-with-tolerate-absence-as-fallback** — graceful degradation when substrate is absent.
- **§virtualT-proxy via defineProperty-with-getter-setter-delegation** — §three-kinds-of-property-handling (accessor / function / data).
- **§logErrorFirst** — §three-cases (sync-throw + promise-reject + success); §THROWN-vs-REJECTED log-prefix distinction (sibling to cycle 90 track-turns).
- **§Intercept-without-changing-the-outcome** — the logger is a side-effect, not a transformation.
- **§Honest-disclosure-of-observable-difference** — delayed-rejection-equivalent-enough-for-testing.
- **§AVA-method-override-list** — seven-named-chainable-methods recursively wrapped.
- **§Pre-lockdown-freeze-with-named-correctness-argument** — fifth member of the family (cycles 132/146/154/199/219).
- **§Single-import-replaces-multiple** — `import test from '@endo/ses-ava/prepare-endo.js';` replaces two imports.
- **§devDependencies-not-dependencies** to avoid bundler bloating from AVA being a regular dependency.

## Section files

- [§registered-symbol-protocol + §feature-test + §virtualT-proxy + §logErrorFirst + §AVA-method-override-list + §pre-lockdown-freeze](../sections/endo--packages-ses-ava--registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze.md) — full source ingest covering ses-ava-test.js + command.js + README.

## Ingest scope

Cycle 219 (chat-lane): full ingest of the 474-line source package + README as one section. The package completes the §causal-console-substrate-is-fully-wired observation: cycles 90 + 93 + 96 + 98 + 100 + 106 + 217 + 219.
