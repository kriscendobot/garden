---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-29T02:05:04Z
---
# result: scholar-library-cycle-20260729-013504 (hourly library cycle)

Empty scholar inbox, so the cycle spent its budget on the one **named, unposted
backlog item** in the corpus: the three TC39 **module-harmony neighbor
proposals** that the layer-4 cycle
(`scholar-research-module-harmony-compartment-layer4`) flagged as "not ingested"
in its completion report but never turned into a follow-on job. Four source
documents, 13 sections, all fetched direct through
`scripts/jobs/fetch-source.sh` (`source_fetched_via=direct`); every idempotency
anchor is a `source_content_sha256`, and no prior source index carried any of
them, so all four are first ingests rather than re-ingests.

## Sources ingested (4, filed under `module-harmony`)

- `tc39-module-harmony--import-attributes` (`proposal-import-attributes/README.md`
  on `master`, sha `f9ee63b0…`, **Stage 4**) — **4 sections**:
  `synopsis-and-motivation` (the server-MIME-confusion argument, and why a URL
  suffix cannot be the marker), `rationale-and-proposed-syntax` (in-band versus
  specifier versus manifest; the `with { }` surface in import, re-export,
  dynamic import, Worker, HTML, and the Wasm `importattributes` custom section),
  `semantics-interoperability-and-the-cache-key` (no per-key semantics;
  reject-rather-than-ignore; the cache key extending to `(referrer, specifier,
  attributes)`; the in-band-versus-out-of-band FAQ), and
  `history-from-module-attributes-to-import-attributes` (three names, two
  keywords, and the 2023-01 demotion to Stage 2 over HTML fetching and CSP).
- `tc39-module-harmony--asset-references` (`proposal-asset-references/README.md`
  on `master`, sha `d40d635e…`, **Stage 1**, champion Sebastian Markbåge) —
  **4 sections**: `asset-declaration-syntax-and-semantics`,
  `motivation-library-mediated-loading-and-per-module-authority`,
  `alternatives-and-possible-additions`, `use-cases-node-react-and-deno`.
- `tc39-module-harmony--shadowrealm-readme`
  (`proposal-shadowrealm/README.md` on `main`, sha `09b2b5df…`, **Stage 2.7**) —
  **1 section** (`overview`), a single-section ingest per `conventions.md`
  § Sectioning shapes: the README is a status card, not a document.
- `tc39-module-harmony--shadowrealm-explainer`
  (`proposal-shadowrealm/explainer.md` on `main`, sha `4842a1ef…`) —
  **4 sections**: `api-motivations-and-non-goals` (the callable boundary and
  wrapped function exotic objects),
  `clarifications-globals-csp-module-graph-and-compartments`,
  `security-integrity-yes-availability-no-confidentiality-partial`, and
  `use-cases-and-the-iframe-and-node-vm-status-quo`.

Total: **13 new section files + 4 new source-index files**.

## Two stage corrections, taken from the sources as fetched

`concepts/module-harmony-intersection-surface.md` recorded import attributes at
Stage 3 and ShadowRealm at Stage 3. The sources say **Stage 4** and **Stage
2.7**. Both corrected on the concept page and in `sources/README.md`.

## Concept, topic, and index updates

- `concepts/module-harmony-intersection-surface.md`: three new rows in the
  **Per-proposal intersection** table (import attributes, asset references,
  ShadowRealm, each with an adopt / defer-to / stay-compatible-with reading);
  the "Module-harmony neighbors (adjacent proposals, **not yet ingested**)"
  section rewritten as "(ingested 2026-07-29)" with the analysis now grounded in
  the sources rather than inferred from sibling explainers; 9 rows added to
  "Sections that touch this concept".
- Topic pages, all rows via `insert-sections-table-row.sh`: `module-harmony`
  (13), `capability-security` (3), `module-loader` (2), `compartments` (1),
  `testing` (1), `node-packaging` (1).
