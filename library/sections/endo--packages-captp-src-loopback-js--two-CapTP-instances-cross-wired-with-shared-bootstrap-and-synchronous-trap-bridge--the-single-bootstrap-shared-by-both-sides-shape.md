---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §single-bootstrap-shared-by-both-sides shape
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

```js
const bootstrap = Far('refGetter', {
  getRef(nonce) {
    const xFar = nonceToRef.get(nonce);
    nonceToRef.delete(nonce);
    return xFar;
  },
});
```

The §single-bootstrap-shared-by-both-sides: *the same*
`bootstrap` `Far('refGetter', ...)` is passed to *both*
`makeCapTP` calls. CapTP's `bootstrap` is the *root object*
that the peer side gets when it asks `getBootstrap()`. Here,
both sides expose the *same* root — a one-method exo for
nonce-keyed lookup.

The §getRef-also-deletes pattern: `getRef(nonce)` is *not*
just a read; it *consumes* the entry. The §use-once-then-
remove discipline: nonces are transient. Once `near`'s
`makeFar(x)` registers `x` under nonce `42`, exactly one
`getRef(42)` call returns it; subsequent calls return
`undefined`.

The §nonce-as-handshake-key observation: the *number* `42`
travels over CapTP (it's a passable integer); the *value*
behind it stays local. The receiver uses the nonce to *fetch
the value* back over the wire. The two-trip pattern: send
nonce → receive ref-back.
