---
title: errorTrapping Options
source: docs/lockdown.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: scholar
topics: [hardened-javascript, errors]
status: current
---

> Abstract: Controls handling of uncaught exceptions. Platform default. Options: exit (abort the process), abort (immediate non-graceful), report (log via the tamed console), none (do nothing). Behavior varies between Node.js and browser environments.

## `errorTrapping` Options

**Background**: With safe error taming and console taming, after lockdown,
errors are born without an attached `stack` string.
Logging the error with the tamed `console` will safely reveal the stack to the
debugger or terminal.
However, an uncaught exception gets logged to the console without the
benefit of the tamed `console`.

```js
lockdown(); // errorTrapping defaults to 'platform'
// or
lockdown({ errorTrapping: 'platform' }); // 'exit' on Node, 'report' on the web.
// vs
lockdown({ errorTrapping: 'exit' }); // report and exit
// vs
lockdown({ errorTrapping: 'abort' }); // report and drop a core dump
// vs
lockdown({ errorTrapping: 'report' }); // just report
// vs
lockdown({ errorTrapping: 'none' }); // no platform error traps
```

If `lockdown` does not receive an `errorTrapping` option, it will respect
`process.env.LOCKDOWN_ERROR_TRAPPING`.

```console
LOCKDOWN_ERROR_TRAPPING=platform
LOCKDOWN_ERROR_TRAPPING=exit
LOCKDOWN_ERROR_TRAPPING=abort
LOCKDOWN_ERROR_TRAPPING=report
LOCKDOWN_ERROR_TRAPPING=none
```

On the web, the `window` event emitter has a trap for `error` events.
In the absence of a trap, the platform logs the error to the debugger console
and continues.
This is consistent with the security ethos that a sandboxed program should not
have the ambient power of causing the surrounding process to exit.
However, setting `errorTrapping` to `'exit'` or `'abort'` will cause the
web equivalent of halting the page: the error will cause navigation to
a blank page, immediately halting execution in the window.

In Node.js, the `process` event emitter has a trap for `uncaughtException`.
In the absence of a trap, the platform logs the error and immediately exits the
process.
To be consistent with the underlying platform, the SES default `errorTrapping` of
`'platform'` registers an `uncaughtException` handler that feeds the
error to the tamed console so you can observe the stack trace, then exits
with a non-zero status code, favoring the existing value in `process.exitCode`,
but defaulting to -1.
The default on Node.js is consistent with the underlying platform but
inconsistent with the principle of only granting the authority to cause
the container to exit explicitly, and we highly recommend setting
`errorTrapping` to `'report'` explicitly.

- `'platform'`: is the default and is equivalent to `'report'` on the Web or
  `'exit'` on Node.js.
- `'report'`: just report errors to the tamed console so stack traces appear.
- `'exit'`: reports and exits on Node.js, reports and navigates away on the
  web.
- `'abort'`: reports and aborts a Node.js process, leaving a core dump for
  postmortem analysis, reports and navigates away on the web.
- `'none'`: do not install traps for uncaught exceptions. Errors are likely to
  appear as `{}` when they are reported by the default trap.


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
