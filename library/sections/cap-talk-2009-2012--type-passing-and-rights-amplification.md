---
title: "Type-passing and whether it is rights amplification"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-April.txt.gz
source_content_sha256: f28a7548e567b27ebc011f3f9ada2db5c782e5f6867a33eb70614f9e5aa258a1
source_authors: [Sandro Magi, David Barbour, Toby Murray]
source_date: 2011-04-14 to 2011-04-18
thread_subject: "Type-passing and capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [programming-language-design, capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages. A spin-off of the immutable-data thread."
---

Abstract: A sidebar spun out of the immutable-data debate asks whether passing a function together with its argument is a rights amplification. Sandro Magi contrasted ordinary method dispatch, where an object `foo` is invoked as `foo.Bar()`, with function-parameter invocation, where a caller supplies both `foo` and a function `bar` and the callee runs `bar(foo)`. Someone in the earlier thread had claimed the second form violates capability properties by amplifying rights. Magi argued it does not: rights amplification occurs when two or more objects combined yield more power than either alone, and a plain function applied to an argument does not do that. He further claimed the two forms are inter-translatable using the standard existential-type encoding of objects, so a single-type-parameter function signature can be modeled either way. David Barbour agreed the amplification claim was wrong but rejected the equivalence claim, on the same implementation-versus-abstraction ground that ran through the parent thread: a reversible *representation* is a homomorphism, not an isomorphism, so modeling method dispatch as function invocation does not make one syntactic sugar for the other.

## The two forms and the amplification question

Magi set out two shapes. Method dispatch hands the callee one object and lets it invoke a method: `void UseFoo(T foo) { foo.Bar(); }`. Function-parameter invocation hands the callee both an object and a function over that object: `void UseFoo(T foo, T->void bar) { bar(foo); }`. The disputed claim was that the second form amplifies rights. Magi's rebuttal defines rights amplification precisely as the case where combining two or more references yields authority neither confers alone (the sealer/unsealer box-and-key pattern is the canonical example). Applying an ordinary function to an ordinary argument produces only the authority the function already had over arguments of that type, so no amplification arises. Toby Murray found Magi's argument convincing and asked Barbour to justify the objection.

## Homomorphism, not isomorphism

Barbour conceded the amplification point but denied that the two forms are equivalent. He granted that method dispatch can be *modeled* as function invocation through the existential-type encoding of objects (the standard construction Magi cited from the type-theoretic foundations of object-oriented programming), but insisted the modeling is one-directional in force: the ability to model (1) as (2) does not deliver the ability to model (2) as (1) with the same guarantees, so what exists is a homomorphism, not an isomorphism or a stronger equivalence. His analogy: numbers can be represented by strings (`42` as `"42"`) and the few instances generated can be reversed, but numbers are not therefore sugar for strings. Magi narrowed his claim to signatures where a single type parameter appears once per function parameter, and argued that in E, whose objects can collect and forward arbitrary messages, the equivalence does hold operationally. The disagreement is the same one that produced the immutable-data thread: whether a faithful representation collapses the distinction between the abstraction and its model.

## Bearing on Endo

The precise definition of rights amplification the thread converged on (authority that arises only from *combining* references) is the property Endo preserves and audits. Passing a function and its argument is safe because it composes only authorities already granted; the sealer/unsealer and `WeakMap`-keyed private-state patterns are the deliberate, audited exceptions where combination is the point. Barbour's homomorphism caution also bears on Endo's membrane and marshaling code: a wire encoding that faithfully round-trips a reference is not thereby interchangeable with the reference, because the encoding drops the identity and behavior that make the reference a capability. Treating a reversible representation as an identity of abstractions is exactly the confusion the `passStyle` boundary exists to prevent.

Source: [cap-talk 2011-April archive](http://www.eros-os.org/pipermail/cap-talk/2011-April/) (Internet Archive original-bytes `id_` snapshot of `2011-April.txt.gz`, sha256 `f28a7548`), thread "Type-passing and capabilities", 2011-04-14 to 2011-04-18.
