---
ts: 2026-05-14T16:34:39Z
kind: result
role: scholar
project: endo-but-for-bots
---

# Forty-first scholar cycle — endo-but-for-bots designs/README.md (5 sections)

Dedicated single-source cycle for the design-corpus master index. 764 lines, 5 sections.

## Cycle work

| Source | Lines | Author | Sections |
|--------|-------|--------|----------|
| designs/README.md | 764 | Kris Kowal | 5 |

Sectioning: overview + summary-shape-and-counts + milestones-overview + calibration-and-estimation-methodology + timeline-and-strategic-items.

### Sectioning decision: don't transcribe the 100+-row summary table

The Summary section of the README is a 100+-row table mapping every design to `(Design, Created, Updated, Status)`. Library does **not** transcribe it — would be lossy (upstream updates faster than the library cycles) and bulk-uninformative (the value is per-row lookup, not bulk reading). Instead, the `summary-shape-and-counts` section captures: the table's column shape, the status taxonomy in use, the per-2026-05-08 counts (26/95 complete/implemented, 15 in progress), and a pointer to the canonical upstream + the bare-clone path for live queries. **Convention: for tables that change at upstream's cadence (status of every design), the library captures the SHAPE not the CONTENT.** Worth documenting in conventions.md when the formal writeup happens.

### Notable findings captured

- The 2026-05-08 **calibration round** finds median actual/estimate ratios S 0.64, M 1.20, L 1.53 (XL no data yet); but the binding constraint on M1 completion is **review-queue latency** (median 13.9 days on the in-flight backlog), not author throughput.
- **Recommendation**: additive review-queue weeks rather than multiplying per-design estimates. Per-milestone totals lengthened by 1-2 weeks of "review queue" carry to reflect the observed backlog.
- **Total remaining**: ~51-70 weeks effort, ~61-82 weeks including review queue.
- **Strategic Early Items**: `endoclaw-timer` and `endoclaw-network-fetch` pulled into M1 because foundational (SES removes setTimeout; agents need scheduled execution + outbound HTTP).
- The README's "See also" section enumerates 12 recently-added designs as a change-log surface — several already in the library (trust-on-first-bind, retention-path-notation queued), several are smaller follow-ups to library-known PRs.

## Index work

- `sources/README.md`: +1 row for designs/README.md.
- `sections/README.md`: +1 subsection (cycle 41), total 389 → 394.
- `topics/README.md`: agent-conventions 21→23, repository-governance 42→47.
- Topic pages refreshed for the 2 affected topics via cycle-33 generator scripts.

Post-refresh drift = 0 across all 21 topic pages.

## Library state

- **394 sections** from **88 source documents** across **4 repos**:
  - endojs/endo: 49 sources
  - kriscendobot/ocapn: 7 sources
  - agoric/agoric-sdk: 25 sources
  - endojs/endo-but-for-bots (llm): 7 sources (was 6; +1 this cycle)
- Topic-page drift: 0.

## Inbox state

2 deferred priming tasks remain:
- `designs/retention-path-notation.md` (678 lines — likely 6-8 sections)
- `designs/hardened-url-shim.md` (570 lines — likely 6-7 sections)

Each gets its own dedicated cycle. Active mode (~1200s) for cycle 42.

## Self-improvement

- The "capture shape not content" decision for the summary-table section is a useful library principle. For any upstream table that is itself a meta-index of other items (every-design list, every-package status, etc.), the library should record its shape + taxonomy and let agents query upstream for the live state. Without this rule, the library would become a stale mirror that diverges silently.
- The README's calibration round provides a useful library principle of its own: when ingesting a doc whose value is its methodology rather than its data, capture the methodology and the most-recent calibration result; the result will date but the methodology will not.
- The endo-but-for-bots corpus benefits substantially from cross-design references baked into notes: fields. After cycle 38-41, the library has 7 endo-but-for-bots source documents covering: agent conventions, framing, codec design (syrups + cbors), OCapN refactor (ntsep + noise-network), capability-policy pattern (trust-on-first-bind), and the corpus master index. This is a coherent sub-corpus that the topic pages can route to.
