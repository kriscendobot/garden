# symbolicated XS overflow stack trace + beta2 regression cross-check (ymax0 v320, garden #9)

Map: **investigate** → deepen the xsnap stack-overflow instrumentation to emit a
human-readable JS-level stack trace at the overflow point, reproduce it, and
confirm the regression against beta2.

Source: maintainer directive on kriskowal/garden issue #9
(https://github.com/kriskowal/garden/issues/9#issuecomment-4835251662). Routed by
the attention-triage gardener for job `kriskowal-garden-pr9-8e3123c4`.

## The ask (verbatim intent)

The maintainer wants **a stack trace that contains function names, file names, and
ideally line numbers at the point where the xsnap worker overruns its meter** (the
ymax0 v320 70->71 upgrade XS value-stack overflow, exit 12). Prior rounds produced
value-stack *width* histograms, a C-level frame chain with per-frame slot spans, a
depth-ceiling harness, and the `hex.js` `flatMap` smoking gun — but **not** a
symbolicated JS call stack (function + file + line per frame). Deliver that.

Specifically:
1. **Deepen the existing instrumentation** so the overflow dump resolves, per XS
   stack frame: the **function name**, the **script file name / module specifier**,
   and the **line number**. The current instrumentation
   (`kriscendobot/xsnap-pub#2`, branch `debug/xs-stack-overflow-trace`, the
   `XS_STACK_OVERFLOW_EXIT` arm of `fxAbort()` in
   `xsnap/sources/xsnapPlatform.c`) already walks the XS frame chain and prints a
   per-frame slot span plus a source line, plus an allocation-free `execinfo`
   native C backtrace. Extend the per-frame walk to dereference each frame's
   function instance to its code/debug info and print name + path + line. (XS
   surfaces these via the function instance's code and its `path`/`line`
   debugging fields; consult the XS sources on the fork branch for the exact
   accessors.)
2. **Reproduce** on the real v320 `bundle-ymax0` (`endoZipBase64`, beta3 Endo) to
   capture the symbolicated overflow trace.
3. **Verify the regression** by running the **same** reproduction steps on
   **beta2** Endo. Beta2 is expected NOT to overflow (exit 0); capturing its
   peak/near-limit frame chain for side-by-side comparison with beta3's overflow
   trace is the regression evidence. State plainly whether beta2 reproduces or not.
4. Optional, only if the direct frame walk is insufficient: the maintainer
   suggests **novel instrumentation that simply logs calls and stack push/pop**, or
   **rigging the xsnap debugger protocol** (similar to what Endo Rust / `endor`
   does). Treat these as fallbacks, not the first move — the in-`fxAbort` frame
   walk is the cheaper path and is already partway there.

## Context you should not re-derive (prior rounds)

- The overflow is a value-stack **width** exhaustion at the on-chain default
  `stackCount = 4096`, aborting at ~9 frames, NOT a depth problem (depth ceiling
  measured ~50 nested levels). Dominant frame: `@agoric/internal/src/hex.js`
  `decodings` `flatMap` (~1247 ref slots), co-resident on the ~2575-slot flattened
  functor scope.
- The from-source instrumented worker and build methodology are durable on the bot
  forks: engine instrumentation in `kriscendobot/xsnap-pub#2`
  (`debug/xs-stack-overflow-trace`), build/run methodology + findings in
  `kriscendobot/agoric-sdk#6` (`debug/xs-stack-overflow-methodology`,
  `packages/xsnap/doc/xs-stack-overflow-debugging.md`). Read that doc first — it
  records the `xsnap-worker.mk` build (gcc-13 shim, remove-prebuilt-symlink-first)
  and the fd-3/4 netstring run procedure.
- Memory note `reference_xsnap_xs_repro_without_agoric_build` records the
  export-free repro recipe (prebuilt `xsnap-worker` 0.14.2 = inherent
  `stackCount = 4096`, ~120-line netstring driver, exit 12 = stack overflow, SES
  via `bundle-source` endoScript of `@endo/init`). Scratch caches (`/tmp/xs6`,
  `~/.cache/garden-scratch/exp6-ymax0/`) are wiped by redeploys, so the worker +
  bundle + driver may need regenerating from the fork SHAs; the prior runs found
  the toolchain sometimes survived, so check before rebuilding.

## Deliverables

- The captured **symbolicated overflow stack trace** (function + file + line per
  frame) for beta3, posted as a comment on kriskowal/garden issue #9 (the
  maintainer's channel for this issue-scoped work), with the beta2 cross-check
  result stated.
- Instrumentation deepening committed to the bot fork branch
  `kriscendobot/xsnap-pub` `debug/xs-stack-overflow-trace` (DRAFT PR #2), and the
  result captured durably in the methodology doc on
  `kriscendobot/agoric-sdk#6`.
- Update the `reference_xsnap_xs_repro_without_agoric_build` memory with the
  symbolication accessors and any new repro steps.

## Scope (hard limits)

- **Bot forks only**: `kriscendobot/xsnap-pub`, `kriscendobot/agoric-sdk`. Clone,
  branch, build, run, read-only analysis are in scope (agoric-sdk fork
  experimentation is authorized per roles/COMMON.md § External-repo etiquette,
  *Project scope: agoric/agoric-sdk*).
- **Nothing upstream**: no comments, reviews, reactjis, opens/edits/closes, merges,
  or cross-links against `agoric/agoric-sdk` or `Moddable-OpenSource/moddable`.
  Keep all PRs DRAFT and fork-internal (no un-draft / judge / conductor chain).
- The only outward communication authorized is the **report comment on garden
  issue #9** (the issue is the garden's own repo; the maintainer asked for the
  trace there). Leave the issue **open** for the maintainer to close.
- The v320 swing-store **export** path (production live-rehydration cross-check)
  remains maintainer-only; do not attempt it.

---
claim:
  host: endolinbot2
  gardener: 36
  claimed_at: 2026-06-29T17:29:51Z
