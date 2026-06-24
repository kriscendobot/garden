---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §don't-use-replacer — Alternative 2 rejected
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

> *Rejected as the sole change because the `replacer` runs at
> every key in the tree, not just the top-level `reason`. A
> nested Error in a passable graph would also be flattened to
> fields, which would conflict with the marshal-side encoding
> for `CTP_RETURN.exception`.*

The §narrow-guard-not-tree-walk discipline. JSON's `replacer`
hook fires at *every* node; the design wants to touch *one
specific field on one specific message type*. The replacer
approach would *over-apply* the transformation, breaking the
marshal-encoded errors in CTP_RETURN.

The §two-different-error-encodings-must-coexist invariant:
`CTP_DISCONNECT.reason` uses the new `@@error` plain-shape
encoding; `CTP_RETURN.exception` uses marshal's existing
errorIdNum-based encoding. Both must work. The replacer would
collapse them.
