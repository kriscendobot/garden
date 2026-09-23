---
section: monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
source: metamask-ocap-kernel--overview
topics: [daemon, captp, persistence]
status: current
title: The §AGENTS.md style + ocap-discipline observations
parent: metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
---

`AGENTS.md` (72 lines) is the project's developer-discipline
manifesto. Several rows are *directly comparable* with the
garden's CLAUDE.md disciplines:

- **§Lockdown is the first thing that runs**: same as @endo
  + Agoric SES discipline.
- **§Use `harden()` for immutability where feasible**: same
  pattern; explicit instruction to `harden(this)` at end of
  constructors, `harden(ClassName)` after class definition,
  `harden({...})` for inline returns.
- **§`E()` from `@endo/eventual-send`**: same surface as
  cycle 146's `E.js`.
- **§If an object is to be made remotable, turn it into an
  exo using `makeDefaultExo`** — *Do not use `Far` from
  `@endo/far`*. The §forbid-direct-Far observation: this is
  the project's wrapper *replacing* the Endo primitive. Worth
  comparing with cycle 134/136's *Alleged: prefix* +
  cycle 108's *defineExoClass*.
- **§Use `@metamask/superstruct` for runtime type checking**:
  parallel to @endo's `M.interface` shape guards.
- **§Prefer `type`; do not use `interface`** — TypeScript-
  side discipline.
- **§Never use `enum`s; always use string literal unions** —
  same as the garden's TypeScript discipline.
- **§Tests co-located with covered source** — same as @endo
  convention.
