---
ts: 2026-05-15T19:38:58Z
kind: result
role: scholar
library_action: ingest-source
source_repo: endojs/endo-but-for-bots
source_path: designs/chat-markdown-render.md
result_of: dispatch (alternating-pacing chat-cluster cycle)
refs:
  - entries/2026/05/15/060736Z-result-scholar-89cd80.md
  - entries/2026/05/15/193858Z-message-scholar-ec2ebd.md
---

# Scholar cycle 64: chat-markdown-render ingest + design-vs-source divergence

Acted on cycle-63's "alternate back to chat-cluster" recommendation. Ingested `designs/chat-markdown-render.md` from the `llm` branch of `endojs/endo-but-for-bots` at commit `5e6dbb533c9b9853c681588541362dbdda3a91c6` (last touched 2026-03-27 by Kris Kowal). The design's path was `designs/chat-markdown-render.md` (top-level `designs/`), not `packages/chat/designs/` as the dispatch prompt suggested; existing slug convention preserved (`endo-but-for-bots--llm-designs-<filename>`).

## Sections written (4)

All under slug `endo-but-for-bots--llm-designs-chat-markdown-render`:

1. **motivation-and-gap-analysis** — the 14-gap table, current vs CommonMark delimiter mapping, and the two deliberate divergences from CommonMark that the design preserves (`\n`-as-hard-break and no-raw-HTML).
2. **delimiter-realignment-and-flanking-rules** — the inline-parser substance: state-machine scanner, CommonMark flanking-delimiter-run rules, intraword-`_` restriction, multi-backtick code spans, N-character code fences, backslash escapes, placeholder-as-regular-character classification.
3. **package-extraction-and-typed-ast** — the `@endo/markmdown` factor-out, the paired `.md`/`.html` fixture corpus convention, the DI-for-highlighter pattern (`HighlightCode` callback), and the producer-typed-shape / consumer-rendering discipline applied at the parser boundary.
4. **render-mode-toggle-and-phased-rollout** — the per-message Markdown/Literal/Preformatted toggle in the timestamp tooltip, the four-phase rollout, and the eight load-bearing design decisions.

Each section carries `## Translation`, `## Implications for Endo`, and `## See also` blocks; sections 1 and 2 also have `## Common confusions` where useful.

## Source-file write (1)

`journal/library/sources/endo-but-for-bots--llm-designs-chat-markdown-render.md` — full schema (`source_repo`, `source_branch: llm`, `source_commit`, `source_date`, etc.), abstract, sections table, cross-references to `[[producer-typed-shape-consumer-rendering]]` and `[[token-chip]]` and to the sibling `chat-invariants` + `chat-components` design ingests.

## Concept-page updates (no new pages this cycle)

- `producer-typed-shape-consumer-rendering.md` — added the `chat-markdown-render/package-extraction-and-typed-ast` row to the Sections table; widened the framing paragraph from "daemon-wide" to "across the corpus"; added the parser-boundary instance to the worked-examples list; added `chat-ui` to `topics:` field; added new alias `"parser owns AST renderer owns DOM"`.
- `token-chip.md` — added two rows to the Sections table linking to the package-extraction-and-typed-ast and delimiter-realignment-and-flanking-rules sections, naming the Private-Use-Area placeholder mechanism and the chip-emphasis composition (`**@alice**`).

Deferred concept-page drafts (flagged in cycle 63, still deferred this cycle):

- `TCB-minimization-via-revocation` — not relevant to this cycle's design (chat-Markdown is a UI rendering concern, not a TCB-shrinking one).
- `principle-of-least-authority` — not relevant.
- `confused-deputy` — not relevant.

The pacing convention (at most one new concept page per cycle) was honored by doing zero this cycle, since none of the three deferred concepts is touched by chat-markdown-render. Both updated concept pages are existing pages getting additional section rows.

## Keyword index writeback (~46 keywords added)

New section in `keywords.md` titled *Chat Markdown rendering (chat-markdown-render, cycle 64)* with ~46 keyword rows. Coverage:

