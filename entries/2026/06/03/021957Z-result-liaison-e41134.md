---
kind: result
role: liaison
host: endolin
refid: e41134
dispatched_at: 2026-06-04T02:00:00Z
completed_at: 2026-06-04T02:19:57Z
cycle: 179
lane: chat
---

# Cycle 179 — chat-lane: `@endo/lp32` reader/writer/host-endian

Ingested `endojs/endo/packages/lp32/{reader,writer}.js` (82 + 49
lines) and `packages/lp32/src/host-endian.js` (9 lines) as a
unified §sibling-encoding to cycle 177's
`netstring/reader.js`.

## Section file (cohesion-honest single section)

- `endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline.md`
  (~370 lines)
- Headline: **Host-endian length-prefix framing as same-host
  IPC discipline with single-buffer copyWithin shift**
- §The-single-most-structurally-interesting-move: §host-byte-
  order-as-deliberate-IPC-marker — protocol target is same-
  host (WebExtension Native Messaging stdio pipes), so
  endianness is moot and host byte order avoids per-message
  byte-swap on every modern (little-endian) platform.

## Topics worked

- `streams` (primary; added a new row to the topic table)
- `captp` (lp32 is a candidate transport substrate)

## Tier-1 borrowings worth re-noting

- §host-byte-order-as-deliberate-IPC-marker
- §runtime-endianness-probe (module-load Uint16/Uint8 trick)
- §single-growing-buffer-with-copyWithin-shift
- §"Must allocate to support concurrent reads" — §key-
  correctness-comment
- §1MB-default-matches-WebExtension-spec — §spec-conformance-
  even-in-defaults
- §symmetric-maxMessageLength-enforcement (reader and writer
  both)
- §single-shared-host-endian-constant — avoids the classic
  endianness-mismatch bug by construction

## Cohesion-honest sibling-comparison table

| Property                  | netstring (cycle 177)             | lp32 (cycle 179)                |
|---------------------------|-----------------------------------|---------------------------------|
| Length encoding           | ASCII decimal + colon             | uint32 binary                   |
| Length size               | Variable                          | Fixed 4 bytes                   |
| Endianness                | Irrelevant (ASCII)                | Host byte order                 |
| Self-describing on wire   | Yes                               | No                              |
| Sanity terminator         | Trailing `,`                      | None                            |
| Use case                  | CapTP-over-anything; daemon socket| WebExtension native messaging   |
| State machine             | Explicit two-state                | Implicit (length always at +0)  |
| Allocation strategy       | Two buffers; subarray fast-path   | Single growing buffer; slice    |
| Default `maxMessageLength`| 1 MiB                             | 1 MiB                           |

## Library counts after cycle 179

- 684 sections from 225 source documents.
- §designs-chat alternation maintained 14 cycles (166–179).
- §papers-lane blocked 73+ consecutive cycles.
- §small-files-with-large-knowledge-density family eighth
  member (cycles 165/167/169/171/173/175/177/179).

## Researcher-tracked-gaps status

No further direct progress on gaps 2/3/4 (still tracked in
`224238Z-message-liaison-44760a.md`). Cycle 179 picked freely
per the maintainer's standing instruction "Pick freely, but
track for future work."

## Self-pacing

Cycle 180 wakeup scheduled in 1500s. Pattern: cycle 180 should
be designs-lane (alternating from cycle 179's chat-lane).
