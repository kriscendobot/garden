---
title: reporting Options
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

> Abstract: Controls where SES sends its own diagnostic warnings (distinct from the tamed console). Platform default. Options: console (route warnings to the tamed console), none (suppress).

## `reporting` Options

**Background**: `lockdown` and `repairIntrinsics` report warnings if they
encounter unexpected but repairable variations on the shared intrinsics, which
regularly occurs if the version of `ses` predates the introduction of new
language features.
With the `reporting` option, an application can mute or control the direction
of these warnings.

```js
lockdown(); // reporting defaults to 'platform'
// or
lockdown({ reporting: 'platform' });
// vs
lockdown({ reporting: 'console' });
// vs
lockdown({ reporting: 'none' });
```

If `lockdown` does not receive a `reporting` option, it will respect
`process.env.LOCKDOWN_REPORTING`.

```console
LOCKDOWN_REPORTING=platform
LOCKDOWN_REPORTING=console
LOCKDOWN_REPORTING=none
```

- The default behavior is `'platform'` which will detect the platform and
  report warnings according to whether a web `console`, Node.js `console`, or
  `print` are available.
  - The web platform is distinguished by the existence of `window` or
    `importScripts` (WebWorker), in which case the current console (at the time
    of reporting) is used.
  - The Node.js behavior is to report all warnings to `stderr` visually
    consistent with use of a console group. To do this, it actually
    reports using the `console.error` method of the current console (at
    the time of reporting).
  - SES will use `print` in the absence of a `console`.
- The `'console'` option forces the web platform behavior, in which the current
  console (at time of reporting) is used directly.
  On Node.js, this results in group labels being reported to `stdout`, because
  that is the unalterable behavior of Node's `console.group*` methods.
  The global `console` can be replaced, so using this option
  will drive use of `console.groupCollapsed`, `console.groupEnd`,
  `console.warn`, and `console.error` assuming that console is suited for
  reporting arbitrary diagnostics, rather than also being suited to generate
  machine-readable `stdout`.
- The `'none'` option mutes warnings.


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
