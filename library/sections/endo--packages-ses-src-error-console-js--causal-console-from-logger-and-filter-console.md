---
title: The defineCausalConsoleFromLogger adapter that wraps an AVA `t.log`-shaped logger function into a baseConsole + applies makeCausalConsole; the *horrible kludge* indentAfterAllSeps function (with the TODO admitting it) for nested-group indentation under loggers that join args with spaces; the group/groupCollapsed/groupEnd indent-stack management; the filterConsole that severity-gates calls based on `filter.canLog(severity)`
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: 1b978bfbec82786398c61b004019f83cafef3527
source_date: 2026-06-17
source_authors: [Mark S. Miller]
source_lines: "588-712 (defineCausalConsoleFromLogger + indentAfterAllSeps kludge + filterConsole)"
topics: [hardened-javascript, errors, testing]
status: current
notes: |
  Refreshed 2026-06-27 (file-commit e02b0f66 → 1b978bfb): content
  unchanged; only the line range shifted (417-541 → 588-712) as the
  prelude and makeCausalConsole sections above it grew by +204/-33.
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console--abstract.md)
- [Body](endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console--see-also.md)
- [Common confusions](endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console--common-confusions.md)
