---
title: Error
source: draft-specifications/Model.md
source_repo: kriscendobot/ocapn
source_commit: 971eadd133f36b0d57bd32d29d83f221e81b9c1b
source_date: 2025-06-23
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, errors, marshal]
status: current
notes: Cross-reference: library/sections/endo--docs-errors--hiding-revealing-distributed-diagnostic.md describes the Endo side of distributed error correlation, which is the plans-level extension of OCapN's wire-level error type.
---

> Abstract: OCapN Error: an error value sent by copy. The OCapN spec describes error-name and message-string fields; the Endo equivalent (pass-style error pass-style + the comm-system's identifier annotation per docs/errors.md § Hiding and Revealing Distributed Diagnostic Information) covers more ground including stack-trace identifier correlation.

# Error

A value capturing the reason for rejecting a delivery.

> - **Guile**: to be proposed
> - **JavaScript**: a JavaScript Error object
> - **Python**: to be proposed
>
> We have not yet converged on consensus for any particular details about the
> modeling of errors. The purpose of errors is typically to indicate that some
> requested operation failed. The purpose of the contents of errors is to
> preserve and convey diagnostic information, mostly to help debug problems,
> such as the root cause of a surprising failure. This is a best-efforts
> obligation, for which we have not yet decided either what contents are
> required, nor what is allowed, nor what must be preserved as errors are
> passed from one site to another. Until these details are decided, the only
> hard requirement is that an error round trip to an error. We avoid any
> interpretation for now as to whether it is the "same" error.
>
> https://github.com/ocapn/ocapn/issues/142


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
