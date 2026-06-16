---
title: §logErrorFirst — the §log-then-rethrow discipline
source-slug: endo--packages-ses-ava
section-id: registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava/src/{ses-ava-test.js, command.js, reexport-ava.js}
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-ses-ava--registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
---

```js
const logErrorFirst = (func, virtualT, args, source) => {
  let result;
  try {
    result = apply(func, undefined, [virtualT, ...args]);
  } catch (err) {
    virtualT.log(`THROWN from ${source}:`, err);
    throw err;
  }
  if (isPromise(result)) {
    return result.then(
      v => v,
      reason => {
        virtualT.log(`REJECTED from ${source}:`, reason);
        return result;
      },
    );
  } else {
    return result;
  }
};
```

§Three-cases-of-test-outcome:
1. §Sync-throw: log to `virtualT.log` with `THROWN from <source>:` prefix, then re-throw.
2. §Promise-rejection: log to `virtualT.log` with `REJECTED from <source>:` prefix, then return the original promise (which AVA will see as rejected).
3. §Success (sync or async): silent return.

§Two-distinct-log-prefixes (`THROWN` vs `REJECTED`) to distinguish sync-throw from async-rejection. §Sibling to cycle 90 track-turns.js's §THROWN-vs-REJECTED log distinction — same two-prefix discipline at a different layer.

§The-promise-rejection-handler-returns-the-original-promise (`return result`), not the reason. AVA sees the rejection; ses-ava just got to log first. §Borrowable-pattern: §intercept-without-changing-the-outcome — §the-logger-is-a-side-effect, §not-a-transformation.

The JSDoc names the §observable-difference-from-direct-call:

> The delayed rejection of the returned promise is an observable difference from directly calling `func(...)` but will be equivalent enough for most testing purposes.

§Honest-disclosure-of-the-tiny-semantic-drift. §Borrowable-pattern: §name-the-observable-difference + §argue-it's-equivalent-enough-for-the-use-case.
