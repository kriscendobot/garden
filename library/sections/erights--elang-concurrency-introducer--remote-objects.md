---
title: "Introducing Remote Objects"
source_kind: web
source_url: https://erights.org/elang/concurrency/introducer.html
source_effective_url: https://erights.github.io/erights-org-website/elang/concurrency/introducer.html
source_fetched_via: mirror
source_content_sha256: aaa19683547437e7e9e926472b1e5cca6f53f8d0667727fcb806167ef94b0e62
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-security, capability-theory, eventual-send, captp]
status: current
notes: Primary erights.org tutorial chapter on distributed/secure E programming — the introducer, live vs sturdy references, capability URIs, and the eventually-operator. The historical primary source behind the live-reference / sturdy-reference / locator hierarchy that CapTP and Endo carry forward; the worked Granovetter introduction across two processes. Reachable via the GitHub Pages mirror.
---

## Abstract

The E tutorial's chapter on **secure distributed object programming**: how an object in one E process is shared with another over the cryptographic Pluribus protocol, and the historical primary source for the **live-reference / sturdy-reference / capability-URI** hierarchy that CapTP and Endo's locator model carry forward. It introduces the **`introducer`** (the per-vat object turned `onTheAir()` to enable distribution), the distinction between a **live reference** (passes messages, but breaks on communications failure) and a **sturdy reference** (does not pass messages and does not break — it can re-obtain a live reference after a partition), the **capability URI** (`cap://host:port/<swiss-number>`, "unique cryptographic information specific to the sharing of this individual object") produced by `introducer.sturdyToURI(sr)` and consumed by `introducer.sturdyFromURI(uri)`, and the **eventually-operator `<-`** for asynchronous sends to deferred (remote) references — because "references to objects in other processes are deferred references, and do not support synchronous calls." It frames the whole exchange as **the Granovetter Diagram with a human Alice**: when Alice is a person rather than an object, the eright to access Carol (the counter) must be represented as a URI that can travel outside E computation. Its closing point is the capability discipline in miniature: sharing a `counter` object grants exactly the eright to increment and read `x` and no other authority over the holding process. Use this to ground claims about E's distributed-reference model, the live/sturdy distinction, capability URIs, or the eventual-send-only-for-remote-references rule that Endo inherits.

## Walkthrough

**Going on the air.** Distributed E starts from the `introducer`, present in the initial name-space. Printed, it reads `<Off The Air>` (distribution-capable but not yet enabled), `<On The Air ...>`, or `null` (a space-local, non-distributed subset of E). Enabling it:

```e
? introducer.onTheAir()
# value: ["3DES_SDH_M2", "3DES_SDH_M"]

? introducer
# value: <On The Air ["3DES_SDH_M2", "3DES_SDH_M"]>
```

The bracketed list is the set of protocols the process speaks (the chapter notes `daffE`, a crypto-crippled export variant, advertises `["AUTH_SDH_M", "NONE_SDH_M"]` instead). Demonstrating distribution needs a second process (`VatA` and `VatC` in the transcript), each brought on the air the same way; the two may be on one machine or two, provided they can reach each other over TCP/IP.

**A live reference, then a sturdy reference.** A shared `counter` object closes over a variable `x`:

```e
? var x := 0
? def counter {
>     to incr() :any {
>         x += 1
>     }
> }
? counter.incr()
# value: 1
```

The variable `counter` holds a **live** (normal) reference. To share the object across processes, a **sturdy** reference is made:

```e
? def sr := makeSturdyRef.temp(counter)
# value: <SturdyRef to <counter>>
```

The chapter motivates the two kinds: once distributed, you "have to put up with communications failure, like losing a phone connection." Messages sent over a **live** reference are delivered reliably and in order *unless the reference breaks* (which it does if a partition prevents the processes from continuing to talk). A **sturdy** reference, by contrast, does not break and does not pass messages — it "gives us the ability to ask for a new live reference in case the old one fails."

**Turning a reference into a string (the capability URI).** A sturdy reference is serialized to a URI for transmission outside E:

```e
? def uri := introducer.sturdyToURI(sr)
# example value: cap://127.0.0.1:1107/080nrRvgvO8fMq...
```

"The particulars of the URI string will differ each time, as this string encodes unique cryptographic information specific to the sharing of this individual object." The URI is conveyed to the other process by any out-of-band means (a shared file, copy-paste, or, where security matters, a PGP-encrypted email — "E ensures that all further communication between these processes remains secure" once the string is delivered safely). The chapter names this **the act of initial introduction** and maps it onto the **Granovetter Diagram**: the `counter` is Carol, the second process is Bob, and the human operator is Alice; when Alice is human the eright must be represented as the URI so it can be transferred outside of E computation.

**Turning the string back into a reference, and eventual-send.** The receiving process reconstructs a sturdy reference and then a live one:

```e
? def sr := introducer.sturdyFromURI(uri)   // works even while partitioned — that is what "sturdy" means
? def remote := sr.getRcvr()
# value: <Remote Promise>

? remote.incr()
# problem: Failed: not synchronously callable
```

Remote references are **deferred** and reject synchronous calls; the **eventually-operator `<-`** does an asynchronous send returning a promise:

```e
? def val := remote <- incr()
# value: <Remote Promise>
? interp.waitAtTop(val)
? val
# value: 2
```

**The capability discipline in miniature.** Sharing the `counter` granted the second process exactly "the electronic right (or *eright*) to increment the variable `x`, and to see its value after incrementing, but ... no other rights." Resetting `x := 1` in the first process is not something the second process can do — "By defining, and sharing, the counter object, we have defined, and shared, a new limited eright over the variable `x`." Authority is exactly the object interface, nothing more: the connectivity-begets-connectivity rule made concrete across a network.

## See also

- [erights--elang-intro--tutorial-overview](erights--elang-intro--tutorial-overview.md): the tutorial index that lists this chapter.
- [granovetter-operator](../concepts/granovetter-operator.md): the three-party reference-passing step this chapter enacts across two processes with a human Alice.
- [object-capability](../concepts/object-capability.md): the only-connectivity-begets-connectivity model the closing eright argument illustrates.
- [endo--designs-dp--six-aspects-of-sharing-and-related-work](endo--designs-dp--six-aspects-of-sharing-and-related-work.md): Endo's daemon-persistence design situating the live-reference / sturdy-reference / locator hierarchy this chapter originates within the CapTP lineage.
- [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md): the 2005 formalization of the vat / eventual-send / reference-state model this tutorial chapter introduces informally.
- [ocap-history--e-capdesk-polaris-market-history](ocap-history--e-capdesk-polaris-market-history.md): the library's E / CapDesk / Polaris survey this primary source grounds.

Source: [elang/concurrency/introducer.html](https://erights.org/elang/concurrency/introducer.html), fetched 2026-06-27 via the erights.org GitHub Pages mirror ([erights.github.io/erights-org-website/elang/concurrency/introducer.html](https://erights.github.io/erights-org-website/elang/concurrency/introducer.html)), content SHA-256 `aaa196835474`.
