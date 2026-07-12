---
order: serial
children: design-endo-inspect conduct-endo-inspect-design build-endo-inspect
on-child-failure: halt
state: pending
created_by: producer
created_at: 2026-07-12T16:46:34Z
---

# Orchestration: @endo/inspect — design, conduct to llm, build

Serial, halt-on-failure orchestration of the maintainer directive (kriskowal on
endojs/endo-but-for-bots#187 comment 4951950042, 2026-07-12): address the follow-up
by producing a design for an `@endo/inspect` package + SES-base shim, conduct it to
`llm`, and build it once landed.

Runs in sequence; halts if a step fails so a design/merge problem is not built past:

1. `design-endo-inspect` — designer (Fable): the `@endo/inspect` + `shim.js` design
   (SES-base `-C` incorporation, browser/node/xs behavior, non-triggering inspection
   under SES's missing Proxy brand check), tagging `@erights` + `@mhofman` and
   surfacing the Proxy-stamping issues as dependencies.
2. `conduct-endo-inspect-design` — conductor: conduct the design PR to `llm` once
   merge-ready (holds if still awaiting expert review).
3. `build-endo-inspect` — builder (Opus): implement `@endo/inspect` per the landed
   design, raised once the design lands on `llm`.
