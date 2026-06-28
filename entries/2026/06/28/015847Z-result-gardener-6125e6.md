---
kind: result
role: gardener
host: endolinbot
at: 2026-06-28T01:58:48Z
---
# result — capture-xsnap-debug-instrumentation-in-forks

Preserved the xsnap XS-vs-V8 stack-depth debug instrumentation from
`investigate-beta3-ymax0-xs-repro-and-fix` into bot-owned forks. No upstream
interaction, no PR.

## Branches pushed (bot forks only)

- **`kriscendobot/agoric-sdk`** branch `xsnap-debug-instrumentation`
  (commit `f41fa70`), files under `packages/xsnap/debug-instrumentation/`:
  - `scratch-xs-depth.mjs` — core: same probe inside a real xsnap worker, fresh
    worker per trial (XS overflow is uncatchable, aborts the worker).
  - `probe-v8.mjs` — V8 depth probe (passStyleOf / marshal / mustMatch).
  - `probe-raw.mjs` — Endo-free raw non-tail recursion + nested-record walk.
  - `endo-bisection/` — verbatim survivors from `/tmp/endo-beta2`
    (`probe.mjs`, `probe-entry.js`, `init-entry.js`, `es-shim-entry.js`,
    `package.json`).
  - `README.md` — measured limits table + the bin-shim build workaround.

- **`endojs/endo-but-for-bots`** branch `xsnap-stack-depth-bisection`,
  files under `debug-instrumentation/xsnap-stack-depth/`: the same verbatim
  beta2-vs-beta3 bisection set + a README documenting that Endo is ruled out as
  the cause (frames-per-level identical across beta2/beta3).

## Provenance

The agoric-sdk scratch clone (`/home/kris/agoric-sdk`) was GC'd; the three
top-level probes (`scratch-xs-depth.mjs`, `probe-v8.mjs`, `probe-raw.mjs`) are
faithful reconstructions from the investigation report's findings. The
`endo-bisection/` set survived in `/tmp/endo-beta2` and was captured verbatim.

## Measured limits preserved (host endolinbot)

XS native non-tail budget ≈ 350 frames; passStyleOf ≈ 115–127 levels; marshal
≈ 110; mustMatch/checkMatches ≈ 15 levels (the binding limit, ~23 frames/level).
V8 on the same host: 2047 / 1790 / 511. Attribution: NOT Endo (bisection);
fix is contract-side depth-bounding, not raising the XS stack.

## Follow-ups

- The open blocker from the investigation is unchanged and out of scope here: a
  v320 swing-store export (kvstore + heap snapshot at incarnation 70) is still
  needed to capture the real over-deep structure and ship a targeted fix.
- Commits are bot-identity (`endolinbot`); no upstream push, no PR, no comment.
