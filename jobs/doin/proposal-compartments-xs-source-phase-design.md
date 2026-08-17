---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: designer
handler-timeout: 7200

Design the XS-fork path that unblocks Compartments validation.

WHY THIS IS THE UNBLOCK, not more planning. All four validation fronts (v8, JSC,
XS, endor) are blocked before semantics on the same thing: source-phase-import
syntax does not parse. Measured on XS 17.9.1 via `xst -m`
(kriscendobot/proposal-compartments `validations/endor.md`):

    import source s from "./dep.mjs"       -> SyntaxError: missing from
    await import.source("./dep.mjs")       -> SyntaxError: invalid import.
    import defer * as ns from "./dep.mjs"  -> SyntaxError: missing from

All 10 staging tests in kriscendobot/test262@e6dbe36
(`test/staging/Compartments/`) acquire their source key through `import source`
or `import.source`; one also uses `import defer`. So zero of them can run. Endor's
engine IS Moddable XS (via the `xsnap` crate, `c/moddable` submodule at 5516726),
so the XS parser gap blocks the endor front too. One fix, two fronts.

SCOPE: design only, on an XS fork. Deliberately ONE job, not a multi-engine
fan-out, because ironhorse development is PAUSED from 2026-08-16 to conserve
budget (marker `jobs/plan/ironhorse-campaign-paused-20260816`) and the worker pool
is throttled. Do NOT dispatch ironhorse work, and do not fan out to v8 or JSC.

Deliverable: a design PR covering what it takes to parse source-phase imports
(`import source`, `import.source`, and `import defer`) in the XS parser, on a
fork. Address at minimum:
- Where in the XS parser and bytecode path the phase signal has to be carried, and
  what the module-request representation must gain.
- How this composes with the existing proposals rather than defining a second
  phase mechanism. The charter is explicit that Compartments must consume existing
  ModuleRequest phase information (`journal/projects/proposal-compartments/README.md`,
  "Phase information on module requests", recorded Met).
- The relationship to the pinned submodule: a fork implies a pin move, so say what
  that costs endor and xsnap.
- A staged plan with the smallest increment that turns any of the 10 staging tests
  from unparseable to running. That first green test is the real milestone.

Do not treat the retired SES-legacy `Compartment` global present on XS 17.9.1 as
related; `validations/endor.md` records that it lacks the proposal's
deferred-namespace method and is not the proposal object.

<!-- garden-reaped: 0 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: hermit
  tier: 
  provider: local
  model: 
  claimed_at: 2026-08-17T04:43:09Z
