Ingested five high-value `kriskowal/kni` worked examples from the `examples/*.kni` corpus: `read`, `calc`, `door-lock`, `forest`, and `maze`. Each has a per-file commit anchor, source index, and a focused section under `decision-graph-authoring`; `read` is also indexed under `automatic-agentic-loop` and both related concept pages as literal deterministic bot intake evidence.

The library now distinguishes the examples' patterns: free-text/choice capture plus rendered profile (`read`), mutation-and-loop controller (`calc`), guarded reusable state machine (`door-lock`), deterministic state-indexed rendering (`forest`), and state-derived legal-branch rendering (`maze`). Updated the kni source inventory, topic pages, concept-section tables, and regenerated `sections/README.md` and topic counts.

Verification: `library-link-check.sh` passed for all five source clusters, resolving source and generated-index links; `regenerate-topics-counts.sh --check` reported current counts; both final regenerators reported the committed projections current.

Posted follow-up `scholar-ingest-kni-examples-remainder` for the remaining 28 `.kni` examples, explicitly naming the files and prioritizing archery, bottles, troll, spacestation, ship/space, and control-flow examples.

Self-improvement: no structural lesson; per-file provenance plus small one-section example pages fit the existing ingestion conventions.
