---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
title: "The §iface = 'Alleged: name' allegation discipline"
parent: endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
---

The §`Far(farName, remotable)` function is the *user-facing
convenience*:

```js
return Remotable(`Alleged: ${farName}`, undefined, r);
```

This is the *source* of the `'Alleged: '` prefix that cycle 134's
`confirmIface` validates against, and cycle 130's `simplifyTag`
strips for matching. The §three-piece prefix-handling discipline:

- **make-far.js** (this cycle) — *produces* the prefix in `Far()`.
- **remotable.js** (cycle 134) — *requires* the prefix in
  `confirmIface()`.
- **message-breakpoints.js** (cycle 130) — *strips* the prefix in
  `simplifyTag()` for tag-matching.

The §Remotable JSDoc names the *allegation-not-attestation*
discipline:

> *We include the "Alleged" or "DebugName" as a reminder that we
> do not yet have SwingSet or Comms Vat support for ensuring this
> is according to the vat hosting the object. Currently, Alice
> can tell Bob about Carol, where VatA (on Alice's behalf)
> misrepresents Carol's `iface`. VatB and therefore Bob will then
> see Carol's `iface` as misrepresented by VatA.*

The §canonical-allegation-not-attestation hazard: the iface is
*the originating vat's claim about the object's identity*, not
*a verified attestation*. A relay vat can lie. The `'Alleged: '`
prefix is the visible *reminder* that consumers must not over-
trust the iface.

The §"DebugName: " prefix is the alternative — used when the name
is *purely for debugging*, not for any kind of identity. cycle
130's simplifyTag strips both.
