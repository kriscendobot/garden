---
title: What is HardenedJS? What is SES? What is Endo?
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, capability-security]
status: current
---

> Abstract: Definitions and framing. HardenedJS is the abstract programming model (frozen intrinsics, ocap discipline). SES is the implementation that realizes HardenedJS in JavaScript. Endo is the broader family of packages building on SES for distributed capability-bearing computation. Consolidates three short H2 sections that together establish the terminology.

# Endo and HardenedJS (SES) Programming Guide

This is a guide to programming with *HardenedJS* and *Endo*. It:
- Shows what you can and cannot do with a HardenedJS program.
- Defines what SES, the HardenedJS shim, is and does.
- Provides background on why JavaScript functionality was added, removed, or changed.
- Describes *realms* and *compartments*.
- Introduces Endo.

This is intended for initial reading when starting to use or learn about Agoric. For
those knowledgeable about or experienced with HardenedJS, see the
[Endo and HardenedJS Programming Reference](./reference.md)
for to use HardenedJS without much explanation.

## What is HardenedJS?

HardenedJS:
- Is a JavaScript runtime library for safely running third-party code.
- Addresses JavaScript’s lack of internal security.
  - This is particularly significant because JavaScript applications
    use and rely on third-party code (modules, packages, libraries,
    user-provided code for extensions and plug-ins, etc.).
- Enforces best practices by removing hazardous features such as global
  mutable state and lack of encapsulation in sloppy mode.
- Is a safe deterministic subset of "strict mode" JavaScript.
- Does not include any IO objects that provide
  [*ambient authority*](https://en.wikipedia.org/wiki/Ambient_authority).
- Removes non-determinism by modifying a few built-in objects.
- Adds functionality to freeze and make immutable both built-in JavaScript
  objects and program created objects and make them immutable.
- Is (tentatively named SES) a proposed extension to the JavaScript standard.

HardenedJS consists of three parts:
- Lockdown is a function that irreversibly repairs and hardens an existing
  mutable JavaScript environment.
- Harden is a function that makes interfaces tamper-proof, so objects can be
  shared between programs.
- Compartment is a class that constructs isolated environments, with separate
  globals and modules, but shared hardened primordials and limited access to
  other powerful objects in global scope.

Lockdown consists of separable Repair Intrinsics and Harden Intrinsics phases,
so that shims (other programs that alter JavaScript) may run between them.
These shims are obliged to maintain the object capability safety invariants
provided by Lockdown and must be carefully reviewed.
We call these "vetted shims".

## What is SES?

SES is an old umbrella term for the HardenedJS effort, and while we
refer to these specific features as HardenedJS, the SES name lingers
in a few places.

SES (as `ses` in npm, the Node.js package registry) is the name of a JavaScript
library that implements the HardenedJS, that works in most modern
JavaScript engines.

The SES Strategy group is a
[community](https://groups.google.com/g/ses-strategy) of developers advocating
and discussing security features for inclusion in JavaScript.

As 2021 closes at time of writing, the language proposals still bear the SES
name, though that is likely to change.

## What is Endo?

What Node.js does for JavaScript, Endo does for HardenedJS.
Endo loads packages and modules in an ECMAScript module loader that isolates
every package, granting limited access to the host's resources.
Agoric smart contracts are an example of Endo guest programs.


Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
