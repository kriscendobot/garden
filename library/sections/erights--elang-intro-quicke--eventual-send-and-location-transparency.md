---
title: "A 15 Minute Introduction to E: the eventually operator, location transparency, and pass-by-copy"
source_kind: web
source_url: https://erights.org/elang/intro/quickE.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/quickE.html
source_fetched_via: mirror
source_content_sha256: 0a9cec3ff648ad327f7320b47ede7b8be1820c950e0b338f6a19f6ce874a6a55
source_authors: [Marc Stiegler]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: |
  Section 2 of 4 from Marc Stiegler's "15 Minute Introduction to E". The eventually
  operator `<-`, send-vs-call, location transparency, deadlock-freedom, the
  unguessable-URI capability-security argument, and pass-by-copy of immutables.
  Companion sections: overview-and-conventional-subset,
  promises-when-catch-and-far-references, bootstrapping-remote-references.
---

## Abstract

The heart of the 15-minute intro: E's **eventually operator** `<-` (the *eventual send*), contrasted with the ordinary *immediate call*. `car <- moveTo(2,3)` reads "car, eventually moveTo(2,3)": the send is dispatched and the program moves on immediately without waiting, unlike the immediate call `car.moveTo(2,3)`. This section captures the four consequences the document draws from that one operator. (1) **Location transparency**: you "do not know, and do not need to know, where the car is" — local or a thousand miles away; E tracks its location and delivers the message. (2) A **capability-security** argument: when the car is remote, E sets up a secure link, and because the car's URI includes "an unguessable random string of characters," no one can message it or extract information from it except someone who was intentionally given a reference, so "a computation running on five computers scattered across five continents ... can be as secure as a computation running on a box locked in your basement." (3) **Deadlock can never occur** with sends, because the program never waits. (4) The sender does not know or need to know whether the invoked object uses calls or sends, or whether the invoker is local or remote — the object author just writes ordinary methods. It also states the **pass-by-copy** rule for immutables (integers, floats, booleans, arrays, ConstLists, ConstMaps) versus mutable objects (like cars) that stay on their home machine. Use this to ground any claim about E's send-vs-call distinction, its location transparency, why E sends are deadlock-free, or how unguessable capability URIs make wide-area E computations secure.

## The eventually operator

E starts its unique features with the eventually operator, `<-`:

```e
car <- moveTo(2,3)
println("car will eventually move to 2,3. But not yet.")
```

The first statement reads "car, eventually moveTo(2,3)". As soon as the *eventual send* is made, the program "immediately moves on to the next sequential statement — the program does not wait for the car to move." This makes an eventual send "very different from a traditional object-oriented method call (referred to here as an *immediate call* to distinguish it from an eventual send; the statement `car.moveTo(2,3)`, shown earlier, is an immediate call)." In general "you do not know, and cannot know, exactly when the car will move"; and if the car is remote and the communication link is lost, the car may never move at all (throwing an exception, discussed in the promises section).

## Location transparency and the capability-security argument

The "most interesting feature of an eventual send" is that, just as you do not know *when* the operation completes, "you also do not know, and do not need to know, *where* the car is." The car could be local or "on a computer a thousand miles away across the Internet." Either way "E keeps track of the car's location and delivers the message for you."

The security consequence is stated directly: if the car is remote, E "sets up a secure communication link between the program and the car; and since the Universal Resource Identifier for the car includes an unguessable random string of characters, no one can send a message to the car or extract information from the car except someone who has explicitly and intentionally received a reference to it from someone with authority." The conclusion: "a computation running on five computers scattered across five continents, all publicly accessible by the whole world of the Web, can be as secure as a computation running on a box locked in your basement." This is the capability-security model expressed at the level of distributed references: authority travels only with the (unguessable) reference, and references are only handed out intentionally.

## Deadlock-freedom and uniform method authorship

Two further consequences. First, "because the program continues on to the next statement immediately, without waiting for the eventual send to finish, deadlock can never occur." Second, the eventual send invokes an *ordinary* object method (`moveTo(x,y)`): the programmer who wrote `carMaker` defines cars with ordinary methods returning ordinary values (or `null`). That author "does not know and does not need to know whether objects that invoke those methods use calls or sends, and does not know or need to know whether those invoking objects are local or remote." The send/call and local/remote distinctions live entirely at the call site, not in the method definition.

## Pass-by-copy of immutables, home-machine residency of mutables

When you resolve a remote result (see the promises section), the kind of object you get back depends on its mutability. "Immutable objects, such as integers, floating point numbers, booleans, arrays, and the E data structures ConstLists and ConstMaps, are always passed by copy, so you always get a local copy of the object if one of these is returned by a method call or send." That local copy can accept immediate calls. By contrast, "mutable objects like cars reside on the machine upon which they were constructed." So "if you created the car using an eventual send, you will probably have to interact with the car using eventual sends forever, since only such sends are guaranteed to work with remote objects." This pass-by-copy-for-immutables / stay-home-for-mutables rule is why a resolved integer temperature is locally callable even when the car that produced it is remote.

## Translation

| quickE (E vat language) | Endo / modern equivalent |
|---|---|
| eventual send `obj <- method(args)` | `E(obj).method(args)` from `@endo/eventual-send` |
| immediate call `obj.method(args)` | immediate (synchronous) method call (same notation) |
| unguessable capability URI | the unforgeable object reference / ocap reference; see [[object-capability]] |
| ConstList / ConstMap (pass-by-copy immutables) | hardened pass-by-copy data (CopyArray / CopyRecord in `@endo/marshal`) |

Source: [elang/intro/quickE.html](https://erights.github.io/erights-org-website/elang/intro/quickE.html) via the erights.github.io mirror; content SHA-256 `0a9cec3f`.
