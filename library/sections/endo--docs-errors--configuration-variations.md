---
title: Configuration variations
source: docs/errors.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: liaison
topics: [errors, hardened-javascript, compartments]
status: current
---

> Abstract: The error/assert/console system runs across multiple configurations: pre-repair, post-repair start compartment (with all `errorTaming` and `consoleTaming` combinations), and created compartments. The recommended endowment pattern (a tree of created compartments sharing one safe `Error`, one `assert`, and per-compartment filtering consoles) is the primary target for strong simple security and determinism.

## Configuration variations

This directory is a system of three related abstractions:

* `Error`: Errors carry hidden diagnostic information.
* `assert`: Assertions cause and annotate errors.
* `console`: Consoles show an enhanced view of logged errors.

This system must behave well in a variety of configurations:

* After `lockdown` is imported but before repairs.
   * `assert` added to global scope of start compartment.
* After repair or `lockdown()` in the start compartment
   * All combinations of relevant `lockdown` taming options (`errorTaming` and `consoleTaming`).
* In *created compartments*, i.e., non-start compartments created after `lockdown()`. In our recommended practice, typically:
   * All created compartments implicitly share the same safe `Error` constructor.
   * All compartments explicitly share the same `assert`.
   * Each compartment explicitly has its own `filteringConsole` in a tree, enabling filtering by compartment (topic-like) and severity level (`debug`, `log`, `info`, `warn`, and `error`).

Of these configurations, we are primarily concerned with the post-lockdown, default-safe-taming options, created compartment, recommended endowment pattern. This one must have strong simple security and determinism properties. Variations must differ in understandable ways.

Source: [docs/errors.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/errors.md) at commit `fe81477b`.
