---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-11-12T21:13:12Z
job: scholar-ingest-yavashark-ironhorse-20261030
claim: 6a806dcd58d20253
---
# result: scholar-ingest-yavashark-ironhorse-20261030

Ingested **Sharktheone/yavashark** (main @ `2e159150`, 2026-11-11, MIT) as a repo overview (`sources/yavashark--overview.md`, 4 sections), read with an Iron Horse lens. Iron Horse was compared at endojs/endo-but-for-bots `origin/llm` `48d6f3e0`.

- Sections: `yavashark--overview--{architecture-and-crate-map, test262-runner, graftable-for-ironhorse, architectural-differences-vs-ironhorse}`.
- Topics touched: `engine-implementation` (+4 rows), `testing` (+2 rows). `sources/README.md` has a row under sibling implementations. No new topics, concepts, or keywords.
- Idempotency: there was no prior `yavashark--*` source, so this is a fresh ingest.
- Foreign-content gate: **not run**. The content was read via `git clone` into a scratch dir, not a web fetch. `TYPESAFE_API_KEY` is absent on this host, which ran under the maintainer typesafe-bypass directive of 2026-11-12. This is recorded as `content_caveat` on the source page. No instruction-like text was observed.
- Integrity gate: `library-link-check.sh --changed` returned OK. The sections index was regenerated and landed. Topics counts were already current at the tip.
- Follow-on jobs: none posted. The deferred remainder (experiments/, VM async internals, macro object model, the yavashark-data results repo) is named on the source page as not decision-relevant at this pass.

Headline verdict: yavashark offers **test-infrastructure ideas** that are cheap for Iron Horse to adopt: measured per-test cost tiers, hash-nested sampled sweeps, and CPU isolation for risky tests. It is also a spec-breadth reference: Intl.Locale over the same ICU4X 2.2, and `temporal_rs` as a possible dev-only Temporal oracle. It is **not** a source of engine architecture, because its SWC front end, reference-counted heap, host coupling, and lack of a meter conflict with Iron Horse's goals. Two speculative design inputs: lazy intrinsic materialization (for `ironhorse-intrinsic-fault-in`) and ASCII-compact strings (for the heap envelope).
