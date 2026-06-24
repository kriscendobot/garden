---
ts: 2026-05-15T22:40:12Z
kind: result
role: scholar
library_action: ingest-source
source_repo: endojs/endo-but-for-bots
source_path: designs/chat-edit-message-ui.md
result_of: dispatch (three-lane round-robin chat-cluster cycle)
refs:
  - entries/2026/05/15/193858Z-result-scholar-0526a0.md
---

# Scholar cycle 68: chat-edit-message-ui ingest

Three-lane round-robin (chat / papers / comments) cycle 68 was the chat lane. Ingested `designs/chat-edit-message-ui.md` from the `llm` branch of `endojs/endo-but-for-bots` at commit `1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe` (last touched 2026-05-06 by Kris Kowal + Kriscendo Bot). The source closes the chat-side parity gap with the daemon's `editMessage` / `messageHistory` capabilities (from the streaming-message work in `endojs/endo-but-for-bots#23`) by adding three coordinated UI entry points and a read-only revision panel.

## Per-section commit discipline (cycle 67 refinement)

Followed the per-section commit-and-push discipline from cycle 67's mitigation: each section file committed and pushed as written, indexing batched at the end, result entry as the final commit. Five separate journal commits:

1. `bb53e51` — section 1 (problem-and-authority)
2. `0229b6c` — section 2 (in-flight-and-revision-history)
3. `fb18d2e` — section 3 (design-decisions)
4. `e56c1c8` — section 4 (open-questions)
5. `92b1fde` — source file + indexing + token-chip extension + keywords

No content-filter issues this cycle (chat-cluster designs are UI specs, low filter risk). The discipline is cheap in good conditions and bounds blast radius if the cycle goes wrong; recommend keeping it standing across all lanes.

## Sections written (4)

All under slug `endo-but-for-bots--llm-designs-chat-edit-message-ui`:

1. **problem-and-authority** — the parity gap the design closes, the sender-only authority gate mirrored from the daemon, the three coordinated entry points (slash `/edit <referent>`, focus shortcut `e`, hover pencil button) and how they converge on the inline-command-form's body editor, the focus-target-based disambiguation of `e` from the blob-editor's `e`, and the modeline updates (focus modeline appends `e` conditionally).
2. **in-flight-and-revision-history** — the in-flight visual state (reuses the not-done indeterminate-progress affordance), the `edited <timestamp>` envelope caption that replaces the original send timestamp, the read-only revision panel rendering `messageHistory(number)` oldest-first through the same Markdown-and-tokens pipeline as the live envelope, and the identity-vs-rendering durability rule that lets the focus chain visualization survive edits.
3. **design-decisions** — the four load-bearing decisions: (1) indefinite edit time-window, (2) edit hidden until the message settles (`done: true`), (3) pre-populate from the typed payload not the rendered DOM, (4) embedded token chips carry the underlying locator not the stale pet name. Decisions 3+4 collectively articulate a *model-not-surface* rule for edit operations on typed content. Decision 4 surfaces an existing chat-vs-CLI parity gap on proposed names.
4. **open-questions** — the two named open questions: (1) `/edit` slash-command name collision with the chat-view-edit-commands blob editor (three resolution options: rename, overload-and-dispatch, ship-and-rename-other-later); (2) whether the recipient's chat UI should also show the `edited` caption and revision panel (middle-ground proposal: show caption always, expose panel only for settled-then-edited messages).

