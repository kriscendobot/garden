---
title: Abstract
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

The §closing cluster of `console.js` provides two adapters that work atop the §2 makeCausalConsole core: **defineCausalConsoleFromLogger** (lines 446-513) — adapts a single-function logger (typed `(...args: unknown[]) => void`) into a full VirtualConsole + causal console. The §motivating use case: AVA's `t.log` — a single-function logger that should receive the causal console's output. The adapter wraps the logger as a *baseConsole* implementing the level-methods and other-methods (each delegating to `logWithIndent(name, ...args)`), then passes that baseConsole to `makeCausalConsole`. The result is a causal console that emits to `t.log`. The §3 features: (a) **indent-stack management** — `group(...args)` pushes a space onto an `indents` array; `groupEnd()` pops it; `logWithIndent(...args)` prepends the indents before each call to `tlogger`. (b) **The `indentAfterAllSeps` *horrible kludge*** (lines 437-441) — when an arg is a string with embedded `\n`, the adapter splits it at the newlines and *inserts the indents between each line* with an additional empty-string prefix-trick. The *horrible* admission is explicit: *This is a rather horrible kludge to indent the output to a logger in the case where some arguments are strings containing newlines. Part of the problem is that console-like loggers, including the one in ava, join the string arguments of the log message with a space. Because of this, there's an extra space at the beginning of each of the split lines. So this kludge compensated by putting an extra empty string at the beginning, so that the logger will add the same extra joiner. TODO: Fix this horrible kludge, and indent in a sane manner.* (c) **The empty-args group special case** — `group(name, ...args)` only prefixes the args if `args.length >= 1`; otherwise just pushes the indent. **filterConsole** (lines 518-541) — the third console adapter that *severity-gates* method calls through `filter.canLog(severity)`. Methods whose severity is `undefined` (per the consoleOtherMethods table) pass through unconditionally; methods with a severity are gated. The optional `_topic` parameter is a *TODO* future-work surface — *TODO do something with optional topic string*.
