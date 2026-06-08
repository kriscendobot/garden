---
kind: result
who: liaison
where: endolinbot
at: 2026-06-08T08:13:40Z
dispatch_root: /home/kris/garden/dispatches/liaison--800eea
---

# Librarian cycle 220 (designs-lane) — familiar-localhttp-protocol ingested

Cycle 220 alternates back to designs-lane after cycle 219's chat-lane (@endo/ses-ava). §Fifty-fourth consecutive designs-chat alternation cycle. Cycle 220 closes the cycle 218 parent-child design pair by ingesting the §parent-with-ready-infrastructure that cycle 218 referenced.

## Source

`endojs/endo-but-for-bots designs/familiar-localhttp-protocol.md` — 636 lines, Status **Partially implemented** (Familiar-side Ready in five named modules; Chat-side and Layer-6 Not Yet). Defines the `localhttp://` custom protocol scheme with six-layer defense-in-depth for in-Familiar weblet hosting.

## What landed

- **Section file**: `library/sections/endo-but-for-bots--llm-designs-familiar-localhttp-protocol--six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner.md`.
- **Source page**: `library/sources/endo-but-for-bots--llm-designs-familiar-localhttp-protocol.md`.
- **Sources/README.md**: new row above cycle 219.
- **Sections/README.md**: new section + Total → "726 sections from 267 source documents".
- **keywords.md**: ~46 new keyword entries.
- **scholar inbox**: drain pointer updated to `pending-cycle-220`.

## Borrowable patterns

- §Six-layer-defense-in-depth with §named-attack-per-layer (CSP / request interception / DNS poisoning / navigation delegate / WebRTC disabled / iframe sandbox).
- §Invalid-DoH-as-DNS-poisoning with §correctness-argument naming each traffic pattern that still works.
- §Belt-and-suspenders-flags (three Chromium flags layered on DoH misconfiguration).
- §Name-the-out-of-band-channel-that-bypasses-your-primary-defense (WebRTC ICE-candidate exfiltration).
- §Runtime-verification where §the-test-that-it-fails-IS-the-verification (canary DNS resolution).
- §Non-blocking-yellow-banner; §detected-via-platform-API; §the-warning-banner-only-appears-when-the-defense-was-supposed-to-be-active.
- §Three-state-status section (Partially implemented + Not yet implemented + Design deviations from implementation).
- §Design-deviations-section where the design tracks its own divergence from the implementation (§nineteenth honest-design-evolution-record shape).
- §Research-needed-section as honest-acknowledgment-of-incomplete-verification.
- §Open-Questions: (None remaining.) as §explicit-empty-section-as-completeness-signal.
- §Two-different-sections-for-two-different-classes-of-uncertainty (Research-needed = verification; Open-Questions = decision).
- §Implementation-status-per-package; §the-design-document-doubles-as-a-progress-tracker.
- §Zero-copy-via-transfer-list (the `[buffer]` transfer list moves ownership).
- §Why-WebSocket-doesn't-work-from-localhttp with §two-named-reasons (CSP + the protocol.handle scope).
- §Threat-modeling-as-design-driver (numbered attacks vs goals).

## Meta-observations

- §Cycle 220 closes the cycle 218 parent-child design pair. Cycle 218's §two-part-status referenced this design's Familiar-side infrastructure as Ready; cycle 220 ingested the parent.
- §Five-cycles-on-confinement now: cycle 196 endoclaw + cycle 200 worker-rust-xs + cycle 212 outliner + cycle 218 familiar-chat-weblet-hosting + cycle 220 familiar-localhttp-protocol. Cycle 220 is the §multi-layer-synthesis — names the six-layer-stack-of-confinement rather than a single substrate.
- §Seven-Familiar-cluster-designs in library after cycle 220 with §three-different-status-values (shipped + Not Started + Partially implemented).
- §Nineteenth-honest-design-evolution-record family member with a new shape (§design-deviations-section).
- §Four-different-shapes-of-design-evolution-record in 2026-06 cluster: cycle 214 (within-document self-correcting prose) + cycle 216 (parent-Complete + child-Not-Started extraction) + cycle 218 (sibling-Ready + this-Not-Started two-part-Status) + cycle 220 (three-state-Status + design-deviations-section).
- §Two-different-zero-copy-patterns in library: cycle 213 stream-node (Buffer-to-Uint8Array sharing underlying ArrayBuffer) + cycle 220 familiar-localhttp-protocol (`[buffer]` transfer list moves ownership).
- §Three-cycles-with-ASCII-illustration in 2026-06: cycles 214 (tree) / 218 (UI mockup) / 220 (flow diagram).
- §Library-reaches-726-sections at cycle 220.
- Papers-lane blocked 114+ consecutive cycles.

## Next

Cycle 221 will be chat-lane (alternating from cycle 220's designs-lane). ScheduleWakeup for ~25 min.
