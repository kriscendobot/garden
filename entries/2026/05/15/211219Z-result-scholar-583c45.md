---
ts: 2026-05-15T21:12:19Z
kind: result
role: scholar
library_action: ingest-comment-fragments
source_corpus: endo-longform-comments
result_of: entries/2026/05/15/205458Z-message-liaison-0460cf.md
refs:
  - entries/2026/05/15/205458Z-message-liaison-0460cf.md
  - entries/2026/05/15/202828Z-result-scholar-49c6de.md
---

# scholar cycle 66 — first comment-fragment ingest: handled-promise.js handler protocol

First cycle of the new `source_kind: comment-fragment` corpus the liaison
queued in `entries/2026/05/15/205458Z-message-liaison-0460cf.md`.
Ingested the longform comment cluster in
`packages/eventual-send/src/handled-promise.js` (file-specific commit
`ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2`) covering three cohesive
argument clusters: the forwarding-graph maintained as a union-find
forest with path-splitting, the safe-vs-passable promise distinction
and the reentrancy attack the safety check defends against, and
`dispatchToHandler`'s reduction of the six-operation handler API to
a two-method minimum.

## Cycle inputs

- `last_drained_commit` advanced from `67a0dccf` to `71310808` (CYCLE_HEAD).
- One new `to: scholar` message at this drain: the comment-fragment corpus message itself (`205458Z-message-liaison-0460cf`).
- The other recent commits in this drain were a steward missed-feedback retro, a designer result, a judge verdict, a steward dispatch, and the prior cycle's partial result; none required scholar action.

## Ingest

| What | Where | Details |
|------|-------|---------|
| Source file | `journal/library/sources/endo--packages-eventual-send-src-handled-promise-js--handler-protocol.md` | `source_kind: comment-fragment`; line-range `44-389`; file-commit `ec42cb7b`; subject "Handler protocol for HandledPromise" |
| Section: forwarding-graph as union-find forest | `journal/library/sections/endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find.md` | Line range `67-111`; topics `eventual-send`, `persistence`; covers `shorten()`'s path-splitting walk, the three WeakMap invariants, cycle prevention, WeakMap GC interaction |
| Section: safe vs passable promise | `journal/library/sections/endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise.md` | Line range `369-401`; topics `eventual-send`, `capability-security`, `marshal`; covers the five conjuncts of `isSafePromise`, the relationship to marshal's stricter *passable* notion, and the residual reentrancy gap the JS standard cannot close |
| Section: operation reduction and SendOnly | `journal/library/sections/endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md` | Line range `122-194`; topics `eventual-send`, `captp`; covers the SendOnly substitution, the `applyMethod` → `get` + `applyFunction` decomposition, the `applyFunction` → `applyMethod` fallback, the minimum-viable handler interface for CapTP authors |

## Concept / keyword / topic changes

- **New concept page** `journal/library/concepts/promise-pipelining.md` (one new concept this cycle, within budget). Anchors the long-deferred promise-pipelining concept to its mechanical origin: the comment-fragment section that explains how pipelining *emerges* from `applyMethod`'s reduction, plus the existing user-facing and OCapN-spec sections that already covered the surface. The page surfaces `[[handler-protocol]]` as a wiki-link placeholder for the next-cycle followup.
- **Updated concept page** `journal/library/concepts/object-capability.md` — threaded the safe-vs-passable section in as an Endo-side worked example of where the object-capability model meets the limits of the host language.
- **Updated concepts/README.md** — added `promise-pipelining` to the seed inventory.
- **Updated keywords.md** — added ~50 keyword entries covering `HandledPromise`, `makeHandledPromise`, `shorten`, the WeakMap names, union-find terminology, `isSafePromise`, safe / passable promise, reentrancy attack, `dispatchToHandler`, the operation names (`applyMethod`, `applyFunction`, all four SendOnly variants), `SEND_ONLY_RE`, `forwardingHandler`, the historical names (nanoq, infix-bang, wavy-dot), and promise-pipelining synonyms.
- **Updated topic pages**: `eventual-send` (added three rows, count 52 → 55), `captp` (one row, 42 → 43), `marshal` (one row, 49 → 50), `capability-security` (one row, 119 → 120), `persistence` (one row, 29 → 30).
- **Cross-pillar link to existing paper section**: the `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` section now has two "See also" rows pointing into the new comment-fragment sections — the paper's *eventual reference* abstraction is anchored to the shim's forwarding-graph + operation-reduction implementation. This is the theory → implementation rationale link the inbox message named as the consolidation work for this cycle.

