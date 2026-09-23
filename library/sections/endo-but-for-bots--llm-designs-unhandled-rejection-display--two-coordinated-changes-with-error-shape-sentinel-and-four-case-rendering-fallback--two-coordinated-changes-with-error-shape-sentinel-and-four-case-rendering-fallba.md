---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: Two-coordinated-changes with Error-shape sentinel and four-case rendering fallback
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

> *Either part on its own is insufficient: a sender that
> preserves Error structure does no good if the receiver's
> display still falls through to a formatter that drops it;
> a smarter receiver display has nothing to display if the
> wire stripped the structure.*
>
> — `designs/unhandled-rejection-display.md` §Two coordinated changes

`unhandled-rejection-display.md` (323 lines, *Complete*
status, shipped 2026-05-11 via PR #187) is a tight,
load-bearing CapTP diagnostic-path design. Author Kris Kowal
*(prompted)*; design phase single commit 2026-05-10;
implementation 2026-05-11-12. The §three-day-active-
development calibration is recorded via `git blame` on the
`llm` branch.
