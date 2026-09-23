---
title: Common confusions
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

- **"`takeLog()` doesn't deep-freeze the entries."** It freezes the *outer* array — the entries themselves (which include arrays of args) are not deep-frozen. A consumer that mutates an arg-array would corrupt the captured log. The §discipline is *capture-and-don't-mutate*; the freezing is documentation, not enforcement.
- **"`extractErrorArgs` is too eager — what if I want to log the error normally?"** The level-method wrappers always extract; that's the *causal-console contract*. If you want to log an error *as a plain object*, wrap it: `console.log({ err })`. The plain `console.log(err)` triggers extraction.
- **"`errorsLogged` is a memory leak."** It uses a `WeakSet` — when the error is GC'd, the entry vanishes. The dedup-cache is scoped to the lifetime of the errors, not the console.
- **"The `if (subErrors.length === 1 && optTag === undefined)` special case is fragile."** It is the *single-error-without-explicit-parent-tag-can-render-flat* optimization. Without it, every single-sub-error case would emit a degenerate one-element group. The optimization keeps the log readable.
- **"The most-informative-message rule loses `error.message`."** It loses the *string* form. The richer `messageLogArgs` form *contains* equivalent or richer information. If a developer needs the plain message, they can read `error.message` directly (it's still on the object).
- **"`baseConsole.group(label)` then `baseConsole.groupEnd()` may not be balanced if `logError` throws."** The try/finally around the group-end ensures balance — even if `logError` throws mid-iteration, the `finally` block calls `groupEnd()`. The defense is explicit.
- **"`takeMessageLogArgs(error)` drains the args — what if I call it twice?"** The *take-once* pattern is intentional: the args are consumed at logging time so they can't be re-logged. If a developer wants to inspect the args, they should do so before the error reaches the console.
