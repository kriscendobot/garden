---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §don't-replace-JSON-with-Justin — Alternative 4 rejected
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

> *Rejected: `passableAsJustin` produces a string in the
> Justin language. That string would have to be parsed back
> on the receiver, which would itself need a Justin parser.
> The wire format would become incompatible with peers that
> have not adopted the change.*

The §peer-compatibility-during-rollout discipline. The
chosen design is *strictly additive*: the unmodified field
set survives unchanged; only the `reason` field shape changes
when it carries an Error. Peers that haven't yet adopted the
change see the encoded shape as a plain object with field
names — *still parseable*, still renders (badly, but
non-fatally).

Replacing JSON wholesale would break the §progressive-
rollout-without-flag-day property.
