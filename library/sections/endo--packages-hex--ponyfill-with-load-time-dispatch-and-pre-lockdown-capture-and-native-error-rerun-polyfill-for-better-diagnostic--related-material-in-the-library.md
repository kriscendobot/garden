---
title: Related material in the library
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

- **cycle 7 @endo/base64**: §sibling-binary-encoding-utility; @endo/hex extends the pattern with native dispatch and precise offset diagnostics.
- **cycle 197 @endo/panic**: §three-layer-dispatch-chain-as-imperfect-ponyfill — both packages reach for native first, fall through to polyfill.
- **cycle 198 patterns-diagnostic-feedback**: §the-data-is-already-there-just-locked sibling — both designs include §extra-context-in-the-error-message-when-it-costs-nothing.
- **cycle 199 trampoline/memoize/nat trio**: §three-canonical-uncurry-shapes — `bind.bind(bind.call)` shape; @endo/hex uses `Reflect.apply` (the cycle 207 shape).
- **cycle 201 @endo/immutable-arraybuffer**: §ponyfill+shim sibling — both packages are §pre-Stage-4-TC39-fillers.
- **cycle 205 @endo/evasive-transform**: §SES-censorship-evasion sibling — both packages have §SES-aware-load-time-decisions.
- **cycle 207 @endo/env-options**: §pre-SES-prelude sibling — both packages capture intrinsics §before-lockdown.
- **cycle 211 @endo/common**: §ten-utility-files sibling — `@endo/hex` is a different shape (§two-files-tight-utility) but §similar-conscious-attention-to-tree-shakeability (only two files imported).
- **cycle 213 @endo/stream-node**: §Buffer-to-Uint8Array sibling — both packages live near §the-Uint8Array-byte-handling-layer.
