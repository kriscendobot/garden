---
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: 1b978bfbec82786398c61b004019f83cafef3527
source_date: 2026-06-17
source_authors: [Mark S. Miller]
ingested: 2026-05-29
refreshed: 2026-06-27
section_count: 3
status: current
notes: |
  Tenth comment-fragment ingest. Mark S. Miller-authored SES causal-
  console core — *the* file that renders structured errors with cause-
  chain + AggregateError + notes + sub-error nesting. Pairs with cycle
  90's track-turns.js (which produces the annotations) and cycle 93's
  tame-v8-error-constructor.js (which provides getStackString). Three
  argument-cluster sections capture: (1) the no-special-privilege
  design axiom + permit lists + the new sanitizeFormatData %c-stripper;
  (2) the logging console buffer + causal console core (now with the
  Node Console customInspect circumvention) + logError render-sequence;
  (3) the AVA t.log adapter + horrible-kludge indent management +
  severity-gated filterConsole. The three sources (track-turns /
  tame-v8 / console) together describe the full SES causal-console
  rendering pipeline.

  Refreshed 2026-06-27 from file-commit e02b0f66 → 1b978bfb (upstream
  advanced 2026-06-17; +204/-33 lines, file grew 541 → 712). The drift
  added three things the refreshed sections now capture: (a) a new
  exported `sanitizeFormatData` that strips whatwg `%c` CSS-styling
  specifiers (and their consumed argument) before the args reach the
  base console, with careful `%%`-escape and unknown-specifier
  handling; (b) the split of `assert` + `timeLog` out of
  `consoleOtherMethods` into a new exported `consoleSpecialMethods`
  list, the tightening of every previously-`undefined` severity to a
  concrete level (clear/countReset/profile/profileEnd/timeStamp → info),
  and the corresponding `LogSeverity | undefined` → `LogSeverity` type
  narrowing; (c) `makeCausalConsole` now takes a `feralConsole` and, on
  Node, rebuilds a private `baseConsole` via the host `Console`
  constructor with `customInspect: false` to defeat Node's
  `Symbol.for('nodejs.util.inspect.custom')` deep-scan-with-unhardened-
  arguments hazard, plus dedicated `assert` / `timeLog` wrappers and a
  single trailing `name in baseConsole` filter over all method entries.
---

> Abstract: `packages/ses/src/error/console.js` is SES's *causal-console*
> module — *the* file that renders structured errors with their full
> cause-chain + AggregateError aggregation + post-construction notes +
> nested sub-errors. The module operates without special privilege
> (does not reference the realm's free variable `console`); it
> *receives* a `feralConsole` argument and wraps it. The opening
> permit lists enumerate which console methods this module knows how
> to wrap, now in three lists: 9 *level* methods (fmt?, ...args), 2
> *special* methods (assert, timeLog — same `...args` but in a
> different argument position), and 11 *other* pass-through methods,
> all cross-platform-consensus-sourced and each paired with a concrete
> `LogSeverity`. The new exported *sanitizeFormatData* strips whatwg
> `%c` CSS-styling specifiers (and the argument each consumes) from a
> `[fmt, ...args]` cluster before the args reach the base console,
> handling `%%` escapes and unknown specifiers per spec. The core
> *makeCausalConsole(feralConsole, loggedErrorHandler)* function now
> rebuilds a private base console on Node via the host `Console`
> constructor with `customInspect: false` (to defeat Node's
> `util.inspect.custom` deep-scan-with-unhardened-arguments hazard),
> then wraps each method to swap Error arguments for `(errorTag)`
> strings while queueing the actual errors for nested rendering. The
> *logError* function renders one error with all its annotations:
> message (with the *most-informative-message* rule that uses
> messageLogArgs over `error.message` when available), stack (via
> getStackString from cycle-93's tame-v8), cause, errors
> (AggregateError aggregation), notes (from cycle-90's track-turns),
> then recursively the sub-errors. The *makeLoggingConsoleKit* +
> *pumpLogToConsole* pair provides delayed-application buffering for
> tests. The *defineCausalConsoleFromLogger* adapter wraps an AVA
> `t.log`-style single-function logger into a full VirtualConsole +
> applies makeCausalConsole. The *indentAfterAllSeps* function is
> candidly named a *horrible kludge* with an explicit TODO. The
> *filterConsole* severity-gates via `filter.canLog(severity)` with a
> TODO for optional-topic-string.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [no-special-privilege-prelude-and-console-method-permit-lists](../sections/endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists.md) | hardened-javascript, errors | current |
| [logging-console-causal-console-and-error-info-rendering](../sections/endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering.md) | hardened-javascript, errors | current |
| [causal-console-from-logger-and-filter-console](../sections/endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console.md) | hardened-javascript, errors, testing | current |

The 712-line file decomposes into three argument-cluster sections. Lines 1-277 are prelude + permit lists (now three: level, special, other) + the new sanitizeFormatData %c-stripper → section 1. Lines 279-586 are makeLoggingConsoleKit + pumpLogToConsole + ErrorInfo + makeCausalConsole + logError → section 2. Lines 588-712 are defineCausalConsoleFromLogger + indentAfterAllSeps kludge + filterConsole → section 3 (content unchanged from the original ingest; only the line range shifted).

## Provenance

- Originally fetched 2026-05-29 from `endojs/endo@e02b0f66eb44306c3d739e1670114ef24d4202fa` via the local bare-clone.
- **Refreshed 2026-06-27** from `endojs/endo@1b978bfbec82786398c61b004019f83cafef3527` (the file-specific commit on `master` as of upstream's 2026-06-17 push) by the standing library-source-drift-scan. The refresh re-read the file at the new commit and updated sections 1 and 2 to match; section 3's content was unchanged (only its line range shifted from 417-541 to 588-712).
- Last touched 2026-06-17 by Mark S. Miller — the file's author. Mark's authorship is appropriate given the SES causal-console is a canonical Mark-designed artifact.
- Verified file existence and shape via bare-clone listing: 712 lines at the refreshed commit (was 541 at the original ingest; +204/-33).
- **Tenth comment-fragment ingest**. The chosen file *completes* the SES causal-console-rendering pipeline:
  - **Cycle 90** `track-turns.js` (Mark Miller) — produces causal annotations on errors.
  - **Cycle 93** `tame-v8-error-constructor.js` (Richard Gibson) — provides `getStackString` capability with V8-attenuation.
  - **Cycle 96** `console.js` (Mark Miller, this ingest) — renders the structured errors with cause/errors/notes/sub-errors.
- Together the three ingests describe the *full SES causal-console architecture*.
