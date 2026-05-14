---
title: Secure Coding Guide (overview)
source: packages/ses/docs/secure-coding-guide.md
source_repo: endojs/endo
source_commit: 832ebbfad1259c13c98f3a12e4500e288feb5ac9
source_date: 2023-08-26
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, hardened-javascript]
status: current
---

> Abstract: Mark Miller's practitioner-facing guide to writing secure JavaScript under SES. Walks through a worked example showing the same code under non-SES and under SES, with patterns and anti-patterns. Substantial (532 lines); the foundational read for anyone writing code intended to defend against malicious cooperating modules.

# Secure Coding Guidelines under SES

SES is a JavaScript-based programming environment that
makes it easier to write *defensively consistent* programs. We define
**defensive consistency** as a program (or function, or service.. something
written in code) that provides correct service to its correctly-behaving
customers, despite also being subjected to incorrectly-behaving customers.
The defensively consistent program is allowed to rely upon some "trusted
computing base" ("TCB", like libraries and other services), which means it is
allowed to provide incorrect service to correctly-behaving customers if the
TCB misbehaves, but it must be clear about which code is in the TCB and which
code is not being relied upon. And of course, the program is allowed to give
bad service to incorrectly-behaving customers.

Two pieces of mutually-suspicious code can safely interact if both are
written in a defensively-consistent style. All services exposed over the
internet must obviously be defensively consistent, because the internet is
full of malicious demons who will go to any lengths to corrupt or compromise
any computer attached to it (in the early days, this was less true, which is
why old software is so much more vulnerable to remote compromise).

But most programs are written with the assumption that they can rely upon
local services, or libraries, or other code within the same computer. By
applying the same defensive attitude towards co-resident code, we can improve
safety against mistakes, misunderstandings, or partial compromise. We apply
the **Principle of Least Authority** (POLA) to these separate components,
giving each one the barest minimum of power necessary to do its job. This
limits the damage if/when a component becomes compromised or confused.


Source: [packages/ses/docs/secure-coding-guide.md](https://github.com/endojs/endo/blob/832ebbfad1259c13c98f3a12e4500e288feb5ac9/packages/ses/docs/secure-coding-guide.md) at commit `832ebbfa`.
