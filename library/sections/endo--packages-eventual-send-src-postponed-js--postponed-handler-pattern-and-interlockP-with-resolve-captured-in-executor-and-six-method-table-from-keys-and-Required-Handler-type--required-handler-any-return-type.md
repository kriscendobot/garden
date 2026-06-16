---
title: §Required<Handler<any>>-return-type
source-slug: endo--packages-eventual-send-src-postponed-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/postponed.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/postponed.js
total-lines: 46
ingest-cycle: 241
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type
---

§The-typedef-`[Required<Handler<any>>, () => void]` — §the-tuple-type-encodes-the-two-tuple-shape; §the-`Required<>`-wrapper-forces-every-optional-field-of-Handler-to-be-present-in-the-postponed-handler. §When-a-handler-protocol-has-optional-methods-but-a-particular-implementation-must-supply-all-of-them, §use-`Required<>`-to-encode-that-completeness-requirement-at-the-type-level. §Defense-by-construction-via-`Required<>`-wrapper — §the-TypeScript-checker-flags-a-missing-method + §the-implementation-cannot-silently-omit-a-method-the-protocol-allows-to-be-optional-elsewhere.

§The-`<any>`-parameter — §the-postponed-handler-doesn't-know-the-shape-of-the-target + §`any`-is-the-honest-type-when-the-target-is-genuinely-unknown.
