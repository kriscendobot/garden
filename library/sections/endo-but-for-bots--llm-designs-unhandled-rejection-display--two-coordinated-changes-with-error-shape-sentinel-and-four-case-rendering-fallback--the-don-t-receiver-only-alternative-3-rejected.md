---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §don't-receiver-only — Alternative 3 rejected
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

> *Rejected: the message is gone. No amount of receiver
> cleverness can recover the original `Error.message` that
> `JSON.stringify` discarded on the sender. A receiver-only
> fix produces a diagnostic that says "we lost something" but
> not what was lost.*

The §you-can't-fix-it-on-receiver-because-bytes-are-lost
discipline: this is the *fundamental information-theoretic
constraint* on the design. The wire format is the
information-channel bottleneck; whatever doesn't survive
serialization *cannot* be reconstructed downstream. The
two-coordinated-changes structure is *forced* by this
constraint.
