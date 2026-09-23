---
title: §Name-for-error-diagnostics parameter
source-slug: endo--packages-hex
section-id: ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
url: https://github.com/endojs/endo/blob/master/packages/hex/src/
authors: [Endo contributors]
repo: endojs/endo
path: packages/hex/src/
status: shipping
ingest-cycle: 215
ingest-date: 2026-06-07
lane: chat
parent: endo--packages-hex--ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
---

```js
export const jsDecodeHex = (string, name = '<unknown>') => {
```

§Optional-name-defaults-to-'<unknown>'. The name appears in error messages:
- `Hex string must have an even length, got ${string.length} in string ${name}`
- `Invalid hex character at offset ${i * 2} of string ${name}`

§Caller-supplied-context-string for §debugging-which-file-or-stream-the-bad-hex-came-from. §Diagnostic-feedback-pattern that complements the cycle 198 §patterns-diagnostic-feedback work — both designs say §the-data-is-already-there-just-locked-include-it-in-the-error.
