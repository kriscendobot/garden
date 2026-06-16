---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §migration-without-caller-change
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

> *The migration does not require any caller change. Existing
> call sites that pass `Error` reasons get a strictly better
> diagnostic. Existing call sites that pass non-Passable
> reasons get a slightly more informative diagnostic and
> remain candidates for a follow-up cleanup pass.*

The §no-flag-day-required property. The four-case fallback
*handles every existing call site shape* without changes; the
upgrade is purely the daemon's encoder + decoder. The §strictly-
additive-on-receiver-side discipline (cycle 87's pass-style/
error.js had a similar §host-configuration-defense framing).
