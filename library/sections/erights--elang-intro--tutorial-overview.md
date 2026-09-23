---
title: E Language Tutorial
source_kind: web
source_url: https://erights.org/elang/intro/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/index.html
source_fetched_via: mirror
source_content_sha256: dac38ec2f0b3f3bba88d2f28e26704b23552c0f32d540811438ddc8453f7daff
source_authors: [Mark S. Miller, Marc Stiegler]
source_date: 2026-06-27
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: Primary erights.org source for the E language's pedagogy, reachable again via the GitHub Pages mirror. Companion to the index page [erights--elang-index--overview](erights--elang-index--overview.md) and grounds the secondary-source survey [ocap-history--e-capdesk-polaris-market-history](ocap-history--e-capdesk-polaris-market-history.md).
---

## Abstract

The official table of contents and pedagogical arc of the E language tutorial from erights.org, the canonical primary source for how E was taught and what distinguishes it from a conventional object language. It names the tutorial's chapters in order (starting an interpreter with Elmer; a text-finding example introducing the core concepts; packaging a standalone program; Marc Stiegler's fifteen-minute tour; lambda-based object definition; remote objects over the Pluribus cryptographic protocol; a secure two-person chat; and a single-page money example), and closes with E's defining framing: ordinary object programming is about patterns of computation and abstraction, whereas programming in E is about **patterns of cooperation without vulnerability**. Use this when grounding any claim about what the E language is, how it introduced distributed capability programming, or where the "cooperation without vulnerability" phrasing originates.

## E Language Tutorial

In **Starting E and Elmer**, we see the various ways to get started interacting with an E interpreter.

In **Example: Finding Text**, we introduce the major concepts you need to get started programming in E as a conventional language. We use these concepts to write some simple functions for finding text in files on your disk.

In **Standalone E Programs**, we see how to package our `findall` function so that it can be invoked from our operating system's shell (MS-DOS or bash), and how to turn it into a launchable GUI application that prompts for its arguments using Swing dialog boxes.

In **A 15 Minute Introduction to E**, Marc Stiegler takes us on a quick tour of E's highlights, focusing on the features that distinguish E from other languages.

In **Lambda-Based Objects**, we see how to define new objects in E. E's object definitions are generalizations of the function definitions you've already written earlier in the tutorial. E objects have all the features found in objects made from traditional classes and prototypes, yet are actually simpler to define, and can even solve problems beyond the scope of traditional class structures.

In **Introducing Remote Objects**, we see how to give objects on different machines access to each other. An object may send a message to any object it has access to, whether it's local or remote. All the inter-machine communication is protected by the strong cryptography of E's Pluribus protocol.

Armed with secure distributed objects, **Secureit-Echat** is a secure two person chat program, written by Marc Stiegler in 5 pages of E (about 3 of which are user interface) and posted at his site. It's a great small example of how to write distributed secure applications in E.

In the **Simple Money Example**, we see how a single page of E code can implement a payment system with most of the security properties required for real distributed electronic money. Money is the simplest interesting example of a Smart Contract: an arrangement by which various mutually suspicious entities (objects or people, it doesn't matter) may attempt to cooperate with each other while not becoming vulnerable to each other.

In the end, one may say that normal object programming is about patterns of computation and abstraction, whereas programming in E is about **patterns of cooperation without vulnerability**. A world in which cooperation is less risky may be a more cooperative world.

## See also

- [granovetter-operator](../concepts/granovetter-operator.md): the three-object reference-passing step at the core of E's object and capability semantics.
- [object-capability](../concepts/object-capability.md): the security model E embodies, where only connectivity begets connectivity.
- [erights--elang-index--overview](erights--elang-index--overview.md): the parent erights.org E documentation index this tutorial page hangs from.
- [ocap-history--e-capdesk-polaris-market-history](ocap-history--e-capdesk-polaris-market-history.md): the library's market-history survey of E, CapDesk, and Polaris that this primary source grounds.
- [papers--miller-morningstar-frantz-capability-based-financial-instruments-2000](../sources/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000.md): the Financial Cryptography 2000 paper (also titled "An Ode to the Granovetter Diagram") whose money example the tutorial's Simple Money Example tracks.

Source: [elang/intro/index.html](https://erights.org/elang/intro/index.html), fetched 2026-06-27 via the erights.org GitHub Pages mirror ([erights.github.io/erights-org-website/elang/intro/index.html](https://erights.github.io/erights-org-website/elang/intro/index.html)), content SHA-256 `dac38ec2f0b3`.
