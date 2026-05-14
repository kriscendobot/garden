---
title: What is this?
source: packages/trampoline/README.md
source_repo: endojs/endo
source_commit: 4406f5dd
source_date: 2024-04-30
source_authors: [Christopher Hiller]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
---

> Abstract: Background: the trampoline pattern, why it exists, when to use it vs alternatives (await, generators, simple recursion).

## What is this?

The pattern exposed by this library—known as [trampolining][]—helps manage control flow in a way that avoids deep recursion and potential stack overflows.

**@endo/trampoline** provides the trampolining pattern, but in such a way that a consumer can execute _either_ synchronous _or_ asynchronous operations _paired with operations common to both_.

In other words, **@endo/trampoline** can help _reduce code duplication_ when operations must be executed _in both sync and async_ contexts.


Source: [packages/trampoline/README.md](https://github.com/endojs/endo/blob/4406f5dd/packages/trampoline/README.md) at commit `4406f5dd`.
