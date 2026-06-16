---
title: The makeLoggingConsoleKit *delayed-application-buffer* pair (loggingConsole that captures all calls into a logArray + takeLog that drains and returns the captured array); pumpLogToConsole that replays captured calls onto a baseConsole; the makeCausalConsole core with extractErrorArgs (swaps Error arguments for `(errorTag)` strings); logErrorInfo for emitting one error-annotation; logSubErrors for nested-error grouping; errorsLogged WeakSet preventing re-logging; logError as the main *render-one-error-with-all-its-annotations* function with the *most-informative-message* rule that uses messageLogArgs over `error.message` when available
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "159-415 (makeLoggingConsoleKit + pumpLogToConsole + makeCausalConsole + logError + ErrorInfo)"
topics: [hardened-javascript, errors]
status: current
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
