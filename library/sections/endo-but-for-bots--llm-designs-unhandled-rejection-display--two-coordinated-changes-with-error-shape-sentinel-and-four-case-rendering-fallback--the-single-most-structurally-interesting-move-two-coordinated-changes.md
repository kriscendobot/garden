---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §single most structurally interesting move — §two-coordinated-changes
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

The fix has **two parts that must coordinate**. The
§either-part-alone-is-insufficient framing is named
explicitly:

> *Either part on its own is insufficient: a sender that
> preserves Error structure does no good if the receiver's
> display still falls through to a formatter that drops it;
> a smarter receiver display has nothing to display if the
> wire stripped the structure.*

The §coordinated-changes-as-design-shape discipline: a single
diagnostic fix is *one piece of work* but spans *two code
sites* (sender + receiver). The design treats them as a
*coordinated pair* rather than two separate designs. This is
the §wire-and-display-are-conjugate-sides framing later
echoed in the *helper-lives-next-to-encoder* discipline.
