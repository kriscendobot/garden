---
title: "@endo/ses-ava — wrap AVA `test` with SES-aware error logging"
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

`@endo/ses-ava` wraps the AVA testing-library's `test` function so that test failures get §SES-aware-error-logging — §deep-stacks-of-prior-turns + §unredacted-stack-traces + §unredacted-error-messages. The load-bearing content is `src/ses-ava-test.js` (308 lines); there's also `src/command.js` (162 lines) as a multi-config CLI runner and `src/reexport-ava.js` (4 lines) as a passthrough.