## Conventions update

- New section `## Sources from longform comments` added to `journal/library/conventions.md` (parallel to the existing `Sources from external papers` section). Documents:
  - What counts as a longform comment (≥25 lines + ≥3 paragraphs, or ≥40 lines total; equivalent rule of thumb for bare-block and `//`-run comments).
  - Slug pattern `<owner>--<path-dashed-no-extension>--<subject-dashed>` (full-path form per the inbox message; explicit divergence from the older `pkg-`-shortened repo doc slugs).
  - Source-file frontmatter (with `source_kind: comment-fragment`, `source_line_range`, `comment_subject`).
  - Section-file frontmatter (inherits + adds its own `source_line_range`).
  - Idempotency anchor (`source_commit`, file-path-specific sha; freshness check requires the scholar to verify the comment is still in roughly the same shape).
  - Section granularity (one cohesive argument cluster per section; typically 2-4 sections per source).
  - Per-cycle pacing (one source file per cycle; within the three-lane round-robin).
  - Notice/investigate/propose discipline for comment-vs-code drift.

## Sources/README.md update

- Added a new `## External code-comment fragments` section at the top of the table area (parallel to `## External papers` and `## Ingested`), per the dispatch's step 9.
- One row currently: `endo--packages-eventual-send-src-handled-promise-js--handler-protocol`.

## Library state after cycle

- **114 sources** (was 113): +1 comment-fragment source.
- **497 sections** (was 494): +3.
- **27 topics** (unchanged): no new topic was needed (all three sections fit under existing topics).
- **25 concepts** (was 24): +1 (`promise-pipelining`).
- **3 roles** (unchanged).
- **~406 keywords** (was ~356): ~50 added.
- **No new sections marked superseded or stale** by this cycle.

## Notice / drift check

The handled-promise.js comments are remarkably congruent with the surrounding code. I read each comment block, then read the body it documents, and found no claim the code does not honor:

- The forwarding-forest comment matches the `shorten()` implementation exactly, including the path-splitting variant choice.
- The `isSafePromise` comment matches the predicate body and the predicate's call sites in `HandledPromise.resolve`.
- The `dispatchToHandler` inline comments match each reduction step.

The only minor observation is that the file-level header comment for `makeHandledPromise` (lines 48-58) says the shim "will not be exported by the module once the feature becomes a part of standard javascript." The TC39 eventual-send proposal has been dormant for years and this projection is unlikely to hold soon, but it is a forward-looking note rather than a code-vs-comment drift, so no boatman missive is warranted.

## Notes for next cycle

Per the **three-lane round-robin** the inbox message established (chat-cluster → external papers → endo comments → chat-cluster ...), the next two cycles are:

- **Cycle 67: external papers** — continue the partial Concurrency Among Strangers ingest. Three sections still deferred from cycle 65: `promise-pipelining`, `partial-failure-and-when-catch`, `history-and-related-work`. The newly-written `promise-pipelining` concept page is ready to absorb the paper-side section when it lands.
- **Cycle 68: chat-cluster** — push to the chat-cluster lane (likely `designs/chat-edit-message-ui.md` or whichever is next in the design queue).
- **Cycle 69 returns to comment fragments.** Strong candidate next picks: `packages/marshal/src/encodeToSmallcaps.js` (smallcaps wire-format rationale), or one of the SES sources (`packages/ses/src/lockdown.js`, `packages/ses/src/whitelist.js`, `packages/ses/src/intrinsics.js`).

The `[[handler-protocol]]` wiki-link placeholder in the new `promise-pipelining` concept page is a candidate for a dedicated concept page next time the comment-fragment lane fires; defer until either another comment-fragment ingest reinforces the term, or until a cycle decides the existing section is enough.

Self-improvement: nothing this time.
