---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §single most structurally interesting move — §two-CapTP-instances-cross-wired
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

```js
const {
  Trap,
  dispatch: nearDispatch,
  getBootstrap: getFarBootstrap,
  // ...
} = makeCapTP(`near-${ourId}`, o => farDispatch(o), bootstrap, { ... });

const {
  makeTrapHandler,
  dispatch: farDispatch,
  getBootstrap: getNearBootstrap,
  // ...
} = makeCapTP(`far-${ourId}`, nearDispatch, bootstrap, farOptions);
```

The §two-CapTP-instances-cross-wired architecture: each side
receives *the other side's* dispatch function as its
*send* hook. When `near` wants to send a message to `far`, it
calls *the function that was passed as its second arg* —
which is `farDispatch` — which the `far` side received as its
*receive* hook.

The §forward-reference-via-arrow observation: the first
`makeCapTP` call wraps `farDispatch` in an arrow function
`o => farDispatch(o)` because `farDispatch` *doesn't exist
yet* at the call site (it's bound by the *second*
`makeCapTP`'s destructure later). The arrow captures the
*binding*, not the value; resolved at *invocation* time when
near actually sends a message. The §closure-captures-binding-
not-value JS-language fact made load-bearing here.

The §eslint-disable-no-use-before-define explicit comments:
*the only way to read this code* is to know that *the
forward references are intentional and necessary*.

```js
// eslint-disable-next-line no-use-before-define
} = makeCapTP(`near-${ourId}`, o => farDispatch(o), bootstrap, {
```

The §eslint-as-design-discipline: the linter would *normally*
flag this; the explicit disable tells future readers (and the
linter) that *this is the load-bearing pattern, not a bug*.
