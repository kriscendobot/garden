---
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
ingested: 2026-05-29
ingested_by: scholar
section_count: 3
status: current
notes: |
  Tenth comment-fragment ingest. Mark S. Miller-authored SES causal-
  console core — *the* file that renders structured errors with cause-
  chain + AggregateError + notes + sub-error nesting. Pairs with cycle
  90's track-turns.js (which produces the annotations) and cycle 93's
  tame-v8-error-constructor.js (which provides getStackString). Three
  argument-cluster sections capture: (1) the no-special-privilege
  design axiom + permit lists; (2) the logging console buffer +
  causal console core + logError render-sequence; (3) the AVA t.log
  adapter + horrible-kludge indent management + severity-gated
  filterConsole. The three sources (track-turns / tame-v8 / console)
  together describe the full SES causal-console rendering pipeline.
---

> Abstract: `packages/ses/src/error/console.js` is SES's *causal-console*
> module — *the* file that renders structured errors with their full
> cause-chain + AggregateError aggregation + post-construction notes +
> nested sub-errors. The module operates without special privilege
> (does not reference the realm's free variable `console`); it
> *receives* a `baseConsole` argument and wraps it. The opening
> permit lists enumerate which console methods this module knows how
> to wrap (9 level methods + 10 other methods, cross-platform-
> consensus-sourced). The core *makeCausalConsole(baseConsole,
> loggedErrorHandler)* function wraps each method to swap Error
> arguments for `(errorTag)` strings while queueing the actual errors
> for nested rendering. The *logError* function renders one error
> with all its annotations: message (with the *most-informative-
> message* rule that uses messageLogArgs over `error.message` when
> available), stack (via getStackString from cycle-93's tame-v8),
> cause, errors (AggregateError aggregation), notes (from cycle-90's
> track-turns), then recursively the sub-errors. The
> *makeLoggingConsoleKit* + *pumpLogToConsole* pair provides delayed-
> application buffering for tests. The *defineCausalConsoleFromLogger*
> adapter wraps an AVA `t.log`-style single-function logger into a
> full VirtualConsole + applies makeCausalConsole. The
> *indentAfterAllSeps* function is candidly named a *horrible kludge*
> with an explicit TODO. The *filterConsole* severity-gates via
> `filter.canLog(severity)` with a TODO for optional-topic-string.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [no-special-privilege-prelude-and-console-method-permit-lists](../sections/endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists.md) | hardened-javascript, errors | current |
| [logging-console-causal-console-and-error-info-rendering](../sections/endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering.md) | hardened-javascript, errors | current |
| [causal-console-from-logger-and-filter-console](../sections/endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console.md) | hardened-javascript, errors, testing | current |

The 541-line file decomposes into three argument-cluster sections. Lines 1-157 are prelude + permit lists → section 1. Lines 159-415 are makeLoggingConsoleKit + pumpLogToConsole + makeCausalConsole + logError → section 2. Lines 417-541 are defineCausalConsoleFromLogger + indentAfterAllSeps kludge + filterConsole → section 3.

## Provenance

- Fetched 2026-05-29 from `endojs/endo@e02b0f66eb44306c3d739e1670114ef24d4202fa` via the local bare-clone.
- Last touched 2026-01-02 by Mark S. Miller — the file's author. Mark's authorship is appropriate given the SES causal-console is a canonical Mark-designed artifact.
- Verified file existence and comment density via bare-clone listing: 541 lines / 212 comment lines (~39% density), one of the strongest comment-density candidates from cycles 92-95's `packages/ses/src/error/*.js` surveys.
- **Tenth comment-fragment ingest**. The chosen file *completes* the SES causal-console-rendering pipeline:
  - **Cycle 90** `track-turns.js` (Mark Miller) — produces causal annotations on errors.
  - **Cycle 93** `tame-v8-error-constructor.js` (Richard Gibson) — provides `getStackString` capability with V8-attenuation.
  - **Cycle 96** `console.js` (Mark Miller, this ingest) — renders the structured errors with cause/errors/notes/sub-errors.
- Together the three ingests describe the *full SES causal-console architecture*.
