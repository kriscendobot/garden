---
title: Distributed Asynchronous Iteration (formal semantics)
source: packages/notifier/README.md
source_repo: agoric/agoric-sdk
source_commit: eaef5bfd888e01d641e3e450df4809a165c68633
source_date: 2024-10-31
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
notes: The Finish/Fail distinction is the formal termination model — Finish carries a completion value (any JS value), Fail carries a reason (any JS value, but should be an Error). The "non-final" / "final" terminology is local-only and unrelated to the Java keyword.
---

> Abstract: Formal semantics. An async iteration is an abstract sequence of values consisting of zero or more **non-final values** in a fully-ordered sequence, revealed asynchronously over time. Full ordering means all consumers see the whole sequence (or a subset) in the same order. Termination is either **Finish** (successful completion with a completion value, any JS value) or **Fail** (failure with a reason, should be an Error but can be any JS value). "Non-final" and "final" refer only to position, not the Java meaning.

# Distributed Asynchronous Iteration

An async iteration is an abstract sequence of values. It consists of zero or more *non-final values* in a fully ordered sequence, revealed asynchronously over time. In other words, the values have a full ordering, and all consumers see the whole sequence, or a subset of it, in the same order.

The sequence may continue indefinitely or may terminate in one of two ways:

  * *Finish*: The async iteration successfully completes and reports a final *completion value*, which can be any JavaScript value.
  * *Fail*: The async iteration fails and gives a reported final *reason*. This should be an error object, but can be any JavaScript value.

Finish and Fail are *final values*. To avoid possible confusion, for iteration values in this doc, "final" and "non-final" merely refer to position in an iteration, and not "final" in the sense of the Java keyword or similar.

Source: [packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
