---
source: packages/ses/src/error/tame-console.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Fifteenth comment-fragment ingest. Mark S. Miller-authored SES
  *integration / top-level wiring* file — the one entry point
  (`tameConsole(...)`) that SES's lockdown.js calls; composes the
  earlier-cycle ingests (cycle 96's `makeCausalConsole`, cycle 98's
  `loggedErrorHandler`, cycle 100's `makeRejectionHandlers`) into
  a single configurable factory. The 197-line file is one cohesive
  argument-cluster — pick handler + derive original-console + 
  upgrade log-only + compose causal-console + wire platform error
  traps for Node and Browser. Four structurally interesting moves:
  (1) the *risk-minimizing-imports* discipline at the file top
  (*Using TypeError minimizes risk of exposing the feral Error
  constructor*) — surfaces the *don't-import-Error* invariant;
  (2) the *originalConsole gracefully-degrading three-tier
  fallback* — `globalThis.console` → `globalThis.print`-built
  five-method-log-stub for eshost SpiderMonkey → undefined;
  (3) the *avoid Parcel overweaning gaze* discipline —
  `globalThis.process` / `globalThis.window` instead of bare
  `process` / `window` because Parcel would install a `process`
  shim forcing sloppy-mode, which would break SES's strict-mode
  invariant; (4) the *canonical error-code prefix-with-link*
  discipline — `SES_UNCAUGHT_EXCEPTION:` and
  `SES_UNHANDLED_REJECTION:` prefixes link to canonical docs in
  `packages/ses/error-codes/`. This file completes the SES
  causal-console substrate (cycles 90 + 93 + 96 + 98 + 100 + 106).
  Single-section cohesion-honest ingest.
---

> Abstract: `packages/ses/src/error/tame-console.js` is the SES
> *integration / top-level wiring* file — the one entry point
> SES's `lockdown.js` calls. It composes `loggedErrorHandler` from
> cycle 98's `assert.js`, `makeCausalConsole` from cycle 96's
> `console.js`, and `makeRejectionHandlers` from cycle 100's
> `unhandled-rejection.js` into a single configurable factory.
> The file opens with the *don't-import-Error* invariant —
> *Using TypeError minimizes risk of exposing the feral Error
> constructor*. The §`tameConsole(consoleTaming, errorTrapping,
> unhandledRejectionTrapping, optGetStackString)` factory takes
> four parameters and performs five steps: (1) pick
> loggedErrorHandler (default or spread-extended with custom
> getStackString); (2) derive originalConsole via three-tier
> fallback (`globalThis.console` → `globalThis.print`-built
> five-method-log-stub for eshost SpiderMonkey → undefined);
> (3) upgrade a log-only console — when `originalConsole.log`
> exists but `warn`/`error` don't, define them as aliases via
> `wrapLogger`; (4) compose `ourConsole` —
> `makeCausalConsole(originalConsole, loggedErrorHandler)` from
> cycle 96 unless `consoleTaming === 'unsafe'` (in which case
> the original passes through); (5) wire platform-API error
> traps for Node.js and Browser. The §`globalThis.process` /
> `globalThis.window` (not bare) discipline avoids the
> *overweaning gaze of Parcel*, which would install a sloppy-
> mode-forcing `process` shim that breaks SES's strict-mode
> invariant. The §Node.js wiring registers
> `process.on('uncaughtException')` + `process.on('unhandledRejection')`
> + `process.on('rejectionHandled')` + `process.on('exit')`. The
> §Browser wiring registers `window.addEventListener('error')` +
> `addEventListener('unhandledrejection')` +
> `addEventListener('rejectionhandled')` +
> `addEventListener('beforeunload')`. The §five-mode errorTrapping
> enumeration: `platform`/`exit` call `process.exit(exitCode || -1)`;
> `abort` calls `process.abort`; `report` just logs; `none` skips.
> The §browser `about:blank` redirect for `exit`/`abort` modes.
> The §`SES_UNCAUGHT_EXCEPTION:` / `SES_UNHANDLED_REJECTION:`
> error-code prefixes link to canonical docs in
> `packages/ses/error-codes/`. The factory returns
> `{ console: ourConsole }` — extensible record shape.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [integration-wiring-and-platform-error-traps](../sections/endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps.md) | hardened-javascript, errors | current |

The 197-line file is honestly one cohesive argument-cluster — *one factory* that composes three previously-ingested substrates (`loggedErrorHandler`, `makeCausalConsole`, `makeRejectionHandlers`) and wires platform error traps. Single-section ingest preserves the integration story; forcing a multi-section split would create artificial divisions between the composition steps.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@86d983a0fbd1c16089953eecabaec28e85defed5` via the local bare-clone.
- Last touched 2025-05-12 by Mark S. Miller. Mark's authorship is consistent with his maintainer-role for the SES error-handling cluster.
- Verified file existence and structure via the local bare-clone: 197 lines / 45 comment lines (~24% comment density).
- **Fifteenth comment-fragment ingest**. The chosen file *completes* the SES causal-console substrate:
  - **Cycle 90** `track-turns.js` (Mark Miller) — causal annotations producer.
  - **Cycle 93** `tame-v8-error-constructor.js` (Richard Gibson) — getStackString capability.
  - **Cycle 96** `console.js` (Mark Miller) — causal-console rendering.
  - **Cycle 98** `assert.js` (Richard Gibson) — state + loggedErrorHandler bridge.
  - **Cycle 100** `unhandled-rejection.js` (Mathieu Hofman) — GC-driven rejection detection.
  - **Cycle 106** `tame-console.js` (Mark Miller, this ingest) — *integration / top-level wiring* — the file SES's `lockdown.js` calls.
- The six cycles together describe the *full SES error-observation surface from substrate to integration*.
- Single-section cohesion-honest count. The 197-line file is *one factory call* with five sequential steps. Forcing a 2-section split would create artificial divisions between the substrate-composition and the platform-API-wiring.
- Cycle 106 was scheduled for papers-lane but pivoted to comments-lane (fifth consecutive papers-lane block).