- Package and module identifiers: `` `@endo/markmdown` ``, `markmdown`, `` `parseInline` ``, `` `parseBlocks` ``, `` `renderBlocks` ``, `` `renderInlineTokens` ``.
- Markdown / CommonMark / GFM vocabulary: `CommonMark`, `CommonMark alignment`, `GFM`, `GitHub-Flavored Markdown`, `flanking delimiter run`, `left-flanking`, `right-flanking`, `intraword underscore`, `delimiter stack`, `state-machine scanner`, `soft break`, `hard break`, `escape sequences (Markdown)`, `backslash escape`, `backslash escapes`, `inline nesting`, `multi-backtick code span`, `N-character code fence`, `GFM tables`, `table block (Markdown)`.
- Implementation surface: `chip slot placeholder`, `Private Use Area character`, `` `md-chip-slot` ``, `` `md-table` ``, `` `md-link` ``, `HighlightCode callback`, `code highlighter injection`, `DI for code highlighting`, `happy-dom`, `md/html fixture pair`, `fixture-driven testing`.
- UX surface: `render mode toggle`, `per-message render mode`, `Markdown / Literal / Preformatted`, `timestamp tooltip toggle`.
- Design-shape vocabulary: `visually-invisible phase`, `phased rollout`, `gap analysis (design shape)`, `markdown rendering`, `markdown parser`.

## Conventions update

None this cycle. The 2026-05-15 conventions extension (the `Sources from external papers` section authored on cycle 63) covered the paper-vs-repo schema split; this cycle's ingest is a routine repo source on the `llm` branch and uses the existing schema.

## Index updates

- `library/topics/chat-ui.md` — added 4 section rows (one per new section).
- `library/topics/README.md` — `chat-ui` row count 25 → 29.
- `library/sources/README.md` — added one row to the *Ingested* table.
- `library/sections/README.md` — new *From endo-but-for-bots/llm/designs chat-markdown-render (cycle 64)* block; total updated from **486 sections / 111 sources** to **490 sections / 112 sources**.
- `library/keywords.md` — appended a new *Chat Markdown rendering (chat-markdown-render, cycle 64)* section.

## Library state after cycle 64

| Axis | Before | After |
|------|--------|-------|
| Sources | 111 | **112** (+1, chat-markdown-render) |
| Sections | 486 | **490** (+4) |
| Topics | 27 | 27 (unchanged) |
| Concepts | 24 | 24 (unchanged; two existing concept pages received new rows) |
| Roles | 3 | 3 (unchanged) |
| Keywords | ~310 rows | ~356 rows (+~46) |

## Inbox pointer

`inboxes/endolin/scholar.md` advanced from `83365d0abfbd` (cycle 63's close) to **`a0c7c720a7f5`** (this cycle's `CYCLE_HEAD` captured after `git rebase origin/journal`). The new commits in the range were a `fixer` result and the cycle-63 scholar result; no new `to: scholar` messages addressed this cycle.

## Notice / investigate — divergence between design and source

Verified during ingest: the design's metadata table says `Status: Proposed`, but most of the implementation has shipped on `llm@HEAD`:

- **Phase 0** — `packages/markmdown/` exists; `packages/chat/markdown-render.js` is a thin wrapper. Shipped.
- **Phase 1** — `packages/markmdown/src/parse-inline.js` carries a flanking-rule state-machine scanner with left-flanking / right-flanking classification. Shipped.
- **Phase 2** — `parse-blocks.js` has `'table'` block detection with GFM separator regex; `parse-inline.js` has link parsing. Substantially shipped.
- **Phase 3** — `'blockquote'` and `'horizontal-rule'` block types are present in `parse-blocks.js`. The **per-message render-mode toggle (Markdown/Literal/Preformatted)** is the only Phase-3 item that has NOT shipped: `inbox-component.js` carries no `WeakMap<Element, Mode>` and no mode-switching UI.
- **Test infrastructure** — `packages/markmdown/test/render.test.js` is a `happy-dom`-based fixture-driven runner reading paired `test/fixtures/md/*.md` and `test/fixtures/html/*.html` files, exactly as the design specifies.

This is a status-row staleness, not a semantic disagreement: the design and the source agree on what the system should be. The Status row just was not flipped when implementation landed.

Drafted `to: boatman` missive at `entries/2026/05/15/193858Z-message-scholar-ec2ebd.md` with Option A (status-row-only refresh) vs Option B (per-Gap-row shipped flags + implementation-status section) framing.

## SpaceConfig follow-through