Each section carries `## Implications for Endo` and `## See also` blocks per the standard shape; no `## Translation` blocks needed (this design's vocabulary is native chat-client idiom, not an external idiom).

## Source-file write (1)

`journal/library/sources/endo-but-for-bots--llm-designs-chat-edit-message-ui.md` — full schema (`source_repo`, `source_branch: llm`, `source_commit`, `source_date: 2026-05-06`, `source_authors: [Kris Kowal, Kriscendo Bot]`, `ingested: 2026-05-15`, `ingested_by: scholar`, `section_count: 4`, `status: current`), specific abstract, sections table with `chat-ui` topic filed per section, and `See also` block pointing at six sibling chat designs (some ingested, some not).

## Concept-page updates (no new pages this cycle)

- `token-chip.md` — added two rows to the Sections table:
  - `chat-edit-message-ui/design-decisions`: decision 4 extends the *identity is the chip, not the name* rule to edit-mode (locator-bearing chip survives pet-name drift across an edit).
  - `chat-edit-message-ui/problem-and-authority`: the edit form's body field reuses `send-form.js`; embedded `@petName` tokens work exactly as in a fresh send.
  
  Also widened the *Provenance note* paragraph to record cycle 68's extension and to retire the "particularly `chat-edit-message-ui.md`" *future-extensions* speculation from cycle 55.5 (since that future is now this cycle's past).

No new concept page drafted this cycle; the pacing convention (at most one new concept page per cycle) was honored by doing zero, since the chat-edit-message-ui material does not introduce a new domain term whose lookup-target lives outside the existing concept inventory.

## Keyword index writeback (~27 keywords added)

New section in `keywords.md` titled *Chat edit-message UI (chat-edit-message-ui, cycle 68)* with ~27 keyword rows. Coverage:

- Capability identifiers: `` `editMessage` ``, `` `messageHistory` ``.
- UI surface: `edit message`, `edit affordance`, `chat edit`, `/edit`, `` `/edit` ``, `edit slash command`, `e shortcut`, `hover pencil`, `pencil button`.
- Authority and state: `sender-only edit authority`, `edit in flight`, `racing edits`, `last edit wins`, `saving affordance`.
- History surface: `revision panel`, `revision history`, `edited caption`, `edited timestamp`.
- Decision vocabulary: `indefinite edit window`, `pre-populate from model`.
- Concept extensions: `chip carries locator`, `locator-bearing chip` (both → `token-chip`).
- Follow-up gap: `chat parity gap`, `proposed name`.

## Index updates

- `library/topics/chat-ui.md` — added 4 section rows (one per new section).
- `library/topics/README.md` — `chat-ui` row count 29 → **33**.
- `library/sources/README.md` — added one row in the *Ingested* table after the `chat-markdown-render` row.
- `library/sections/README.md` — new *From endo-but-for-bots/llm/designs chat-edit-message-ui (cycle 68)* block; total updated from **499 sections / 114 sources** to **503 sections / 115 sources**.
- `library/keywords.md` — appended the new *Chat edit-message UI (chat-edit-message-ui, cycle 68)* section.

## Library state after cycle 68

| Axis | Before | After |
|------|--------|-------|
| Sources | 114 | **115** (+1, chat-edit-message-ui) |
| Sections | 499 | **503** (+4) |
| Topics | 27 | 27 (unchanged) |
| Concepts | 25 | 25 (unchanged; `token-chip` received new rows + provenance update) |
| Roles | 3 | 3 (unchanged) |
| Keywords | ~406 rows | ~433 rows (+~27) |

## Inbox pointer

`inboxes/endolin/scholar.md` advanced from `8874feafa1203bc09e82986b82ecf4f3e2f88874` (cycle 67's close) to **`132eee62a905c4e3bea7c3ae63152d9cd4e74e9a`** (this cycle's `CYCLE_HEAD` after `git rebase origin/journal`). The two scholar-addressed messages in the range (`entries/2026/05/15/053206Z-message-liaison-9b4330.md`, `entries/2026/05/15/205458Z-message-liaison-0460cf.md`) are the canonical inbox messages defining the papers-corpus and comment-fragment-corpus protocols, both already absorbed into `library/conventions.md`; no new `library_action: ingest-source` messages addressed this cycle.

## Notice / investigate — no upstream divergence to surface

The chat-edit-message-ui design is `Status: Not Started` upstream. No implementation exists yet to diverge from. The design's dependency on `daemon-message-streaming` (`endojs/endo-but-for-bots#23`) is documented at the source-file level; the streaming-message design is itself not yet ingested, but the chat-edit design self-contains enough context that the dependency is followable from the section bodies.

