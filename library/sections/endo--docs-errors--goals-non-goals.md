---
title: Goals, non-goals, and partial goals
source: docs/errors.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: liaison
topics: [errors, hardened-javascript]
status: current
---

> Abstract: The three building blocks of JS developer debugging (thrown errors with stack traces, `assert` convenience, built-in `console`) must be preserved under the constraints of a secure, distributed, deterministic blockchain system. This is distinct from symbolic logging frameworks intended for post-processing; the `console` produces information for direct human consumption, which severely constrains what symbolic metadata can be added without visual noise.

## Goals, non-goals, and partial goals

Aside from IDE-based debuggers, the normal JavaScript developer debugging experience rests on the interplay of three widespread building blocks:

* Thrown errors which carry stack traces and explanatory messages.
* An `assert` convenience library for turning violated conditions into diagnostic errors.
* A built-in `console` for producing diagnostic logging information for the developer to look at, or even, in the browser, interact with.

We are building a distributed secure JavaScript system running on both blockchain and non-chain platforms. Blockchains require determinism, so all validators reproduce the same computation. Despite these constraints (secure, distributed, deterministic) we wish to provide the JavaScript developer with a debugging experience at least on par with their current `console` based expectations, and as familiar as possible, so they can hit the ground running.

The logging systems described at [survey of logging frameworks. Issue #1318](https://github.com/Agoric/agoric-sdk/issues/1318) mostly have very different goals: to produce symbolic records to be post-processed into useful diagnostic information. We still need such a logging system in addition to the system described here. The `console` directly produces information for the developer to look at and possibly interact with. Producing this experience severely constrains the additional symbolic information we can include to aid post-processing, if this additional information would add distracting visual noise.

Source: [docs/errors.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/errors.md) at commit `fe81477b`.
