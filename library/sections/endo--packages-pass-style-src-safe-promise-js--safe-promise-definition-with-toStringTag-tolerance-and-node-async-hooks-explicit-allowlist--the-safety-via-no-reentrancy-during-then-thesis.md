---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
title: The §safety-via-no-reentrancy-during-then thesis
parent: endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
---

The §confirmSafePromise JSDoc gives the *operational definition*:

> *Under Hardened JS a promise is "safe" if its `then` method
> can be called synchronously without giving the promise an
> opportunity for a reentrancy attack during that call.*

The §reentrancy-attack threat shape: a malicious thenable can
override `.then` to *run code while the caller is in the middle
of operating on it*, gaining synchronous re-entry into the
caller's state. Safe promises are the *defense*: a promise whose
`.then` method *cannot do that*.

The §reentrancy-via-test-itself meta-hazard:

> *https://github.com/Agoric/agoric-sdk/issues/9 raises the
> issue of testing that a specimen is a safe promise such that
> the test also does not give the specimen a reentrancy
> opportunity. That is well beyond the ambition here.*

The §honest-limitation discipline: the safety check itself
*touches the specimen* (via `getPrototypeOf`, `ownKeys`, etc.).
A perfectly-paranoid implementation would test in a way that
*doesn't* call into the specimen at all. This file *doesn't*
achieve that; the JSDoc names the gap.
