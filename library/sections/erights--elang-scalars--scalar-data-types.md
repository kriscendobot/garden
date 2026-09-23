---
title: "Scalar Data Types: E's four immutable scalars plus null"
source_kind: web
source_url: http://erights.org/elang/scalars/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/scalars/index.html
source_fetched_via: mirror
source_content_sha256: fb0919915d6638c86e0e671d329e982d85f2f9b80b52d23266ec3bccebf2f86b
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, pass-style]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The landing page
  of E's *Primitive Data Types / Scalars* chapter. Its substantive content is the
  four-scalars table (with the original Java class correspondences) plus the
  pass-by-copy-across-the-network property of all scalars. The per-type child
  chapters (integer-ref, float64-ref, boolean-ref, char-ref) are not ingested;
  they are navigable from the source page and queued only if a reader needs the
  per-type method detail.
---

## Abstract

E's **Scalar Data Types** chapter names E's primitive immutable values: the four
scalar types `integer`, `float64`, `boolean`, and `char`, plus the special scalar
value `null`. All scalars are immutable (the page's rhetorical question: "what
would it mean to change the number 3?") and all scalars are **pass-by-copy across
the network** — a scalar argument sent in a message to an object on another
machine arrives as a local copy, not a remote reference. This is the data-type
floor of E's selfless / pass-by-copy story (`selfless-and-selfish-objects`) and
the direct ancestor of the primitive pass-styles in Endo's marshal (`number`,
`bigint`, `boolean`, `string`, `null`, `undefined`). The original page documents
each scalar against the Java object class it was implemented over (E ran on the
JVM), which is historical implementation detail rather than language semantics.

## The four scalars plus null

E has only four scalar data types: `integer`, `float64`, `boolean`, and `char`.
In addition there is the special scalar value `null`. All scalars are immutable;
the chapter motivates this with the rhetorical "what would it mean to change the
number 3?".

In E's original JVM implementation the scalars corresponded to existing Java
classes, and for methods they had in common the reader was directed to the
Javadoc for those classes. The correspondences (historical implementation
detail):

| E Type | Java Object Class | Java Scalar Type |
|--------|-------------------|------------------|
| `integer` | `java.math.BigInteger` | *none* |
| `float64` | `java.lang.Double` | `double` |
| `boolean` | `java.lang.Boolean` | `boolean` |
| `char` | `java.lang.Character` | `char` |

Two points of E-versus-Endo interest survive the JVM framing: E's `integer` is a
**bignum** (`java.math.BigInteger`, arbitrary precision, no fixed width — the same
choice Endo's marshal makes for `bigint`), and `float64` is the IEEE double, whose
reflexive `==` (NaN equals NaN under E sameness) is handled in the *Semantics of
"Same"* chapter (`erights--elang-same-ref--synchronous-sameness-and-reflexivity`),
not here.

## Pass-by-copy across the network

All the scalars are **pass-by-copy across the network**. If object Alice on one
machine sends object Bob (on another machine) a message that has `3` as an
argument, the `3` is copied from Alice's machine to Bob's machine, so Bob receives
a message whose argument is a local `3`. Scalars are therefore the simplest
members of E's selfless / pass-by-copy category: immutable transparent values that
travel between vats as copies rather than as references (compare
`selfless-and-selfish-objects` for the general selfless rule, and `pass-by-construction`
for E's full PassByCopy / PassByProxy / PassByConstruction taxonomy).

## Translation

| E term | Endo / Hardened JavaScript equivalent |
|--------|----------------------------------------|
| `integer` (arbitrary-precision) | `bigint` pass-style (marshal) |
| `float64` | `number` pass-style |
| `boolean` | `boolean` pass-style |
| `char` | no direct equivalent; JavaScript has only `string` |
| `null` | `null` (and the adjacent `undefined`) pass-style |
| pass-by-copy across the network | pass-by-copy marshal of primitive pass-styles |

Source: [elang/scalars/index.html](https://erights.github.io/erights-org-website/elang/scalars/index.html) (erights.org GitHub Pages mirror), content SHA-256 `fb091991`, last modified 1998-10-03.
