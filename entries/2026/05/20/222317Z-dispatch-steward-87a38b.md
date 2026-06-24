---
ts: 2026-05-20T22:23:17Z
kind: dispatch
role: steward
to: fixer
dispatch_id: 87a38b
dispatch_root: /home/kris/dispatches/fixer--87a38b
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
---

# Dispatch fixer 87a38b — TS2352 in compartment.js blocks #75 lint

#75 CI `lint` job FAILURE: TS2352 conversion error at `packages/ses/src/compartment.js:363:21`:
`Conversion of type '(CompartmentOptionsArgs | LegacyCompartmentOptionsArgs)[]' to type 'CompartmentOptionsArgs | LegacyCompartmentOptionsArgs' may be a mistake because neither type sufficiently overlaps with the other. If this was intentional, convert the expression to 'unknown' first.`

This is likely a regression from a prior fixer (b2141e at 03:54Z which hand-fixed compartment.js JSDoc), or surfaced by an upstream typedoc/typecheck strictness bump. Fix the type cast properly. Plus 28 typedoc warnings — fix the structural `Failed to convert one or more packages` issue if related; standalone undocumented-reference warnings can be addressed separately.
