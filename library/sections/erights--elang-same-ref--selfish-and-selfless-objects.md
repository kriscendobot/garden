---
title: "Selfish and Selfless Objects: identity vs transparency, and pass-by-copy"
source_kind: web
source_url: http://erights.org/elang/same-ref.html
source_effective_url: https://erights.github.io/erights-org-website/elang/same-ref.html
source_fetched_via: mirror
source_content_sha256: 95878351747c7ff30439056002718ed330ca2e723c13ca901e85e666cea382c0
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, pass-style]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. This is the
  direct conceptual ancestor of Endo's pass-style split between pass-by-copy
  data and pass-by-reference Remotables. See concept selfless-and-selfish-objects.
---

## Abstract

E's distinction between **selfish** objects (which carry a unique identity, or
*self*, endowed at creation, so `==` compares object identity) and **selfless**
objects (which have no identity, so `==` compares contents). By default every
object is selfish, exactly as in Java, Smalltalk, and Python: two separately
constructed `<3, 5>` points are not the same. An object expression may instead
be declared *selfless* (in E, `implements PassByCopy`), but only after three
conditions are checked — **immutable**, **open state**, **open source** — whose
combination makes the object **transparent**. Declaring an object selfless makes
it immutable and transparent, makes it **pass-by-copy between vats**, makes its
sameness a contents comparison, and makes its selflessness apparent to others.
This is the conceptual ancestor of Endo's pass-style split between copyable data
and pass-by-reference Remotables.

## Selfish objects: identity-based sameness (the default)

```
? def makePoint(x, y) :any {
>   return def point {
>     to getX() :any { return x }
>     to getY() :any { return y }
>     to __printOn(out) :void { out.print(`<$x, $y>`) }
>   }
> }
? def a := makePoint(3, 5)
? def b := makePoint(3, 5)
? a == a   # true
? a == b   # false
```

`a == b` is false for the same reason Java/Smalltalk/Python would say false:
each newly created object has, besides its state and behavior, a unique
*identity* endowed by the act of creation. `==` is not asking "do `a` and `b`
point at objects with the same contents?" but "do `a` and `b` point at the same
object identity?" Such objects are **selfish**.

## Selfless objects: contents-based sameness

A selfless object gives up its identity and is compared by contents:

```
? pragma .enable("meta-scope")
? def makePoint(x, y) :any {
>   return def point implements PassByCopy {
>     to getX() :any { return x }
>     to getY() :any { return y }
>     to openState() :any { return meta.getState() }
>     to openSource() :any { return meta.context().getOptSource() }
>     to __printOn(out) :void { out.print(`<$x, $y>`) }
>   }
> }
? def c := makePoint(3, 5)
? def d := makePoint(3, 5)
? def e := makePoint(7, 5)
? c == c   # true
? c == d   # true
? c == e   # false
```

`c` and `d` are simply `<3, 5>` points "with no other hidden information," so
they are the same.

## The three conditions for selflessness

A selfless declaration is accepted as valid only after three conditions hold of
the object expression's *instance variables* (variables used inside the object
expression whose definition is outside it, but not in the universal scope):

1. **Immutable.** All instance variables must be `final` (though the values they
   hold may themselves be mutable objects).
2. **Open State.** There must be an `openState` method (exactly as shown) that
   hands the caller the object's current scope, that is, its instance variables.
   Objects are normally *encapsulating* (they keep instance variables private);
   Open State makes a selfless object *non-encapsulating*.
3. **Open Source.** There must be an `openSource` method (exactly as shown) that
   hands the caller the source of the enclosing named object expression. Objects
   are normally *polymorphic* (external behavior does not determine the
   implementation); Open Source makes a selfless object *non-polymorphic*.

An object that is both open state and open source is **transparent**.

## Why transparency licenses copying

By being immutable, if `c`'s and `d`'s contents are the same now, they are the
same later. By being transparent, there are no encapsulated secrets a contents
comparison could reveal. Therefore it is safe for the object to give up its
identity and use contents for its sameness check. When an object is immutable and
identity-less, it cannot be distinguished from an equivalent copy of itself, so a
local implementation may freely copy such objects or collapse equivalent copies
into one. Crucially, an *encapsulating* object copied between machines would
leak its contents to an untrustworthy recipient, violating the encapsulation the
program expressed — so only *transparent* objects are safe to copy across vats. E
selfless objects are transparent, so a distributed implementation is free (and
in Reference Mechanics, often obliged) to copy them by value.

## Collections

```
? [2, 3] == [2, 3]              # true   (immutable list, contents-compared)
? def cl := [2, 3]
? def fla := cl.diverge()       # a mutable (flexible) copy
? def flb := cl.diverge()
? fla == fla                    # true
? fla == flb                    # false  (two distinct mutable objects)
? fla.snapshot() == flb.snapshot()   # true  (immutable snapshots, contents-compared)
```

Immutable collections are selfless (contents-compared); mutable (`diverge`d)
collections are selfish; an immutable `snapshot` of a mutable collection is
selfless again.

## Translation (E to Endo)

| E term | Endo / Hardened JavaScript equivalent |
|---|---|
| selfless object (`implements PassByCopy`) | pass-by-copy data: `CopyRecord` / `CopyArray` / `CopyTagged` (the "passable copy data" pass-styles) |
| selfish object | pass-by-reference remotable: `Far(...)` / `Remotable` (compared by identity) |
| transparent (open state + open source) | the marshal requirement that copy data expose its whole structure with no hidden state |
| pass-by-copy between vats | marshal serialization of copy data across a CapTP / OCapN boundary |
| `__printOn` | `Symbol.toStringTag` / the `@endo/marshal` printing path |

## Source

Source: [elang/same-ref.html](https://erights.github.io/erights-org-website/elang/same-ref.html) (mirror of `http://erights.org/elang/same-ref.html`), last modified 1998-10-03, content SHA-256 `95878351747c7ff30439056002718ed330ca2e723c13ca901e85e666cea382c0`, fetched via the erights.org GitHub Pages mirror.
