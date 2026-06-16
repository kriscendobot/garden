---
title: Common confusions
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson]
source_lines: "204-477 (getLogArgs + hiddenMessageLogArgs + errorTagNum + tagError + sanitizeError + makeError + note + defaultGetStackString + loggedErrorHandler)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The *rendering machinery* of SES's assert module — the bridge
  between the cycle-90 (track-turns), cycle-93 (tame-v8), and cycle-96
  (causal-console) facets, all consumed via the exported
  `loggedErrorHandler`. Eight named surfaces: `getLogArgs`,
  `hiddenMessageLogArgs`, `errorTagNum` + `tagError`, `sanitizeError`,
  `makeError`, `note` + `hiddenNoteCallbacks`, `defaultGetStackString`,
  and `loggedErrorHandler`. The §getLogArgs structure unquotes
  declassifier-wrapped substitutions back to their underlying values
  for console-substitution and trims substitution-adjacent spaces
  *because the console logger inserts its own separating spaces
  between arguments*. The §sanitizeError function captures the
  host's automatically-added Error own-properties (fileName /
  lineNumber / etc. in non-V8 engines), annotates the error with a
  `note` describing the dropped values, and converts accessor
  properties (V8's `stack` getter) to data properties to make the
  error robust to redaction. The §loggedErrorHandler is the exact
  bridge cycle-96's makeCausalConsole consumes.
parent: endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler
---

- **"`getLogArgs` is just `getMessageString` with no string-concat."** It is — *plus the space-trimming around substitution boundaries*. `getMessageString` concatenates everything to one string with no trimming because the result is *a single rendered string*; `getLogArgs` returns *an array of arguments* that the console will space-separate on its own, so the trimming avoids double-spaces.
- **"`tagError` could just use `error.message` as the tag."** Errors with the same message would collide. The counter-based tag guarantees uniqueness even when many errors of the same name share a message. The counter increments globally, so `Error#3` always identifies *one specific error instance* in the current process.
- **"`sanitizeError` loses diagnostic information."** It does *not*. The dropped properties survive as a `note` annotation on the error (`originally with properties …`). The causal-console renders the annotation under the error, so a maintainer reading the log sees the same information that would have been visible from `console.dir(err)` — it's just been moved to a different rendering channel.
- **"V8's `stack` getter is just a perf optimization."** It is a *deferred-stack-walking optimization* (the JIT collects the frame information at throw time, but formatting it as a string is lazy). The SES-side concern is that *freezing an object with live accessors locks in their behavior* — calling the getter *again* after freeze invokes the same getter, which on V8 captures the *current* stack, not the *throw-time* stack. Eagerly evaluating and converting to a data property locks in the *throw-time* stack.
- **"`loggedErrorHandler` is just a god object."** It is the *intentional narrow-gate*. The file header explicitly names *anyone holding `loggedErrorHandler` observes the mutable state*. Concentrating the surface in one frozen bundle makes the auth-boundary auditable: anywhere the bridge is exported or passed, an auditor can see exactly which compartment was granted the observation capability.
- **"`takeMessageLogArgs` being destructive is a bug — the console should not lose data."** It is *intentional*. The contract: the console takes the log-args *exactly once*, when it first renders the error. Subsequent renders use whatever it has cached. The destructive read frees the WeakMap entry so the error can be GC'd if no other reference holds it.
- **"The `note` callback re-entrancy with `hiddenNoteCallbacks` looks like a bug."** It is the *streaming-annotation* mode: once the console has registered a callback, future `note(error, …)` calls hand the annotation directly to the console rather than queueing. This lets the console show *just-arrived* annotations even after the error has already been logged.
- **"The errorTagNum counter monotonically growing is a leak."** It is a *test-determinism affordance* (`loggedErrorHandler.resetErrorTagNum`) — tests reset the counter at test-start so output is reproducible. In production, the counter grows; it is an integer, so even `Number.MAX_SAFE_INTEGER` is reached only after 9e15 error tags.
