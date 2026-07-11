---
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/05/what-are-capabilities/
source_content_sha256: e16d5cf32c414a9030be031eb61e56e4c80a0fa9d1110c58ed7701d1d123f66f
source_author: Chip Morningstar
source_date: 2017-05-07
retrieved: 2026-07-11
ingested: 2026-07-11
ingested_by: scholar
section_count: 7
status: current
notes: |
  Second ingest from **habitat-chronicles.com** (the dashed live domain; the non-dashed
  `habitatchronicles.com` is STALE/dead — always cite the dashed form). Chip
  Morningstar's canonical, plain-language **object-capability explainer** — the "here,
  read this" introduction Alan Karp lamented the ocap literature lacked. ~77k chars, H3
  structure (Some preliminary remarks / The idea / Getting more precise / Capability
  patterns / What can we do with this? / Conclusion). Fetched live
  (`source_fetched_via=direct`); the content hash is the idempotency anchor.
  Cross-links the `object-capability`, `granovetter-operator`, `principle-of-least-
  authority`, `caretaker-pattern`, and new `confused-deputy` concepts, and the sibling
  habitat-chronicles essay's `habitat-unum` concept (both authored by Morningstar).
  Ingested under maintainer job `scholar-ingest-source-habitat-chronicles-2`; a follow-on
  `-3` job carries the rest of the germane set (A Slightly Skeptical Perspective on REST,
  The Tripartite Identity Pattern, Adventures in LLM Land).
---

## Abstract

Chip Morningstar's canonical plain-language introduction to **object capabilities
(ocaps)** — written at Alan Karp's prompting as the accessible "here, read this" the ocap
literature lacked. The essay disarms the confusing word "capabilities," motivates the
"ocap" contraction via the natural alignment with object-oriented programming, and builds
the core argument around Norm Hardy's admonition **"don't separate designation from
authority."** Through the Microsoft Word "Save" example it shows why the **ACL** model is
fatally flawed (an application you run can do anything you can do) and why handing an app
a **capability** (a file handle) instead of a forgeable pathname fixes it with identical
UX; it retells Hardy's **Confused Deputy** (the FORTRAN compiler tricked into overwriting
the billing file) as the canonical illustration of **ambient authority**, noting 5–8 of
the OWASP top 10 are confused-deputy problems. It then gets precise (a capability
*designates and authorizes* in one object; capabilities are **transferable** → delegation,
and **unforgeable**; the three ways to acquire one — **creation, transfer, endowment**),
develops four compositional **capability patterns** (modulation/**revoker**,
**attenuation**, abstraction/**POLA**, combination), and surveys four incremental adoption
paths (embedded systems — **KeyKOS**, **seL4**; compartmentalized computation —
virtualization and **Frozen Realms**, the ancestor of SES/lockdown; distributed services —
the **service-chaining** problem, Mint, Karp's Zebra Copy, OAuth2 bearer tokens; and
software-engineering practices — the **three rules for taming Java**, Joe-E, and the
fewer-bugs discovery). The conclusion frames capabilities as **computer security's germ
theory** and argues the identity-centric "who are you?" question is incoherent. Deeply
germane to the garden's ocap lineage: Frozen Realms → Endo SES/lockdown, taming → SES
intrinsic taming, service-chaining/OAuth2 → the gateway delegated-access work; the
acknowledgements name Norm Hardy, Alan Karp, Mark Miller, Kevin Reid, and Kris Kowal.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [What Are Capabilities? — preliminary remarks and the term itself](../sections/habitat-chronicles--what-are-capabilities--overview.md) | capability-theory | current |
| [The idea — don't separate designation from authority (and the Confused Deputy)](../sections/habitat-chronicles--what-are-capabilities--designation-and-authority-the-idea.md) | capability-theory, capability-security | current |
| [Getting more precise — what a capability is; creation, transfer, endowment](../sections/habitat-chronicles--what-are-capabilities--what-a-capability-is.md) | capability-theory, capability-security | current |
| [Capability patterns — modulation, attenuation, abstraction, combination](../sections/habitat-chronicles--what-are-capabilities--capability-patterns.md) | capability-security, patterns | current |
| [What can we do — embedded systems and compartmentalized computation](../sections/habitat-chronicles--what-are-capabilities--embedded-and-compartmentalized-computation.md) | capability-security, hardened-javascript | current |
| [What can we do — distributed services and software engineering practices](../sections/habitat-chronicles--what-are-capabilities--distributed-services-and-engineering-practices.md) | capability-security, hardened-javascript | current |
| [Conclusion — capabilities as computer security's germ theory](../sections/habitat-chronicles--what-are-capabilities--conclusion.md) | capability-theory | current |