- `sources/README.md`: 4 new rows in the TC39 module-harmony table, and the
  section prose updated (the layer-4 deferral is discharged; the neighbors are
  in; two companion documents named as the remaining gap).
- `keywords.md`: 3 new cross-term lines (import attributes / assertions, asset
  references, ShadowRealm), all routing to
  `module-harmony-intersection-surface`.

## Writeback audit (the scholar's review-writebacks duty)

Two `library-lookup` writeback notices sat unaudited in `role/scholar`:

- **EGARCH / QLIKE → `garch-volatility-models`** (2026-07-20): **sound and
  already landed**; both terms are in the concept's `aliases:` and appear in the
  body and section table. No action.
- **`verifyPaymentProof` → the gateway-package decision-8 section**
  (2026-07-10): **never landed**. The term appeared nowhere in `library/`, and
  the proposed form (term → *section*) does not fit `keywords.md`'s schema
  (term → *concept-id*). Resolved in the shape the schema supports: added the
  alias set to `concepts/monetization-gateway.md`, added a `keywords.md` line
  routing `verifyPaymentProof` there, and wired the
  `…gateway-package…resource-ledger-in-gateway-not-daemon-decision-8` section
  into that concept's section table, so the section is now reachable from the
  concept axis rather than only by full-text search.

## Integrity gate (step 8)

- `library-link-check.sh --source-slug <slug>` for all four new source clusters:
  **OK** on each. Every section-table target and every `sections/README.md`
  (index) row resolves to a committed file; no omitted `kind: index` parent.
- `regenerate-topics-counts.sh --check`: **stale before land** (12 changed
  count lines), which is the informational verdict, not the blocking one. No
  Index row named a missing topic page.
- `library-slug-prefix-check.sh --propose`: **OK**, the `tc39-module-harmony`
  prefix matches its host's siblings.

## Landing and regeneration (step 9)

All 27 content files landed through `land-journal-edit.sh`. Pre-existing files
carried `--base-blob` guards; **two guards fired on genuine peer drift**
(`sources/README.md` and `keywords.md`, both changed under me by the concurrent
`scholar-ingest-atproto-ucan-did-specs` cycle). Both were resolved by re-reading
the tip and re-applying, never with `--force`, so no peer row was dropped.

`regenerate-sections-index.sh` and `regenerate-topics-counts.sh` ran last and
both landed. Post-land verification on a freshly synced tip: counts report
**current** (generator idempotent), the cluster link-check re-runs **OK**, and
`topics/README.md` shows `module-harmony` at **35** sections (22 + 13).

## Follow-on posted

- `scholar-ingest-shadowrealm-errors-and-content-type-companions` — the two
  companion documents named by these sources but not ingested: the ShadowRealm
  `errors.md` explainer (the main explainer only summarizes stack censoring),
  and the import-attributes `content-type-vs-file-extension.md` (the evidence
  behind its whole motivation).

No other deferred backlog from this cycle.

## Self-improvement (reported to the maintainer, not landed here)

`scripts/jobs/scholar-staging-clone.sh` provisions a **single fixed** staging
path and hard-resets it on every call, so two concurrent scholar-role jobs share
one working tree. That happened this cycle: the peer's `sync_clone` silently
discarded 13 of my uncommitted topic-page row inserts mid-cycle, and my
`git add -A library` briefly swept the peer's in-progress work into a local
commit (reset back out; nothing of theirs was lost or landed). The step-8 gate
does **not** catch this class: a topic page missing a row for a section that
exists is not a dangling link, so a less-suspicious cycle would have passed the
gate and landed a cluster whose sections were unreachable from their topic
pages. Suggested fix, since the helper already takes an explicit dest-dir: key
the default staging path by the caller's job base, the way
`ensure-project-worktree.sh` already keys project worktrees. Same isolation
lesson as `endojs/endo-but-for-bots#58`, applied to the staging tree. Sent to
the maintainer inbox (`20260729T020410Z-5bb736`).
