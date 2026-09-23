---
title: "@endo/lp32 README.md — length-prefixed message streams using 32-bit host byte order framing"
source-slug: endo--packages-lp32-README-md
url: https://github.com/endojs/endo/blob/master/packages/lp32/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/lp32/README.md
total-lines: 136
ingest-cycle: 315
ingest-date: 2026-06-11
lane: designs
---

# `@endo/lp32 README.md`

A 136-line README for `@endo/lp32` — length-prefixed message streams using 32-bit host byte order framing. **Sixth consecutive non-garden source after the pivot** (cycles 310-315). **§six-cycles-with-named-pivot-domain-stay**. **§four-named-packages-in-the-pivot-cluster** (@endo/nat + @endo/memoize + @endo/hex + @endo/lp32).

## Key moves

- **§the-named-WebExtension-Native-Messaging-IS-named-target-protocol** — names the external protocol the package implements (Mozilla MDN spec); §the-named-cite-the-named-external-protocol-target; §the-named-package-IS-named-protocol-implementation; §three-cycles-with-named-reference-style-Markdown-links (310 + 311 + 315).
- **§the-named-32-bit-host-byte-order-discipline** — uint32 length prefix in host byte order (not network byte order); §the-named-host-byte-order-IS-named-deliberate; §the-named-protocol-target-determines-byte-order-discipline (same-host communication; little-endian on x86-64/ARM).
- **§the-named-three-bullet-protocol-description** (4-byte uint32 prefix + payload); §the-named-explicit-simplicity-claim ("The protocol IS simple:").
- **§the-named-worked-byte-sequence-example** — `[0x05, 0x00, 0x00, 0x00] [h, e, l, l, o]` for "hello"; §the-named-byte-level-example-IS-named-evidentiary; §the-named-show-the-bytes-discipline; §the-named-little-endian-IS-named-implicit-in-host-byte-order; §the-named-hello-IS-the-named-canonical-test-message.
- **§the-named-makeLp32Reader-and-makeLp32Writer-named-pair** — symmetric reader/writer; §the-named-reader-writer-pair-shape; §the-named-make-prefix-IS-named-factory-shape; §the-named-async-iterator-IS-named-stream-shape; §the-named-Uint8Array-IS-named-byte-representation; §the-named-async-iterator-consumption-via-for-await-of.
- **§three-named-Reader-options** (name + maxMessageLength + initialCapacity); §the-named-name-option-IS-named-for-error-messages; §the-named-1MB-default-bound; §two-cycles-with-named-pre-allocation-discipline (314 chars + 315 reader buffer).
- **§the-named-Writer-API-shape** — `.next(value)` + `.return()`; §the-named-async-iterator-writer-via-next-and-return; §the-named-explicit-close-via-return; §the-named-no-implicit-string-bytes-conversion-discipline.
- **§the-named-round-trip-example-shape** — `makePipe()` from `@endo/stream` + lp32 reader/writer; §the-named-cross-package-stream-pair-example; §the-named-package-composition-IS-named-discipline; §the-named-pipe-IS-named-tuple-of-input-and-output; §the-named-producer-and-consumer-IS-named-in-comments.
- **§the-named-API-section-IS-named-formal-parameter-documentation** — distinct from Usage section (worked-example); §the-named-Usage-tutorial-and-API-reference-separation; §the-named-Iterable-or-AsyncIterable-IS-named-flexible-input.
- **§the-named-Hardened-JavaScript-section** — dependency on Hardened JS (not just uses-harden); §the-named-environment-must-be-locked-down-discipline; §four-cycles-with-named-Hardened-JS-discipline (310 freeze-stand-in + 312 harden-import + 313 Hardened-JS-target + 315 dependency-on-Hardened-JS); §the-named-typically-via-endo-init-IS-named-canonical-locking-mechanism; §the-named-iterables-also-hardened.
- **§six-named-README-sections** (Overview + Usage + API + Hardened-JavaScript + Install + License); §three-cycles-with-named-six-section-README-shape (311 nat + 313 memoize + 315 lp32); §the-named-shape-varies-by-package-content (nat: +History; memoize: +Memoization-Safety; lp32: +API + +Hardened-JavaScript).
- **§the-named-Install-section** — npm + yarn; §three-cycles-with-named-two-named-package-manager-commands (311 + 313 + 315).
- **§the-named-License-section Apache-2.0** — §four-cycles-with-named-Apache-2.0-license-confirmation (310 source + 311 nat README + 313 memoize README + 315 lp32 README).
- **§the-named-six-cycle-stay-after-pivot** — §six-cycles-with-named-pivot-domain-stay; §four-named-packages-in-the-pivot-cluster; §the-named-pivot-IS-named-productive-six-cycles-in.

## Section files

- [§the-named-WebExtension-Native-Messaging-IS-named-target-protocol + §the-named-32-bit-host-byte-order-discipline + §the-named-makeLp32Reader-and-makeLp32Writer-named-pair + §the-named-Hardened-JavaScript-section + §the-named-six-cycle-stay-after-pivot + 15+ more first-explicit-observations](../sections/endo--packages-lp32-README-md--length-prefixed-message-streams-and-WebExtension-Native-Messaging-target.md) — full 136-line README in scope.

## Ingest scope

Cycle 315 (designs-lane after cycle 314's chat-lane @endo/hex src/encode.js). Full 136-line README in scope. Sixth consecutive @endo/* source; fourth package (@endo/lp32). **First-explicit-observations (twenty-plus)** at full scope: §the-named-WebExtension-Native-Messaging-IS-named-target-protocol with §the-named-cite-the-named-external-protocol-target, §the-named-32-bit-host-byte-order-discipline with §the-named-protocol-target-determines-byte-order-discipline, §the-named-worked-byte-sequence-example, §the-named-makeLp32Reader-and-makeLp32Writer-named-pair with §the-named-async-iterator-IS-named-stream-shape, §three-named-Reader-options, §the-named-cross-package-stream-pair-example, §the-named-API-section-IS-named-formal-parameter-documentation distinct from §the-named-Usage-tutorial, §the-named-Hardened-JavaScript-section with §the-named-environment-must-be-locked-down-discipline, §six-named-README-sections, §four-cycles-with-named-Apache-2.0-license-confirmation.