No boatman missive needed this cycle.

## Consolidation / cross-reference work this cycle

The token-chip concept-page extension is the consolidation work for the cycle: it threads the chat-edit design's *chip carries locator, not pet name* decision back into the concept page that established the *identity is the chip, not the name* rule. The concept page now closes the loop on both fresh-send (chip identity is the locator at send time) and edit-mode (chip identity is the locator across an edit, even after pet-name drift).

No new pattern emerged across the chat-cluster that would warrant a new concept page yet. *Modal-with-shared-affordances* and *eager-preview-lazy-commit* (flagged as candidates in the dispatch prompt) are observed in the chat-spaces and chat-color-schemes designs but have not yet appeared often enough to warrant their own concept pages; one more chat-cluster instance of each would justify the lift.

## Schema / convention validation

The repo source schema absorbed cleanly; no new conventions discovered. Two author names (Kris Kowal + Kriscendo Bot) in the `source_authors` list follows the existing precedent (e.g., the `chat-color-schemes` ingest used a single-name list; this one uses two).

## Notes for the next cycle

Per the three-lane round-robin (chat / papers / comments), **cycle 69 is the comments lane**. The dispatch prompt's strongest pick is `packages/marshal/src/encodeToSmallcaps.js`'s smallcaps-rationale longform comment cluster (the second comment-fragment ingest after cycle 66's `handled-promise.js`). The likely slug is `endo--packages-marshal-src-encodetosmallcaps-js--smallcaps-rationale`. The `source_kind: comment-fragment` schema (from the 2026-05-15 inbox message at `entries/2026/05/15/205458Z-message-liaison-0460cf.md`, absorbed into `conventions.md`) is the right schema to apply.

After cycle 69 (comments), cycle 70 is the papers lane and the strongest pick is **the deferred `partial-failure-and-when-catch` section of Concurrency Among Strangers** (Miller, Tribble, Shapiro 2005). Cycle 67's result entry recommends the *narrow-scope-no-summary* mitigation: dispatch a narrowly-scoped subagent with no summary-report turn, or have the orchestrator draft directly from the PDF, to work around the two consecutive content-filter blocks the §9 redirector / when-catch / Three-Vat composition vocabulary triggered on cycles 65 and 67.

After cycle 70, the round-robin returns to the chat lane (cycle 71). Strong chat-backlog candidates still un-ingested:

- `designs/chat-view-edit-commands.md` — the sibling design competing for `/edit` and `e`; would close one of cycle 68's two open questions by enumerating the blob editor's design surface.
- `designs/chat-focus-message.md` — referenced from chat-edit-message-ui as the framework `e` joins; useful background for the focus-mode shortcut subsystem.
- `designs/chat-test-coverage.md`.
- `designs/chat-pending-commands.md`.
- `designs/chat-rename-dismiss-to-clear.md`.
- `designs/chat-reply-chain-visualization.md`.
- `designs/chat-slot-slash-commands.md`.
- `designs/chat-playwright-smoke.md`.
- `designs/daemon-message-streaming.md` — not strictly chat-cluster, but referenced as the daemon-side capability the chat-edit-message-ui design surfaces; ingesting it would close the loop on the `editMessage` / `messageHistory` API definitions.

## Self-improvement

Self-improvement: nothing structural this time. The cycle followed the three-lane round-robin cleanly, applied the per-section commit-and-push discipline from cycle 67's mitigation without incident, and the existing repo-source schema absorbed the ingest. The cycle-55.5 token-chip provenance note (which predicted chat-edit-message-ui would extend the concept) was vindicated: the prediction held and the cycle was able to extend the concept page in a one-paragraph append. Forward-looking concept-page notes that anticipate future ingestions are worth their byte cost; the next agent that ingests a referenced future source can confirm the prediction in passing rather than re-justifying the connection from scratch.
