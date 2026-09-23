---
title: What is HardenedJS?
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, capability-security]
status: current
parent: endo--docs-guide--what-is-hardenedjs-ses-endo
---

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

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
