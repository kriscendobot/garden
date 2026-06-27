---
title: The makeLoggingConsoleKit *delayed-application-buffer* pair (loggingConsole that captures all calls into a logArray + takeLog that drains and returns the captured array); pumpLogToConsole that replays captured calls onto a baseConsole; the makeCausalConsole core — now taking a `feralConsole` and, on Node, rebuilding a private baseConsole via the host `Console` constructor with `customInspect: false` to defeat the `util.inspect.custom` deep-scan-with-unhardened-arguments hazard — with extractErrorArgs (swaps Error arguments for `(errorTag)` strings) fed by sanitizeFormatData; logErrorInfo for emitting one error-annotation; logSubErrors for nested-error grouping; errorsLogged WeakSet preventing re-logging; logError as the main *render-one-error-with-all-its-annotations* function with the *most-informative-message* rule that uses messageLogArgs over `error.message` when available; dedicated assert + timeLog wrappers and a single trailing `name in baseConsole` filter over all method entries
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: 1b978bfbec82786398c61b004019f83cafef3527
source_date: 2026-06-17
source_authors: [Mark S. Miller]
source_lines: "279-586 (makeLoggingConsoleKit + pumpLogToConsole + ErrorInfo + makeCausalConsole + logError)"
topics: [hardened-javascript, errors]
status: current
notes: |
  Refreshed 2026-06-27 (file-commit e02b0f66 → 1b978bfb). makeCausalConsole
  changed materially: its first parameter is now `feralConsole`, and on
  Node it rebuilds a private `baseConsole` via the host `Console`
  constructor with `inspectOptions: { customInspect: false }` (reading
  `process.stdout`/`stderr`) to opt out of Node's
  `Symbol.for('nodejs.util.inspect.custom')` deep-scan, which would
  otherwise invoke custom-inspect methods with unhardened arguments. Each
  level method now destructures `[name, level]`, calls `baseConsole[name]`
  unconditionally (the prior `if (baseConsole[level])` existence guard
  moved to a single trailing filter), and passes its args through the new
  `sanitizeFormatData` (%c-stripper) before extractErrorArgs. assert and
  timeLog gained bespoke wrappers (their leading value/label is kept,
  then the remaining args are sanitized + error-extracted). The final
  causalConsole is `fromEntries` of all level + assert + timeLog + other
  entries filtered by `name in baseConsole`. The makeLoggingConsoleKit /
  pumpLogToConsole / ErrorInfo / logError render-sequence is unchanged.
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering--abstract.md)
- [Body](endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering--see-also.md)
- [Common confusions](endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering--common-confusions.md)
