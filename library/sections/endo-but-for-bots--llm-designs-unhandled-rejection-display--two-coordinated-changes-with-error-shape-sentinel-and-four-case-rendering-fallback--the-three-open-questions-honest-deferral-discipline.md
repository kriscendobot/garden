---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §three-open-questions — §honest-deferral discipline
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

§Open questions deliberately deferred:

1. **`'@@error'` vs marshal `errorIdNum`** — cycle 87's
   error.js uses errorIdNum for marshal-encoded errors;
   `@@error` is the disconnect-path equivalent. The §two-
   encodings-coexist invariant is the answer.
2. **Should `renderRejection` move to `@endo/captp`?** — the
   bug is at the source there; current daemon-only landing is
   pragmatic but not optimal. The §honest-acknowledgment-of-
   incomplete-fix discipline.
3. **Plain shape vs CapData blob?** — *Plain shape is simpler
   and survives `JSON.parse` directly*. The §recommendation
   *plain shape for now; revisit if richer Error preservation
   is needed* is the standard §do-the-simple-thing-first
   discipline.
