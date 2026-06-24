---
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
ingested: 2026-05-29
ingested_by: scholar
section_count: 3
status: current
notes: |
  Ninth comment-fragment ingest. The SES-side V8-specific taming for
  Error.prepareStackTrace and the structured-stack-trace API — pairs
  structurally with cycle-87's pass-style/src/error.js V8-stack-
  accessor work (the pass-style side handles the *accessor channel*;
  this file handles the *prepareStackTrace method-surface channel*).
  Three coherent argument clusters: (1) 16-name CallSite method permit
  list (suppress getThis + getFunction + isPromiseAll + getPromiseIndex)
  + five filename-censor regexes (node_modules / node-internal /
  assert.js / eventual-send / ses-ava); (2) four ad-hoc regex patterns
  for path shortening (CALLSITE_ELLIPSIS_PATTERN1/2 +
  CALLSITE_PACKAGES_PATTERN + CALLSITE_FILE_2SLASH_PATTERN with
  VS-Code clickability rationale); (3) tameV8ErrorConstructor function
  with system-vs-user prepareFn distinction via WeakSet branding
  (prevent double-wrap on read-then-assign cycles), stackInfos WeakMap
  for lazy-stringification-with-caching, getStackString as TC39 Error
  Stacks shim start-compartment-only capability.
---

> Abstract: `packages/ses/src/error/tame-v8-error-constructor.js` is
> SES's V8-specific taming of the `Error.prepareStackTrace` /
> structured-stack-trace API surface. The file defines: an explicit
> *permit list* of 16 V8 CallSite methods that user-prepareFns may
> invoke (suppressing `getThis`, `getFunction`, `isPromiseAll`,
> `getPromiseIndex`); five *filename-censor regexes* that drop
> infrastructure frames from *concise* stack traces (node_modules,
> node:internal/, SES's own assert.js, the eventual-send shim,
> ses-ava); four *path-shortening regex patterns* with VS-Code-
> clickability rationale; and the `tameV8ErrorConstructor` function
> that wires censoring + shortening into V8's prepareStackTrace hook
> via the *system-vs-user prepareFn distinction* — system prepareFns
> see unattenuated SSTs; user prepareFns see only the safe permit-
> listed CallSite facets. A `systemPrepareFnSet` WeakSet brands every
> system prepareFn to prevent double-wrapping on read-then-assign
> cycles. `getStackString` is the start-compartment-only shim of the
> proposed TC39 *Error Stacks* special-power. Three TODOs surface
> known future-work: the *ridiculously expensive way to attenuate
> callsites*, *user-configurable FILENAME_CENSORS via lockdown
> options*, and *user-configurable CALLSITE_PATTERNS via lockdown
> options*.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [call-site-permit-list-and-filename-censors](../sections/endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors.md) | hardened-javascript, errors, capability-security | current |
| [callsite-path-shortening-patterns](../sections/endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns.md) | hardened-javascript, errors | current |
| [tame-v8-error-constructor-and-system-vs-user-preparefns](../sections/endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns.md) | hardened-javascript, errors, capability-security | current |

The 403-line file's argument-cluster distribution maps cleanly to three sections. Lines 23-122 are the permit list + filename censors → section 1. Lines 124-210 are the four CALLSITE patterns + shortenCallSiteString → section 2. Lines 212-end are the tameV8ErrorConstructor function with the system-vs-user prepareFn distinction → section 3.

## Provenance

- Fetched 2026-05-29 from `endojs/endo@816bc2574052e686bb14efd95e4709180f79cca6` via the local bare-clone.
- Last touched 2026-04-30 by Richard Gibson; the file's history is older (multiple contributors). The TODO comments and the agoric-sdk#2326 reference suggest substantial Mark Miller authorship in the original.
- Verified file existence and comment density via bare-clone listing (cycle 73 / 74 verify-bare-clone discipline): 403 lines / 145 comment lines (~35% density), one of the strongest comment-density candidates from cycle 92's `packages/ses/src/error/*.js` survey.
- **Ninth comment-fragment ingest**. The chosen file pairs structurally with cycle-87's pass-style/src/error.js V8-stack-accessor section: pass-style handles the *accessor channel* (one V8 stack-trace exposure); this file handles the *prepareStackTrace method-surface channel* (a complementary V8 stack-trace exposure). Together the two ingests cover the full SES + pass-style V8-stack-trace defensive surface.
