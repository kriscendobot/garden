---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
title: "Remotable, Far, and ToFarFunction — Alleged: prefix source, mutate-harden-check-twice"
parent: endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
---

> *Mutates the input argument! But `Remotable`*
> *  * requires the object to be mutable*
> *  * does further mutations,*
> *  * hardens the mutated object before returning it.*
> *so this mutation is not unprecedented. But it is surprising!*
>
> — `packages/pass-style/src/make-far.js` §Far JSDoc

`make-far.js` (221 lines, Kris Kowal-last-touched 2026-02-24 in
commit `57100aa0`) is the *constructor* layer for remotables —
direct companion to cycle 134's `remotable.js` (which *validates*
what this file constructs). Three exports — `Remotable`, `Far`,
`ToFarFunction` — plus the `GET_METHOD_NAMES = '__getMethodNames__'`
meta-method constant.
