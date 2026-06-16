---
title: Abstract
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "14-19 (§4.5 Access Abstraction, §5 Confinement, §5.1 Non-Discretionary Model, §5.2 The *-Properties)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement
---

§4.5 names the **lost paradigm**: the object-capability model does not describe access control as a separate concern to be bolted on. It is a *model of modular computation with no separate access-control mechanisms*. All its support for access control "is well enough motivated by the pursuit of abstraction and modularity." Parnas's *information hiding* (1972) says abstractions should hand out information only on a *need-to-know* basis; POLA simply adds that authority should be handed out only on a *need-to-do* basis. Modularity and security each require both. §5 takes up Lampson's 1973 **confinement problem**: how to run an untrusted program in a controlled environment so it cannot leak its inputs. Cassie (the customer) and Max (the manufacturer) share a `[Factory, factoryMaker]` pair built with a *trademark* (FactoryStamp); Max packages his calculator code with `factoryMaker.make("...code...")`; Cassie's `acceptProduct(calcFactory)` instantiates the factory under Cassie's chosen state, confining it. §5.1 argues the resulting model is **non-discretionary**: in object-capability systems, even if Alice creates Carol, Alice may still only authorize Bob to access Carol if Alice has authority to access Bob — there are no principals with unconditional permission over what they create. §5.2 walks the **\*-property challenge** (Boebert 1984): the claim that an unmodified capability system cannot enforce one-way communication between subjects with different clearance levels. Cassie builds Q (a calculator over `diodeWriter`) and Bond (a calculator over `diodeReader`) connected through an assignable `diode` integer variable; Boebert's attack — Q sending a capability as an argument to `diodeWriter.write(val)` — fails because the `:int` guard on the `write` method rejects non-integer arguments. The *abstraction* enforces the property; the unmodified base model is *not* what enforces it. The paper's structural claim: this is *how* object-capability systems compose protection — through abstraction built on the base, not through new primitives.
