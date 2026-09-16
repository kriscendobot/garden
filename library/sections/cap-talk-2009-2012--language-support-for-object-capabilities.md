---
title: "What language support for object capabilities is worth building in"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-August/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-August.txt.gz
source_content_sha256: 4ca3b6e33d5cc168c95c13ed89ec705558a69e74b609b18c2a7269bff79bc00f
source_authors: [David Nicol, Kevin Reid, Mike Samuel, Rob Meijer, Raoul Duke, David Barbour]
source_date: 2011-08-12 to 2011-08-13
thread_subject: "designing new language"
ingested: 2026-09-16
ingested_by: scholar
topics: [programming-language-design, hardened-javascript, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: David Nicol, designing a new programming language, asked cap-talk for "The Big Wishlist" of capability features and floated baking a `newcap = delegate(cap)` primitive into the language. Kevin Reid's reply became the thread's center: baking delegation-and-derivation into the language is the wrong idea, because the pattern of "create a derived cap for delegation" should be a rare, library-level facility, not a default, and most of the time you should be working with objects narrow enough that no independent revocation is needed. The language support that *does* matter, Reid argued, is a short list: strong encapsulation with clearly-stated public interfaces; immutable-by-default objects and variables; the ability to define multiple-facet objects cheaply (a constructor that must return exactly one object makes faceted abstractions tedious); and interposition/virtualizability, so a programmer can write generic message receivers and build membranes. Reid also drew the capability boundary sharply: any implicit parameter that carries authority and is not fully controlled by the caller (JavaScript's `this`, or a callee learning the caller's "location") breaks the capability model. Rob Meijer offered a parallel wishlist emphasizing everything-is-an-object, no globals or singletons, message-passing-only concurrency, and move (linear) semantics by default.

## Design security in, do not add it on

Reid's framing is the load-bearing lesson: "capability design should not be about adding security elements to your program, but about your program being built out of components whose design results in robustness and security." A `delegate()` primitive treats security as a bolt-on operation; the capability approach treats it as a consequence of ordinary composition. The corollary is that the language's job is to make the *safe* composition cheap and the *unsafe* composition visible, not to provide security operators.

The concrete list of what a capability language should make cheap:

- **Strong encapsulation and reviewable public interfaces.** Given an object, you cannot reach its internals except through the facilities it itself provides; and when defining an object it is easy to see and review exactly what those facilities are. Without encapsulation there is no useful capability system, because objects cannot hide state and so cannot refine their authority.
- **Immutable-by-default objects and variables.** Mutation is the exception you opt into.
- **Cheap multiple-facet objects.** Creating a new *thing* should not force you to return exactly one object, the way constructor-based OO does. A sealer and an unsealer, a read-only and a read-write view, the two ends of a pipe, the two sides of a protocol adapter, and the view-from-above and view-from-below of a tree node are all one conceptual thing with several references, and defining them should not be tedious.
- **Interposition / virtualizability.** The ability to write generic message receivers, so a programmer can build membranes that transform every message crossing a boundary (not merely revoke) between two object subgraphs. Reid warned this has far-reaching consequences for any type system.

## No authority-carrying implicit parameters

Reid's sharpest boundary: a callee may receive information about the caller only if that information can be modeled as an implicit parameter that the caller *fully controls*. The moment an implicit parameter can carry authority the caller did not choose to convey, you have left the capability model, and (worse) you have an especially hazardous system, because the leak is invisible at the call site. Reid named JavaScript's `this` as exactly this hazard (attributing the observation to Mark Miller at that week's friam meeting). Perl's context system was cited as an acceptable design because its implicit context is both modelable as a parameter and fully caller-controlled.

## Bearing on Endo

This thread is a 2011 statement of the exact philosophy SES and Endo implement. "Design security in, do not add it on" is the lockdown-and-`harden` discipline: authority is what you can reach, so you constrain reachability by construction rather than adding permission checks. Reid's four language features map directly onto the Hardened JavaScript surface: strong encapsulation is closures plus frozen objects; immutable-by-default is `harden()` and frozen primordials; cheap multi-facet objects are the Far/exo record-of-methods and the sealer/unsealer and read-only-view patterns SES ships; and interposition is the Proxy-based membrane. The `this`-carries-authority hazard is precisely why SES tames or removes the ambient `this` binding and why Endo code prefers explicit parameter passing. Reid's rejection of a built-in `delegate()` is why Endo has no delegation operator: attenuation is done by handing out a narrower facet written in ordinary code, and revocation is a membrane or caretaker library, not a language keyword.

Source: [cap-talk 2011-August archive](http://www.eros-os.org/pipermail/cap-talk/2011-August/) (Internet Archive original-bytes `id_` snapshot of `2011-August.txt.gz`, sha256 `4ca3b6e3`), thread "designing new language", 2011-08-12 to 2011-08-13.