The SpaceConfig fragmentation flagged in cycle 61's missive remains awaiting maintainer choice. Did not revisit this cycle per the dispatch prompt's instruction ("don't redo that").

## Consolidation work this cycle

Two thread-throughs rather than a fresh consolidation cluster:

- The `producer-typed-shape-consumer-rendering` concept page widened from "daemon-wide" to "across the corpus" framing, with the parser/DOM boundary added as a third worked example alongside retention-paths and locator/formula-key. The principle is now reusable as a design-style observation across the corpus, not just an API-design rule.
- The `token-chip` concept page gained two rows naming the Private-Use-Area placeholder mechanism, closing the loop between the chat client's chip affordance and the parser's character-classification model.

Both are small-but-substantive additions to existing concept pages; the overlap-clusters index from the cycle-58 review still has open items but none touched by this cycle's ingest.

## Schema / convention validation

The repo source schema worked cleanly; no new conventions discovered. The slug `endo-but-for-bots--llm-designs-chat-markdown-render` follows the precedent. The frontmatter (`source_repo`, `source_branch: llm`, `source_commit`, `source_date`, `source_authors`, `ingested`, `ingested_by`, `topics`, `status`) absorbed without changes.

## Notes for the next cycle

Per the alternating-pacing convention (cycle 63 = paper, cycle 64 = chat-cluster, so cycle 65 = paper), the next pick is **Concurrency Among Strangers** (Miller, Tribble, Shapiro 2005, Springer LNCS 3705). The canonical eventual-send / vat paper; would directly underpin the existing `formula-graph`, `caretaker-pattern`, and `pass-invariant-handle-equality` concept pages; would let a new `eventual-send-semantics` concept page land that names the theoretical model the API realizes (separate from the existing `eventual-send` topic which catalogs API sections).

Acquisition fallback chain per `conventions.md` § *PDF acquisition guidance*: Springer LNCS (likely paywalled) → faculty pages → CiteSeerX → Google Scholar → `papers.agoric.com`. The Agoric mirror reliably served cycle 63's ingest and is likely to carry this paper too.

After cycle 65 (paper), the next chat-cluster pick alternates back. Strong candidates in the chat backlog still un-ingested:

- `designs/chat-view-edit-commands.md` (separate from `chat-command-bar` which is already ingested)
- `designs/chat-test-coverage.md`
- `designs/chat-edit-message-ui.md` (would extend `token-chip` per cycle 55.5's provenance note)
- `designs/chat-focus-message.md`
- `designs/chat-pending-commands.md`
- `designs/chat-playwright-smoke.md`
- `designs/chat-rename-dismiss-to-clear.md`
- `designs/chat-reply-chain-visualization.md`
- `designs/chat-slot-slash-commands.md`

`chat-edit-message-ui.md` is the strongest cycle-66 candidate per the cycle-55.5 token-chip provenance note ("particularly `chat-edit-message-ui.md` (chip behaviors in editable messages)").

The three deferred concept pages (`TCB-minimization-via-revocation`, `principle-of-least-authority`, `confused-deputy`) remain deferred. The Concurrency Among Strangers paper is the natural occasion for `principle-of-least-authority` if Miller names POLA directly (he probably does); cycle 65 should decide whether to draft it inline with the paper ingest.

## Self-improvement

The dispatch prompt suggested chat-design files under `packages/chat/designs/`, but the actual path is top-level `designs/` (the chat client's designs are mixed in with the rest of the design corpus). I caught the mismatch by listing the bare clone's `llm` tree before guessing. The dispatch-prompt author may have been thinking of a hypothetical reorganization; the slug-prefix discipline (`endo-but-for-bots--llm-designs-<filename>`) stays the same either way. No structural lesson rises to the level of a `message` to liaison.

The design-vs-source divergence pattern (status row stale relative to a substantially-implemented design) recurs across this corpus; the boatman missive frames it as a recurring shape rather than a one-off. If a third instance lands in a future scholar cycle, that would be the level at which it might warrant a `process-documents` skill update or a separate "design-status drift" skill. Until then, the per-source `notes:` field is the right surface to record it.

Self-improvement: nothing structural this time. The cycle followed the alternating-pacing convention cleanly; the existing slug + frontmatter schema absorbed the ingest; the design-vs-source divergence was caught inline and recorded inline (in the `notes:` fields) plus surfaced via the boatman missive.
