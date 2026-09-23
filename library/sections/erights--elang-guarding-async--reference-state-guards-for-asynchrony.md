---
title: "Guarding Asynchrony: reference-state guards (:near, :pbc, :vow, :rcvr, :any)"
source_kind: web
source_url: http://erights.org/elang/guarding/async.html
source_effective_url: https://erights.github.io/erights-org-website/elang/guarding/async.html
source_fetched_via: mirror
source_content_sha256: 3ab057a0dfc208dc0ce48f76d7cb20f77a288a5c1a8b2af5f517073395583ce7
source_authors: [Mark S. Miller, Terry Stanley]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send, pass-style]
status: current
notes: >
  Primary erights.org tutorial chapter (Guarding Asynchrony, the one child chapter
  of the elang Soft-Type-Checking guards hub). The page is flagged "Stale, needs
  rewrite" upstream. It is the historical primary source for E's reference-state
  guards (:near, :pbc, :vow, :rcvr, :any) that annotate whether a reference
  supports immediate calls or only eventual sends, plus a proposed lint-style
  static-checking ruleset (the near <= vow <= rcvr subtype lattice). Reachable via
  the erights.org GitHub Pages mirror. source_date is an era approximation matching
  the sibling guarding/concurrency chapters. The sibling chapter "Guard Expression
  Style" (guarding/style.html) the hub's map promised was never written (404 on the
  mirror and the Internet Archive); this is the only extant guarding child chapter.
---

## Abstract

The E tutorial's **Guarding Asynchrony** chapter: the historical primary source
for E's **reference-state guards**, guard annotations that say whether a reference
supports immediate (synchronous) calls or only eventual sends, and that interact
with E's near/eventual/broken reference model. It defines five guards: **`:near`**
(the reference is resolved-and-local, so immediate calls are safe; properly
enforced), **`:pbc`** (a near reference to a [[pass-by-construction]] object;
properly enforced), **`:vow`** and **`:vow[valueGuard]`** (a possibly-unresolved
reference whose successful resolution must be near, never far — the eventual
analog of `:near`; advisory-only until PassByCopy support lands), **`:rcvr`** and
**`:rcvr[valueGuard]`** (a reference that may be eventual and may resolve far, so
deal with it only by eventual send; advisory-only), and **`:any`** (no
constraint, no coercion; the vacuous guard). The chapter then sketches a
**lint-style static-checking advisor** built on the subtype lattice `near <= vow
<= rcvr` and a set of automatable warning rules over `.`-calls versus `<-`-sends.
These reference-state guards are the E ancestor of the near/far/promise
distinctions Endo carries in `@endo/eventual-send` (`E()` for eventual,
synchronous call for near) and of the coerce-or-reject guard model
`@endo/patterns` and `M.interface` realize. The page is upstream-flagged "Stale,
needs rewrite" and the `:vow`/`:rcvr` guards are explicitly advisory (operationally
`:any`) at the time of writing; use it to ground claims about E's reference-state
guard vocabulary and its intended pipelining-preserving enforcement, not as a
spec of shipped behavior.

## Walkthrough

The chapter grows out of Terry Stanley's e-lang naming-convention proposal (encode
`near` / `vow` / `rcvr` in variable, function, and object names). The open
question it raises: should those distinctions live in **names** (the convention
mostly followed since), or in **guard annotations** (what Terry came to advocate),
or both. Its conclusion is that expressing the distinctions as guards is worth
doing regardless — both to capture programmer intent in machine-understandable
form and, eventually, to *enforce* the property the way other guards do.

### The five reference-state guards

- **`:near`** — A near reference passes; all others are rejected. A near
  reference supports immediate calls on the object it designates (resolved and
  local). *Properly enforced.* (No change in meaning or implementation from the
  pre-existing guard.)
- **`:pbc`** — A near reference to a **PassByConstruction** object (all PassByCopy
  objects are also PassByConstruction). When a `pbc` is passed as an argument, the
  value the callee receives will be `pbc`; an unresolved reference to a `pbc`
  resolves only to a `pbc`, never to a far reference. *Properly enforced.*
- **`:vow`** and **`:vow[valueGuard]`** — *(New as of E 0.8.14.)* A `vow` may be
  near, unresolved, or broken; if currently unresolved, its successful resolution
  **must be near** (its resolution is near or broken, never far). A
  possibly-unresolved reference to a `pbc` is a vow. `:vow[valueGuard]` is a vow
  for something that will pass `valueGuard` (`:vow[int]` is a vow for an int).
  **Currently not enforced** — operationally equivalent to `:any`, used purely for
  documentation. Once enforced, it will send the `valueGuard` to the specimen's
  *host* to coerce the specimen there (the `valueGuard` itself must be a `pbc`
  object if the specimen is remote), returning a promise for the result of
  remotely coercing the specimen. This **preserves pipelining** (a local check
  would lose it) and prevents any message reaching a specimen that does not pass
  the guard, but relies on the specimen's host to run the guard honestly. Trading
  pipelining for local enforcement is easy to write in the language but was judged
  the wrong default.
