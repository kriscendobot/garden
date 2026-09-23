---
title: Common confusions
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "417-541 (defineCausalConsoleFromLogger + indentAfterAllSeps kludge + filterConsole)"
topics: [hardened-javascript, errors, testing]
status: current
parent: endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console
---

- **"`defineCausalConsoleFromLogger` is just a wrapper."** It is a *higher-order* wrapper that produces a full VirtualConsole from a single-function logger. The asymmetry (level methods drop the name; other methods include it) reflects the *what information is informative* call.
- **"The indent stack is per-realm."** It is *per-instance* of `makeCausalConsoleFromLogger`. Each call to the adapter creates a fresh `indents` array; concurrent loggers don't share state.
- **"The horrible-kludge TODO will never be fixed."** The TODO is *honestly-described*; whether it gets fixed depends on whether someone invests the effort. The §candor-with-TODO discipline doesn't promise a fix; it documents the imperfection.
- **"`filterConsole` should support hierarchical severities."** The current filter is a *boolean-per-severity* function. Hierarchical severities (e.g. *log all `'warn'` and above*) require the *filter implementation* to encode the hierarchy. The §filter is *capability-shaped* — the application provides the policy.
- **"The empty-args `group()` case is sloppy."** It is the *minimum-state-change* discipline: an empty group still introduces a context level; emitting nothing-but-pushing-the-indent is the right thing. A non-empty group emits its label first (at the *parent*'s indent level) before pushing.
- **"AVA's `t.log` is the only single-function logger in scope."** It is the *motivating* case but not the only one — any test framework or instrumentation that exposes a single logging function can use the adapter. The §design is *not* AVA-specific.
- **"The whole module could be replaced by `console = augmented-console`."** Would defeat the no-special-privilege axiom from §1. The module operates *without* assuming the realm's `console` is the right destination; the realm's console is just one of many possible base consoles.
