---
title: The Unum Pattern — overview and origin
source_kind: web-essay
source_url: https://habitat-chronicles.com/2019/08/the-unum-pattern/
source_content_sha256: 7d099818689a2f196889f1602187a7c6a79110e80f1baa7c4a2bab88952e81dd
source_author: Chip Morningstar
source_date: 2019-08-28
ingested: 2026-07-11
ingested_by: scholar
topics: [distributed-objects]
status: current
---

## Abstract

Chip Morningstar names the **unum** — from the Latin for "a single thing" — as a
software design pattern for **distributed objects that are themselves distributed
entities**, not merely ordinary objects located at different network addresses.
The idea's roots go back to the original Lucasfilm *Habitat* (1985–86), though its
authors did not recognize it as a nameable pattern at the time; Morningstar and
his collaborators at later companies (Electric Communities, and the Elko server
framework) reused it "to good effect in many different systems." This overview
section frames why the pattern deserves its own word: the phrase "distributed
object" already means something else to most practitioners (one object sitting on
some far machine), so a new term was coined to keep the two ideas from colliding
in conversation. It is the entry point for the sibling sections that develop the
unum/object distinction, the *presence* abstraction, addressing and vats, the four
messaging patterns, behavioral (anti-REST) protocols, and the open research
questions around alternate divisions of labor.

## Content

This design pattern for distributed objects — which we call the "unum" — is one
that the author and co-conspirators at various companies have used to good effect
in many different systems, but which is still obscure even among the people who do
this kind of work. The pattern had been described in conversation with many people
over the years; a few of them published descriptions of what they understood, but
those writeups did not, to Morningstar's sensibilities, quite capture the idea as
he conceives of it. This essay is his own written-down understanding.

The roots of the fundamental idea go back to the original *Habitat* system,
"although we didn't realize it at the time." The pattern was later carried forward
deliberately — most usefully for anyone who wants to play with the ideas, into
Habitat's Nth-generation descendant, the **Elko** server framework, and explored
further at **Electric Communities**.

Source: [The Unum Pattern](https://habitat-chronicles.com/2019/08/the-unum-pattern/) by Chip Morningstar, 2019-08-28 (content sha256 `7d099818`).
