---
title: Related material in the library
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

- **cycle 90 ses/error/track-turns.js**: §causal-console-annotation-producer; §THROWN-vs-REJECTED log distinction sibling.
- **cycle 93 ses/error/tame-v8-error-constructor.js**: §stack-trace-taming; §unredacted-stack-traces depend on this.
- **cycle 96 ses/error/console.js**: §causal-console-renderer; §the-API exposed via the registered-symbol-on-globalThis.
- **cycle 98 ses/error/assert.js**: §loggedErrorHandler-as-narrow-gate-to-mutable-state.
- **cycle 100 ses/error/unhandled-rejection.js**: §GC-driven-rejection-tracking sibling.
- **cycle 106 ses/error/tame-console.js**: §top-level-tameConsole-integration; this package is one of its downstream consumers.
- **cycle 197 @endo/panic**: §registered-symbol-as-cross-module-coordination sibling (first instance of the pattern).
- **cycle 215 @endo/hex**: §graceful-degradation-when-substrate-absent sibling; §pre-lockdown-capture sibling.
- **cycle 217 @endo/errors**: §`__HIDE_`-prefix-protocol sibling (second instance of cross-module-coordination); §two-channels-for-two-audiences exposed here at test time.
- **cycle 218 familiar-chat-weblet-hosting**: §experimental-API-flag-via-comment + §two-document-coordination siblings.
- **cycles 132 + 146 + 154 + 199**: §freeze-not-harden-with-named-correctness-argument family; cycle 219 is the fifth member.
