---
title: §interlockP with resolve captured in executor
source-slug: endo--packages-eventual-send-src-postponed-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/postponed.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/postponed.js
total-lines: 46
ingest-cycle: 241
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type
---

```js
let donePostponing;

const interlockP = new Promise(resolve => {
  donePostponing = () => resolve(undefined);
});
```

§The-resolve-callback-is-captured-via-closure-in-Promise-executor. §The-Promise-constructor-runs-its-executor-synchronously, so `donePostponing` is assigned before `new Promise(...)` returns. §Closure-captures-on-Promise-executor-synchronous-assignment — §a-standard-pattern-for-exposing-the-resolve-and-reject-callbacks-outside-the-Promise.

§The-interlockP-name — *interlock* names the synchronization point: nothing past the interlock fires until the lock is released by `donePostponing()`. §When-a-value-is-pending-and-a-callback-must-trigger-its-resolution, §name-the-pending-promise-after-the-synchronization-shape-not-after-the-value-it-carries (the value is just `undefined`; the *interlock* is the meaning).

§`assert(donePostponing)`-with-`@ts-expect-error 2454`: the assertion is for TypeScript's benefit (TS error 2454 is "Variable used before being assigned"). §The-`@ts-expect-error`-cites-the-specific-error-code. §The-`@ts-expect-error`-IS-the-acknowledgment-that-TS-can't-see-the-Promise-executor's-synchronous-run + §the-runtime-assert-IS-the-belt-and-suspenders-check. §Sibling-pattern-to-cycle-146's `@ts-expect-error` for `microsoft/TypeScript#50319` (cycle 146 cited a TypeScript GitHub issue; cycle 241 cites a TypeScript error code number); §two-cycles-with-`@ts-expect-error`-citing-a-specific-TS-issue-or-error-code (cycles 146 + 241).
