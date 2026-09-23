---
title: What can we do — embedded systems and compartmentalized computation
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/05/what-are-capabilities/
source_content_sha256: e16d5cf32c414a9030be031eb61e56e4c80a0fa9d1110c58ed7701d1d123f66f
source_author: Chip Morningstar
source_date: 2017-05-07
ingested: 2026-07-11
ingested_by: scholar
topics: [capability-security, hardened-javascript]
status: current
---

## Abstract

The first two of Morningstar's four **incremental adoption paths** — ways to get value
from capabilities *without* first replacing the entire installed base (which gets
replaced only gradually, by small local changes, never by an authoritative master
plan). **Embedded systems**: capability principles are a good way to organize an OS, and
the two noteworthy examples are **KeyKOS** (1980s, IBM mainframes, Key Logic — a
fully capability-secure OS with a high-performance *orthogonal persistence* mechanism
that let processes run for years, in a few cases spanning replacement of the underlying
computer; inspired EROS, CapROS, Coyotos) and **seL4** (a from-scratch, KeyKOS-
influenced secure L4 microkernel with a **formal proof of functional correctness**, now
used in military avionics). Embedded/IoT is fertile ground because it is less
constrained by legacy interoperability and is cross-developed anyway, and because its
mission-critical reliability needs make capability assurances attractive — the massive
least-privilege violation in typical IoT firmware (app code with complete device access)
is exactly what a capability OS fixes "as a consequence of developers simply following
the path of least resistance." **Compartmentalized computation**: Norm Hardy's quip
that "the last piece of software anyone ever writes for a secure, capability OS is
always the Unix virtualization layer" points at the benefit even in a Linux world —
run Linux *on seL4* to get a solid virtualization base (an "island of sanity" for
datacenter operators, transparent to customers). Crucially, the same island-of-sanity
idea applied to the JavaScript execution environment is **Frozen Realms** (then working
through TC39) — the direct ancestor of Endo's SES/lockdown: create an isolated realm,
configure it, **lock it down so it is henceforth immutable**, then load mutually-
suspicious code that can only affect each other via passed object references, enabling
**defensively consistent** software.

## Content

Morningstar has praised the capability approach but repeatedly noted it is not how
contemporary systems work — so what use is it "absent some counterfactual universe of
technical wonderfulness"? Several ways deliver value without replacing the installed
base first. "This is not to say that the installed base never gets replaced, but it's a
gradual, incremental process ... driven by small, local changes rather than by the
unfolding of some kind of authoritative master plan." He offers four salient areas;
this section covers the first two. The hope is that immediate value biases practitioners
positively, "shaping the incentive landscape so it tilts towards a less dysfunctional
software ecosystem."

**Embedded systems.** "Capability principles are a very good way to organize an operating
system." Two noteworthy examples:

- **KeyKOS** — developed in the 1980s for IBM mainframes by Key Logic (a Tymshare
  spinoff). Besides being fully capability-secure, it attained extraordinarily high
  reliability via "an amazing, high performance **orthogonal persistence** mechanism that
  allowed processes to run indefinitely, surviving things like loss of power or hardware
  failure." Some commercial installations "had processes that ran for years, in a few
  cases even spanning replacement of the underlying computer." KeyKOS inspired **Eros,
  CapROS, and Coyotos**; the code is "out there for the taking."
- **seL4** — a secure variant of the L4 OS from NICTA (Australia); a from-scratch design
  "heavily influenced by KeyKOS," notable for a **formal proof of functional
  correctness**, making it "an extremely sound basis for building secure and reliable
  systems," with inroads into military avionics. Open source, proofs included.

Why embedded/IoT is fertile ground: it is "sometimes less constrained by installed base
issues" (standalone products, narrow functionality, fewer legacy-interoperability
points), it is cross-developed anyway (you keep your existing toolchain), and it is often
mission-critical, so reliability and security can "take priority over cost
minimization." Recent IoT security incidents stem from application code having "complete
access to everything in the device, largely as a convenience to the developers" — "a
massive violation of least privilege." Compartmentalizing would help but usually does not
happen, partly through ignorance and mostly because "the effort and inconvenience
involved ... doesn't seem justified by the payoff." A capability OS tilts the balance by
delivering "desirable security and reliability properties as a consequence of developers
simply following the path of least resistance."

**Compartmentalized computation.** Norm Hardy's quip: "the last piece of software anyone
ever writes for a secure, capability OS is always the Unix virtualization layer" — "a
depressing testimony to the power that the installed base has," but also a hint at the
benefit. In cloud computing, virtualization is how everything gets done, and
**safety-through-compartmentalization** is a key selling point: a compromised VM does not
give the attacker adjacent VMs on the same hardware. The isolation idea is old — "it is
to computer science what vision is to evolutionary biology, an immensely useful trick
that gets reinvented over and over again" — but virtualization adds operator control over
version/configuration issues (run whatever Linux, or whatever OS, per VM). And you can run
**Linux on seL4**: mainstream OSes have structural vulnerabilities and inevitably get
breached, and breaching the OS that runs the virtualization layer means breaching all
hosted VMs; "initial indications are that seL4 makes a much more solid base for the
virtualization layer," while the bulk of code keeps running in its familiar environment.
This gives datacenter operators "a safe place to stand" — an **island of sanity** — that
customers benefit from transparently ("they need not even be aware that you've done it").

The island-of-sanity idea is "not limited to hardware virtualization." **"Frozen
Realms"**, then "working its slow way through the JavaScript standardization process," is
"a proposal to apply ocap-based compartmentalization principles to the execution
environment of JavaScript code in the web browser." The stock JS environment is "highly
plastic" — code can rearrange, redefine, and extend everything — which is both blessing
(a shim can patch an older engine to emulate newer features; "this malleability is
essential to how the language evolves without breaking the web") and curse ("it's very
easy for one chunk of code to undermine the invariants that another part relies on").
Frozen Realms lets you "create an isolated execution environment, configure it with
whatever modifications and enhancements it requires, **lock it down so that it is
henceforth immutable**, and then load and execute code within it." A goal is
**defensively consistent** software — "code that can protect its invariants against
arbitrary or improper behavior by things it's interoperating with." You can load
independent pieces from separate, mutually-distrusting developers into a common realm and
let them interact safely: "Ocaps are key to making this work. ... Because the environment
is immutable, the only way pieces of code can affect each other is via object references
they pass between them. Because all external authority enters the environment via object
references originating outside it, rather than being ambiently available, you have control
over what any piece of code will be allowed to do. Most significantly, you can have
assurances about what it will not be allowed to do."

*(Library note: Frozen Realms is the direct conceptual ancestor of Endo's **SES /
lockdown** — the Hardened JavaScript substrate this library documents extensively under
the `hardened-javascript` topic. Morningstar's 2017 description of "configure the realm,
then lock it down immutable, then load mutually-suspicious code" is exactly the
`lockdown()` + Compartment shape SES later standardized.)*

Source: [What Are Capabilities?](https://habitat-chronicles.com/2017/05/what-are-capabilities/) by Chip Morningstar, 2017-05-07 (content sha256 `e16d5cf3`).
