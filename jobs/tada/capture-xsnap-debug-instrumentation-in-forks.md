Both branches are live on the remotes and the inbox is empty. Work complete.

---

# Completion report — `capture-xsnap-debug-instrumentation-in-forks`

## What I did
Preserved the xsnap XS-vs-V8 stack-depth debug instrumentation from `investigate-beta3-ymax0-xs-repro-and-fix` into **bot-owned forks only**. No upstream interaction, no PR, no comment.

The original agoric-sdk scratch clone (`/home/kris/agoric-sdk`) had been GC'd, so the agoric-side probes were reconstructed from the investigation report's measured findings; the Endo bisection set survived in `/tmp/endo-beta2` and was captured **verbatim**.

## What changed (two bot-fork branches, both pushed, no PR)

1. **`kriscendobot/agoric-sdk`** → branch `xsnap-debug-instrumentation` (commit `f41fa70`), under `packages/xsnap/debug-instrumentation/`:
   - `scratch-xs-depth.mjs` — core instrumentation: same probe inside a real xsnap worker, fresh worker per trial (an XS overflow is uncatchable and aborts the worker).
   - `probe-v8.mjs` — V8 depth probe for `passStyleOf` / `marshal` / `mustMatch`.
   - `probe-raw.mjs` — Endo-free baseline (raw non-tail recursion + nested-record walk) to derive frames-per-level.
   - `endo-bisection/` — the verbatim survivors (`probe.mjs`, `probe-entry.js`, `init-entry.js`, `es-shim-entry.js`, `package.json`).
   - `README.md` — measured-limits table + the bin-shim build workaround (`node_modules/.bin/prebuild-install` for better-sqlite3, prebuilt `xsnap-worker`, "invoke the real build entry under node directly" rule).

2. **`endojs/endo-but-for-bots`** → branch `xsnap-stack-depth-bisection`, under `debug-instrumentation/xsnap-stack-depth/`: the same verbatim bisection set plus a README recording that the beta2→beta3 Endo bump is **ruled out** (frames-per-level identical: passStyleOf 2047/2047, marshal 1790/≈1791, mustMatch 511/511).

A `result` journal entry (`entries/2026/06/28/015847Z-result-gardener-6125e6.md`) names both branches and all captured files for later discovery.

## Guardrails honored
Commits are bot-identity (`endolinbot`); both clones had **only** the bot-fork remote (verified no upstream remote before each push); no `Agoric/agoric-sdk` or `endojs/endo` push, PR, comment, or cross-reference. Plain commit messages, no tests/CI/gamut. Temp clones cleaned up.

## Follow-ups
- Unchanged from the investigation and out of scope here: capturing the **real** over-deep structure still needs a **v320 swing-store export** (kvstore + heap snapshot at incarnation 70). The targeted fix remains contract-side depth-bounding below the ~15-level mustMatch/XS limit, not raising the XS stack.