- **`:rcvr`** and **`:rcvr[valueGuard]`** — *(New as of E 0.8.14.)* A `rcvr` is a
  reference that may be eventual and whose resolution may be **far**; one should
  therefore deal with `rcvr`s **only by eventual sends, never by immediate
  calls**. Bare `:rcvr` is operationally `:any` (properly if vacuously enforced).
  `:rcvr[valueGuard]` is a reference for an object that will pass `valueGuard`;
  like `:vow[valueGuard]` it is currently unenforced, to be enforced by the same
  send-the-guard-to-the-host technique.
- **`:any`** — The specimen may be any kind of reference and no coercion is
  performed (`coerce` returns its argument). *Properly if vacuously enforced.*
  Operationally identical to bare `:rcvr`, but with a documentation difference:
  `:rcvr` states the declarer has special knowledge it is warning its client of,
  whereas `:any` fits when the *client* may have better knowledge than the
  declarer. The worked contrast: a `get/1` on a `ConstList` is declared `:any`
  (the declarer only hands back what was put in, which could be anything; the
  client knows what it put in), not `:rcvr`.

### The static-checking advisor (subtype lattice and lint rules)

The annotations are meant to be adequate for a **lint-like static checking
advisor**. The chapter offers an explicitly-suggestive (not complete or correct)
ruleset, using `int` as an example PassByCopy type and `Counter` as an example
PassByProxy type, with `<=` meaning "subtype" and `=>` meaning "produces / is of
type":

```
near <= vow <= rcvr
int  <= vow[int]  <= rcvr[int]      (warn that rcvr[int] should be vow[int])
Counter <= vow[Counter] <= rcvr[Counter]
        (warn that vow[Counter] may want to be rcvr[Counter], unless the
         counter is known to be local)
```

Sample propagation rules over calls (`f(...)`) versus sends (`f <- (...)`):

- Given `def f1():int`: `f1() => int`, but `f1 <- () => vow[int]` (an eventual
  send to a near function returns a vow for its result type).
- Given `def f2():vow`: `f2() => vow`, and `f2 <- () => vow` (f2 is a near
  reference to the function).
- Given `f2Rcvr :rcvr[F2]`: `f2Rcvr <- () => rcvr` (f2Rcvr may be remote, so a vow
  to it is a rcvr to us).
- Given `f1Rcvr :rcvr[F1]`: `f1Rcvr <- () => vow[int]` (a remote reference to a vow
  for a pbc is still a vow for a pbc).
- `when (vow) -> done(near)`, `when (vow[int]) -> done(int)`, and
  `when (rcvr) -> done(rcvr)` are all ok (the `when` resolves the eventual
  reference to its near form).
- Given `def f3(int)` and `def f4(counter)`: `f3(int)`, `f3 <- (int)`,
  `f4(counter)`, `f4 <- (counter)` are all ok (both are near references).
- Given `f4Rcvr :rcvr[F4]`: `f4Rcvr <- (counter)` is **bad** (f4Rcvr may be
  remote, so passing a near counter by send across a possible vat boundary is
  suspect); a `:Counter` argument warrants only a *warning*, since it is sometimes
  correct when the programmer knows both are resolved references into the same
  remote vat (special knowledge the chapter doubts is worth encoding in static
  rules).

The list is offered as a starting point for "someone who has competency with such
matters"; the author disclaims type-theory expertise and invites corrections on
the e-lang list.

## Translation (E to Endo)

| E term | Endo / Hardened JavaScript equivalent |
|---|---|
| `:near` guard | a resolved, local presence — safe for synchronous calls |
| `:rcvr` guard | a possibly-remote, possibly-unresolved reference — use `E()` (eventual send) only |
| `:vow` / `:vow[valueGuard]` | a promise (`HandledPromise`) whose fulfillment is local; optionally for a value matching a pattern |
| `:pbc` (PassByConstruction) | a [[pass-by-construction]] value (the general rule of which pass-by-copy is a special case) |
| `:any` | no constraint — `M.any()` in `@endo/patterns` |
| send-the-guard-to-the-host coercion | remote coercion that preserves promise pipelining (the local-check-loses-pipelining tradeoff) |
| guard annotation on a definition / return | a pattern / interface guard in `@endo/patterns` / `M.interface` |

## See also

- [erights--elang-guarding--soft-type-checking-map](erights--elang-guarding--soft-type-checking-map.md): the Soft-Type-Checking guards hub this chapter sits under.
- [erights--elang-concurrency-epimenides--reference-states-and-data-lock](erights--elang-concurrency-epimenides--reference-states-and-data-lock.md): the near / eventual / broken reference-state model these guards annotate.
- [erights--elang-kernel--pattern-forms-and-helpers](erights--elang-kernel--pattern-forms-and-helpers.md): the kernel `: eExpr` guard hook on patterns (the syntactic ancestor of `@endo/patterns`) where guards attach.
- [erights--elang-quick-ref--idioms-quick-reference](erights--elang-quick-ref--idioms-quick-reference.md): the `<-` eventual-send and `when -> catch` idioms the rcvr/vow distinction governs.

Source: [elang/guarding/async.html](https://erights.org/elang/guarding/async.html), fetched 2026-06-28 via the erights.org GitHub Pages mirror ([erights.github.io/erights-org-website/elang/guarding/async.html](https://erights.github.io/erights-org-website/elang/guarding/async.html)), content SHA-256 `3ab057a0dfc2`.
