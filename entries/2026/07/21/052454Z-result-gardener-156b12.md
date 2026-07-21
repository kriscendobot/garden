---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-21T05:24:59Z
---
# result: scholar-ingest-kni-examples-remainder (batch 1)

Continued the kriskowal/kni examples ingestion after the first five worked examples (read, calc, door-lock, forest, maze). Ingested 12 more `.kni` examples this cycle (each a new source + one overview section; all passed the per-file idempotency check — none previously ingested). Filed under **decision-graph-authoring**; added **automatic-agentic-loop** only to the three that demonstrate elicitation / deterministic rendering of gathered feedback (archery, coin, hilo).

Sources ingested (source_slug → topics, source_commit):
- kni--examples-archery → decision-graph-authoring, automatic-agentic-loop (`435ec3cf`) — guarded economy loop, procedures render gathered totals.
- kni--examples-bottles → decision-graph-authoring (`aaf798b7`) — recursive counter-driven countdown loop.
- kni--examples-troll → decision-graph-authoring (`435ec3cf`) — minimal inline random continuation.
- kni--examples-spacestation → decision-graph-authoring (`435ec3cf`) — indentation as a nested outline tree.
- kni--examples-ship → decision-graph-authoring (`435ec3cf`) — large labeled-room navigation with a config variant.
- kni--examples-space → decision-graph-authoring (`435ec3cf`) — coordinate-hash procedural star map.
- kni--examples-coin → decision-graph-authoring, automatic-agentic-loop (`435ec3cf`) — elicit-record-compare-render toss.
- kni--examples-hilo → decision-graph-authoring, automatic-agentic-loop (`435ec3cf`) — binary-search adaptive question loop.
- kni--examples-loop → decision-graph-authoring (`aaf798b7`) — the anonymous `@...` loop label idiom.
- kni--examples-door → decision-graph-authoring (`435ec3cf`) — two-room shared-flag doorway.
- kni--examples-subroutine → decision-graph-authoring (`3841b36a`) — subroutines that build a menu.
- kni--examples-nominal → decision-graph-authoring (`34ed0749`) — recursive integer-to-words procedure.

Topic/concept pages touched:
- topics/decision-graph-authoring.md — 12 Sections rows added (all examples).
- topics/automatic-agentic-loop.md — 3 Sections rows added (archery, coin, hilo).
- concepts/decision-graph-as-agent-context-scaffold.md — 3 rows (archery, coin, hilo).
- concepts/deterministic-elicitation-loop.md — 3 rows (coin, hilo, archery).
- sources/README.md — 12 index rows added.

Integrity gate (step 8): library-link-check `--changed` OK — every section-table target resolves to a committed file; final per-cluster re-check on the landed tip also OK. regenerate-topics-counts `--check` reported no missing topic pages (stale counts were informational, reconciled at landing).

Final landing steps: regenerate-sections-index.sh (landed sections/README.md) and regenerate-topics-counts.sh (landed topics/README.md); post-land re-check confirms topics counts are current.

Follow-on posted: **scholar-ingest-kni-examples-batch2** naming the remaining 16 `.kni` files (procedural-gen: hilbert, plane, distribution; control-flow/structure: liftoff, tree, tetrominoes, paint, list, option-styles, fish; low-value text/rendering: ascii, canon, german, hyperlinks, poem, stars), grouped by value with per-file guidance.

Self-improvement: land-journal-edit does a full sync+CAS per file, so landing ~20 small files serially blew the 2-minute Bash timeout mid-batch; a scholar cycle that produces many tiny source+section pairs should either land with a generous timeout from the start or batch-land, and should size the cycle knowing per-file landing latency (not just authoring effort) is the real cost. Twelve one-section examples was near the practical ceiling for one cycle's landing budget.
