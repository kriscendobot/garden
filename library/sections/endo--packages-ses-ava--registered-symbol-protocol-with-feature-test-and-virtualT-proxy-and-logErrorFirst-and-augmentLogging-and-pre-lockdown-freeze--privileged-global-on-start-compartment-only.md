---
title: §Privileged-global-on-start-compartment-only
source-slug: endo--packages-ses-ava
section-id: registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava/src/{ses-ava-test.js, command.js, reexport-ava.js}
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-ses-ava--registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
---

§The-honest-comment names the security envelope:

> `makeCausalConsoleFromLoggerForSesAva` is privileged because it exposes unredacted error info onto the `Logger` provided by the caller. It should not be made available to non-privileged code.
>
> [...] it *assumes* is the global of the start compartment and is therefore allowed to hold powers that should not be available in constructed compartments.

§Borrowable-pattern: §privileged-API-on-globalThis-of-start-compartment-only + §rely-on-SES-Compartment-isolation-to-keep-it-out-of-guest-compartments. §The-start-compartment-is-the-only-place-with-this-capability; §guest-compartments-don't-see-it.

§Sibling-to:
- cycle 98 ses/error/assert.js: §loggedErrorHandler-as-narrow-gate-to-mutable-state.
- cycle 96 ses/error/console.js: §causal-console-renderer that this API exposes.
- cycle 217 @endo/errors: §two-channels-for-two-audiences (redacted-thrown + full-console).

§The-causal-console-substrate-is-fully-wired-now: cycle 90 (track-turns producer) + cycle 93 (V8 stack-attenuation) + cycle 96 (console renderer) + cycle 98 (loggedErrorHandler bridge) + cycle 100 (rejection tracking) + cycle 106 (top-level tameConsole integration) + cycle 217 (@endo/errors public API) + cycle 219 (@endo/ses-ava test-time consumer).
