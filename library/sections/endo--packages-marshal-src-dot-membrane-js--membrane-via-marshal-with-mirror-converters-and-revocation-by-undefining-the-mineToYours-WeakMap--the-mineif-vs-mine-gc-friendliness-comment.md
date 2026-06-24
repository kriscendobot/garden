---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: The §mineIf-vs-mine GC-friendliness comment
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

The §inline comment names a *not-quite-resolved* hazard:

> *We use mineIf rather than mine so that mine is not accessible
> after revocation. This gives the correct error behavior, but
> may not actually enable mine to be gc'ed, depending on the JS
> engine.*

The §mineIf-vs-mine renaming: `mineIf = passBack(yours)`. After
revocation, `passBack` throws, so `mineIf` is never assigned;
the original `mine` is unreferenced from the wrapper closure
(it was never captured directly — only `yours` is captured, and
the conversion goes *through* `passBack`).

The §GC-friendliness-may-vary observation: even though the
*reference* is gone, JS engines may still keep `mine` alive via
the closure (escape analysis varies). The §TODO suggests a more
explicit decoupling:

> *TODO Could rewrite to keep scopes more separate, so
> post-revoke gc works more often.*

The §honest-not-yet-perfect discipline: the revocation is
*functionally correct* (post-revoke calls throw); it's
*operationally imperfect* (the wrapped capabilities may not get
GC'd until the wrappers themselves are reachable).
