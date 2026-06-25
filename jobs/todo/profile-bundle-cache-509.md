# Profile bundle-generation cache hot-files for endo-but-for-bots #509 (MAINTAINER-AUTHORIZED agoric-sdk one-off)

Maintainer ask on **#509** (mirror of endo#3099), zip-base64.js thread (kriskowal): *"I would like
to investigate what kinds of files get repeatedly read in this cache. **Please profile agoric-sdk
bundle generation and provide a report.**"*
https://github.com/endojs/endo-but-for-bots/pull/509 (`packages/bundle-source/src/zip-base64.js`)

## AUTHORIZATION (read this — it overrides the standing scope rule for THIS task only)

The standing rule is "never do anything for agoric-sdk autonomously." **The maintainer
(kriskowal) has explicitly authorized THIS one-off, READ-ONLY profiling run on their authority
(2026-06-25).** Scope of the authorization: **clone + run + profile agoric-sdk's bundle
generation, then report.** Do **NOT** take any other action on agoric-sdk — no PRs, no commits,
no merges, no issue/comment activity on the agoric-sdk repo. This is a bounded profiling
exception, not a general widening of scope. Wear the **assayer/investigator** role. Route all
scratch through `$GARDEN_SCRATCH` (or a temp dir); do not pollute the live tree.

## The goal

Find **which files are repeatedly read from the `@endo/bundle-source` cache** (the cache in
`packages/bundle-source/src/zip-base64.js`) during real bundle generation — the cache "hot-files"
— and report read counts + analysis, so the maintainer can see what the cache re-reads.

## Method (primary: agoric-sdk)

1. Clone `Agoric/agoric-sdk` (public — `git ls-remote` confirms access). Install/build enough to
   exercise its **bundle generation** (agoric-sdk generates many SwingSet/contract bundles via
   `@endo/bundle-source`).
2. **Instrument the bundle-source cache** to record every file read and a per-file count — use the
   `@endo/bundle-source` from #509's branch (`endojs/endo-but-for-bots`, which carries the
   zip-base64.js work) linked into agoric-sdk, with read-logging added to the cache path (or a
   wrapper). Keep the instrumentation read-only.
3. Run the bundle generation; collect the cache-read stats. **Capture heavy build/trace output
   SILENTLY into the git content store** (`git hash-object -w`) per the local-verify discipline —
   distill the report from it; do not dump raw logs into context.
4. Identify the **repeatedly-read files** (the hot-files), with counts, and characterize them
   (node_modules deps re-read across bundles? the same source re-zipped? etc.).

## Fallback (Endo bundles as proxy — if agoric-sdk can't be stood up)

If you **cannot authenticate a clone** of agoric-sdk or cannot feasibly stand up/run its bundle
generation (heavy build, install/submodule failure), **use bundles in Endo as a proxy** (the
maintainer authorized this fallback): profile `@endo/bundle-source` bundling over a representative
set of Endo packages instead, to surface the same cache-read behavior. **State clearly which
target you used** and that the Endo run is a proxy.

## Report

A profiling report: the repeatedly-read cache files (with read counts), the analysis of what the
cache re-reads and why, and any actionable takeaway for the zip-base64 cache. Post it as a
**comment on #509** (reply on the zip-base64.js thread) and in the journal. Note whether it
profiled agoric-sdk or the Endo proxy.

## Definition of done

Bundle-generation cache hot-files profiled (agoric-sdk if feasible, else the Endo-bundles proxy),
a report with read counts + analysis posted on #509 and the journal, the agoric-sdk run kept
strictly read-only per the authorization. Report which target was used and the top hot-files. If
neither agoric-sdk nor the Endo proxy can be run, report the precise blocker.

Posted by the liaison on behalf of the maintainer (explicit one-off agoric-sdk authorization).
