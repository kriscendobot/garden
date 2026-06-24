---
title: §`new HandledPromise((resolve, reject) =>`-as-defer-mechanism
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
return new HandledPromise((resolve, reject) => {
  interlockP
    .then(_ => {
      resolve(HandledPromise[postponedOperation](x, ...args));
    })
    .catch(reject);
});
```

§The-deferred-call-is-a-new-HandledPromise-whose-resolution-is-the-real-operation's-result. §When-the-interlock-resolves, §the-real-operation-fires + §its-result-resolves-the-outer-HandledPromise. §The-`.catch(reject)` propagates failure — §if-the-real-operation-throws-or-rejects, §the-outer-HandledPromise-rejects-with-the-same-reason.

§`.then(_ =>`-ignored-resolve-value-with-underscore-prefix — §the-interlockP-resolves-with-undefined-and-the-resolve-value-isn't-used + §the-`_`-name-signals-deliberate-ignoring. §When-a-promise's-resolve-value-is-not-load-bearing, §name-the-parameter-`_`-to-document-the-ignoring.
