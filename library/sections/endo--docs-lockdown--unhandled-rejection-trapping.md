---
title: unhandledRejectionTrapping Options
source: docs/lockdown.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: scholar
topics: [hardened-javascript, errors, eventual-send]
status: current
---

> Abstract: Controls handling of finalized unhandled promise rejections. Default: report (log via the tamed console). Option: none (suppress).

## `unhandledRejectionTrapping` Options

**Background**: Same concerns as `errorTrapping`, but in addition, SES will
attempt to install platform-specific finalized (rather than just same-turn)
unhandled rejection trapping.  If that attempt fails, then the platform's
default unhandled rejection behavior remains in effect.

```js
lockdown(); // unhandledRejectionTrapping defaults to 'report'
// or
lockdown({ unhandledRejectionTrapping: 'report' }); // print finalized unhandled rejections
// vs
lockdown({ unhandledRejectionTrapping: 'none' }); // no special unhandled rejection traps
```

If `lockdown` does not receive an `unhandledRejectionTrapping` option, it will
respect `process.env.LOCKDOWN_UNHANDLED_REJECTION_TRAPPING`.

```console
LOCKDOWN_UNHANDLED_REJECTION_TRAPPING=report
LOCKDOWN_UNHANDLED_REJECTION_TRAPPING=none
```

On the web, the `window` event emitter has a trap for `unhandledrejection` and
`rejectionhandled` events.  In the absence of a trap, the platform logs
rejections that were not handled in the same turn in which they were created to
the debugger console and continues.  However, setting `errorTrapping` to
`'exit'` or `'abort'` will cause the web equivalent of halting the page: the
error will cause navigation to a blank page, immediately halting execution in
the window.

In Node.js, the `process` event emitter has a trap for `unhandledRejection` and
`rejectionHandled`.  In the absence of a trap, the platform logs rejections that
were not handled in the same turn in which they were created, and potentially a
scary warning that says unhandled rejections may cause the process to exit in a
future release.

By setting a non-`'none'` value for `unhandledRejectionTrapping`, the event
handler will only be triggered by unhandled rejections when they are finalized.
This enables the program to attach rejection handlers asynchronously without
triggering the SES trap handler.

- `'report'`: just report finalized unhandled rejections to the tamed console so stack traces appear.
- `'none'`: do not install traps for finalized unhandled rejections. Errors are
  likely to appear as `{}` when they are reported by the default trap.


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
