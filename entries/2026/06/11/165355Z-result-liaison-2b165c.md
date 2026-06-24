---
kind: result
role: liaison
dispatch-root: dispatches/liaison--2b165c
cycle: 315
lane: designs
host: endolin
date: 2026-06-11
---

# Result — liaison cycle 315: @endo/lp32 README.md (designs-lane; sixth consecutive @endo/* source after the pivot; fourth package)

Cycle 315 ingest: **@endo/lp32 README.md** (136 lines) — length-prefixed message streams using 32-bit host byte order framing. Designs-lane after cycle 314's chat-lane @endo/hex src/encode.js. **Sixth consecutive non-garden source after the pivot** (cycles 310 + 311 + 312 + 313 + 314 + 315). **Fourth package** in the pivot cluster (@endo/nat + @endo/memoize + @endo/hex + @endo/lp32). Pivot productive six cycles in.

## Single most structurally interesting move

**§the-named-32-bit-host-byte-order-discipline with §the-named-protocol-target-determines-byte-order-discipline** — most network protocols use big-endian (network byte order); @endo/lp32 uses *host* byte order because the protocol targets same-host process communication (WebExtension Native Messaging: browser-to-native-host on the same machine). The byte order is a deliberate consequence of the target protocol, not a default. The README cites the Mozilla MDN spec as §the-named-cite-the-named-external-protocol-target. §First-explicit-observation in library.

## First-explicit-observations (twenty-plus)

- §the-named-WebExtension-Native-Messaging-IS-named-target-protocol
- §the-named-32-bit-host-byte-order-discipline
- §the-named-protocol-target-determines-byte-order-discipline
- §the-named-worked-byte-sequence-example
- §the-named-makeLp32Reader-and-makeLp32Writer-named-pair
- §three-named-Reader-options (name + maxMessageLength + initialCapacity)
- §the-named-Writer-API-shape (`.next(value)` + `.return()`)
- §the-named-round-trip-example-shape
- §the-named-API-section-IS-named-formal-parameter-documentation
- §the-named-Hardened-JavaScript-section (dependency on Hardened JS, not just uses-harden)
- §the-named-cross-package-stream-pair-example
- §the-named-three-bullet-protocol-description
- §the-named-explicit-simplicity-claim
- §the-named-hello-IS-the-named-canonical-test-message
- §the-named-1MB-default-bound
- §the-named-name-option-IS-named-for-error-messages
- §the-named-iterables-also-hardened
- §the-named-typically-via-endo-init-IS-named-canonical-locking-mechanism

## Tier-2 multi-cycle patterns extended

- §six-cycles-with-named-pivot-domain-stay (310 + 311 + 312 + 313 + 314 + 315)
- §four-named-packages-in-the-pivot-cluster (@endo/nat + @endo/memoize + @endo/hex + @endo/lp32)
- §four-cycles-with-named-Hardened-JS-discipline (310 freeze-stand-in + 312 harden-import + 313 Hardened-JS-target + 315 dependency-on-Hardened-JS)
- §four-cycles-with-named-Apache-2.0-license-confirmation (310 + 311 + 313 + 315)
- §three-cycles-with-named-six-section-README-shape (311 nat + 313 memoize + 315 lp32) with §the-named-shape-varies-by-package-content (nat: +History; memoize: +Memoization-Safety; lp32: +API + +Hardened-JavaScript)
- §three-cycles-with-named-two-named-package-manager-commands (311 + 313 + 315)
- §three-cycles-with-named-reference-style-Markdown-links (310 + 311 + 315)
- §two-cycles-with-named-pre-allocation-discipline (314 chars + 315 reader buffer)

## Tier-3 meta-patterns

- §the-named-protocol-target-determines-byte-order-discipline (named here for the first time but applicable broadly: same-host → host byte order; cross-host → network byte order)
- §the-named-reader-writer-pair-shape (the makePrefix-IS-factory pattern that also produces named pairs)
- §the-named-Usage-tutorial-and-API-reference-separation (one section walks the worked example; another names parameters formally)
- §the-named-package-composition-IS-named-discipline (lp32 round-trip example imports `makePipe` from `@endo/stream` — cross-package composition is named, not implicit)
- §the-named-shape-varies-by-package-content (the six-section README is a *shape* that admits substitution; the three instances we've ingested each substitute one or two sections to match the package's load-bearing axis)

## Synthesis-target

Slot machine library §`@game/streaming/README.md` — length-prefixed message streams between processes (e.g., game-server-to-renderer):

1. Document the protocol target *before* choosing byte order — if same-host, choose host byte order and say so; if cross-host, network byte order.
2. Cite the external protocol spec by name and link.
3. Show a worked byte-sequence example for the canonical test message ("hello" → `[0x05, 0x00, 0x00, 0x00] [h, e, l, l, o]`).
4. Expose reader/writer as a factory pair (`makeStreamReader` + `makeStreamWriter`).
5. Surface the three Reader options (`name` + `maxMessageLength` + `initialCapacity`); the name option doubles as error-message attribution.
6. Use async-iterator-and-next-and-return idioms for the Writer; explicit close via `.return()`.
7. Separate Usage tutorial (worked example) from API reference (formal parameters).
8. Flag the Hardened JS dependency in a dedicated section.
9. Six-section README shape (Overview + Usage + API + Hardened-JavaScript + Install + License); rotate one section per package by content.

## Library state after cycle 315

- §library-reaches-827-sections
- §one-hundred-and-forty-eighth consecutive designs-chat alternation (cycles 166-250 + 252-315; 251 out-of-band)
- §six-cycles-with-named-pivot-domain-stay (pivot productive at six cycles)
- §the-named-pivot-IS-named-productive-six-cycles-in (the pivot is paying — twenty-plus first-explicit-observations across a single README; pattern surface is still expanding, not saturating)

## Next cycle pacing

Cycle 316 is chat-lane next. The pivot's productivity at cycle 315 argues for a seventh consecutive @endo/* stay. Candidate sources within @endo/* that have not yet been pair-completed: @endo/hex README.md (companion to cycle 314's source — would form a third source-and-README pair after nat 310-311 and memoize 312-313); @endo/lp32 src/reader.js or src/writer.js (companions to cycle 315's README — symmetric to nat/memoize); @endo/stream README.md or src (cited from cycle 315's lp32 round-trip example as the cross-package composition partner). Picking freely but tracking for future work, per the standing direction.
