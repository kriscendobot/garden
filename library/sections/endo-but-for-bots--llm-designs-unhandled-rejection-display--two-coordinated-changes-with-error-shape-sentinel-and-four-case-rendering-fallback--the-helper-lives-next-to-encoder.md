---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §helper-lives-next-to-encoder
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

> *The `renderRejection` helper lives next to `messageToBytes`
> because the two are conjugate sides of the same wire-shape
> decision.*

The §wire-and-display-as-conjugate-sides discipline: the
encoder writes `'@@error': true`; the decoder reads it. Both
must agree on the sentinel and the field set. Putting them in
adjacent code makes the *coupling* visible. A future change
to either *forces* a paired change.

§Future-portability gesture: *A future refactor could move
it to `@endo/captp` if other consumers grow a need for it*.
The §Open question #2 names this explicitly: `@endo/captp`'s
own `defaultOnReject` has the same `{}` rendering bug for any
captp consumer that doesn't provide a custom `onReject`. The
implementation PR is encouraged to *lift the helper into
@endo/captp* so the fix is at the source.
