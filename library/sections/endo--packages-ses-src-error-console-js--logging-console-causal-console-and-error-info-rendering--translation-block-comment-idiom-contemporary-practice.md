---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `makeLoggingConsoleKit` + `takeLog` | Capture-then-replay test infrastructure; the canonical *defer-log-until-needed* pattern. |
| `pumpLogToConsole` | Replay captured log entries onto a real console for debugging. |
| `extractErrorArgs` swap-Error-for-tag-string | The *render-once-reference-by-tag* discipline; prevents log flood. |
| `ErrorInfo.NOTE / MESSAGE / CAUSE / ERRORS` | The four-kind structured-error model; reusable for any error-rendering subsystem. |
| `errorsLogged` WeakSet | Dedup-with-WeakSet for arbitrary-graph rendering; prevents infinite recursion. |
| Most-informative-message rule | Multi-source content: richer source wins; document which sources exist. |
| `if (baseConsole[level])` defensive binding | Optional-method wrapping; silent no-op on missing methods. |
| `assert.note(error, X\`...\`)` callback timing | The *annotation-arrived-after-the-fact* case; emit immediately rather than queue. |
