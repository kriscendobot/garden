---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: How this design fits the @endo/captp + @endo/marshal cluster
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

- **Cycle 87** [[endo--packages-pass-style-src-error-js--passable-error-validation-surface]]
  — the pass-style error.js defines the four-property error
  allowlist (`message`/`stack`/`cause`/`errors`); this design
  takes three of them and leaves `cause` for future work.
- **Cycle 100** [[endo--packages-ses-src-error-unhandled-rejection-js--SES-rejection-tracking-via-GC-driven-finalization]]
  — the SES rejection-tracking machinery that *fires* this
  diagnostic. Both designs share the §diagnostic-cannot-
  depend-on-substrate discipline.
- **Cycle 84** [[endo--packages-marshal-src-rankorder-js--in-memory-rank-order-regime]]
  — the `passableAsJustin` rendering used here is from the
  same marshal layer.
- **Cycle 148** [[endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw]]
  — the `@@`-prefix-convention this design uses for its
  sentinel is the same convention this earlier file
  establishes for the passable-symbol wire shape.
