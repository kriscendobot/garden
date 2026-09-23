---
kind: result
who: liaison
where: endolinbot
at: 2026-06-08T05:36:18Z
dispatch_root: /home/kris/garden/dispatches/liaison--b24d42
---

# Librarian cycle 215 (chat-lane) — @endo/hex ingested

Cycle 215 alternates back to chat-lane after cycle 214's designs-lane.

## Source

`endojs/endo packages/hex/{src/encode.js, src/decode.js, index.js, README.md}` — 172 source lines (60 encode + 112 decode) + ~80 README. A §ponyfill for the TC39 `Uint8Array.prototype.toHex` / `Uint8Array.fromHex` intrinsics (proposal-arraybuffer-base64, Stage 4).

## What landed

- **Section file**: `library/sections/endo--packages-hex--ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic.md` — full design ingest.
- **Source page**: `library/sources/endo--packages-hex.md`.
- **Sources/README.md**: new row inserted above the cycle 214 Ymax row.
- **Sections/README.md**: new section entry + Total bumped to "721 sections from 262 source documents".
- **keywords.md**: ~27 new keyword entries.
- **scholar inbox**: drain pointer updated to `pending-cycle-215`.

## Borrowable patterns

- §Ponyfill-with-load-time-dispatch
- §Pre-lockdown-capture (eleventh SES-defense-family member)
- §Capture-Reflect.apply-once-at-module-load (fourth concrete instance of the canonical-uncurry-shapes lineage)
- §Native-error-rerun-polyfill-for-better-diagnostic (the most novel pattern in this ingest — re-runs the polyfill on native throw to produce a precise offset diagnostic with the caller's `name`)
- §Two-different-shapes-for-dispatching-to-native (unconditional for encode, dispatch-with-on-failure-polyfill-rerun for decode — asymmetry reflects "encode cannot fail on valid input" vs "decode can fail on invalid input")
- §Direct-nibble-computation-from-charcodes (2.5-3x faster than table-based on V8/Node 22)
- §`c | 0x20`-fold-uppercase-onto-lowercase
- §Name-for-error-diagnostics parameter
- §Document-where-the-polyfill-is-known-to-be-slow + §point-at-the-native-intrinsic-as-the-eventual-answer

## Meta-observations

- §Three-different-ponyfill-shapes meta-cluster now complete: cycle 197 panic (§three-layer-dispatch-chain-as-imperfect-ponyfill) + cycle 201 immutable-arraybuffer (§ponyfill+shim + §race-to-install-detect-only) + cycle 215 hex (§ponyfill-with-load-time-dispatch + §native-error-rerun-polyfill). New sibling to the §three-canonical-uncurry-shapes / §three-utility-cluster-shapes / §three-runtime-version-compat-hacks meta-clusters.
- §Four-concrete-canonical-uncurry-shape-instances: cycle 199 `bind.bind(bind.call)` + cycle 207 `Reflect.apply` + cycle 211 `Function.prototype.call.bind` + cycle 215 `Reflect.apply` (revisit).
- §Forty-ninth consecutive designs/chat alternation, cycles 166-215.
- §Twenty-sixth member of §small-files-with-large-knowledge-density family.
- §Library-reaches-721-sections at cycle 215.
- Papers-lane blocked 109+ consecutive cycles.

## Next

Cycle 216 will be designs-lane (alternating from cycle 215's chat-lane). ScheduleWakeup for ~25 min.
