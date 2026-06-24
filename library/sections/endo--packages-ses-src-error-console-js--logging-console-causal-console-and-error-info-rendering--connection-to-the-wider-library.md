---
title: Connection to the wider library
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "159-415 (makeLoggingConsoleKit + pumpLogToConsole + makeCausalConsole + logError + ErrorInfo)"
topics: [hardened-javascript, errors]
status: current
parent: endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering
---

This section is the **canonical worked example of *causal-console-as-structured-error-renderer***. Three threads:

1. **The capture-then-replay logging buffer.** Reusable for any test infrastructure that wants deterministic-console-output assertions. The `makeLoggingConsoleKit` + `pumpLogToConsole` pair is reusable as-is.

2. **The tag-instead-of-toString discipline for nested errors.** Errors render once with a tag (`err-3`); the tag appears wherever the error is referenced; the actual rendering happens once per error in a nested group. Prevents log-flood while preserving structural relationships.

3. **The most-informative-message rule.** When two sources of error-content disagree (the `details`-template-tag args vs the plain `error.message` string), the richer source wins. Reusable for any system with multiple-source content.
