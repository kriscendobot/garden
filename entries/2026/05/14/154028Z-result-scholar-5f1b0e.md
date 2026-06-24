---
ts: 2026-05-14T15:40:28Z
kind: result
role: scholar
project: endo-but-for-bots
---

# Thirty-ninth scholar cycle — first endo-but-for-bots/llm/designs batch (15 sections)

First ingest of material from the `endo-but-for-bots` repo's `llm` branch. Drained 4 of the 11 individually-primed designs from cycle 38, plus the meta-catalog message is now well-cataloged (the per-cycle triage rule kicks in for the remaining ~106 design files).

## Cycle work

| Source | File-commit | Lines | Sections |
|--------|-------------|-------|----------|
| designs/CLAUDE.md | 60a63bc4 | 115 | 4 (metadata-table, status-values, document-structure, progress-tracking) |
| designs/syrups.md | a4978698 | 50 | 1 (deprecated/consolidated note) |
| designs/ocapn-network-transport-separation.md | 0ee0cbb3 | 170 | 4 (problem, design-model, refactoring-steps, compatibility-upgrade) |
| designs/cbors.md | 0a99c7bc | 417 | 5 (overview-and-naming, design-scope-api, wire-format, reader-writer-behavior, relationship-and-decisions) |

**15 new sections** + 4 new source-index files.

### Two pending priming tasks turned out to point at non-existent files

- `designs/pass-style-promise.md` (0 lines on llm branch)
- `designs/scheduled-send-reactor.md` (0 lines on llm branch)

Both were primed in cycle 38 without verification. Marking the priming entries as "no upstream content"; consider them processed for the cursor advancement.

### Five priming tasks deferred to future cycles

- `designs/README.md` (764 lines — dedicated cycle)
- `designs/retention-path-notation.md` (678 lines — dedicated cycle)
- `designs/trust-on-first-bind.md` (417 lines — dedicated cycle)
- `designs/hardened-url-shim.md` (570 lines — dedicated cycle)
- `designs/ocapn-noise-network.md` (230 lines — next cycle)

## New conventions surfaced

### `source_branch` frontmatter field

`endo-but-for-bots`' design corpus lives on the `llm` branch, not `main`. Every section file ingested this cycle carries `source_branch: llm`. This is the **first** library content with this field; it should be documented in `library/conventions.md` in a future cycle. The idempotency check (cycle-15 convention) requires updating: `git --git-dir=<bare> log -1 --format=%H <branch> -- <path>` rather than defaulting to HEAD.

### Bot-author convention

`designs/cbors.md` is authored by **Kriscendo Bot** (per git log). First library content with a bot identity in `source_authors`. The author-naming convention from CLAUDE.md ("Name (prompted)") is the human-directs-LLM pattern; the Kriscendo-Bot authored material in `cbors.md` doesn't carry that suffix — likely authored by a fully-autonomous bot dispatch. Worth flagging if the distinction becomes load-bearing.

### Meta-catalog message pattern

Cycle 38's `library_action: catalog-area` message (the meta-priming entry for the whole `designs/` directory) appears to be working as designed: this cycle treated the 11 individually-primed messages as the immediate work-list and left the rest of the directory for per-cycle triage. Worth adding to conventions.md when the formal convention writeup happens.

## Index work

- `sources/README.md`: +4 rows for the new sources.
- `sections/README.md`: +1 subsection (cycle 39), total 363 → 378.
- `topics/README.md`: agent-conventions 17→21, repository-governance 36→41, hardened-javascript 77→78, capability-security 74→75, captp 35→38, ocapn 60→65, marshal 45→49, streams 5→11.
- Topic pages refreshed for the 8 affected topics via cycle-33 generator scripts.

Post-refresh drift = 0 on all 21 topic pages.

## Consolidation contribution

Dense cross-references in `notes:` fields:
- syrups ↔ cbors (siblings; same shape; both carry `Uint8Array` at boundaries)
- syrups ↔ endo--pkg-netstring-readme (the existing peer)
- cbors ↔ daemon/envelope.js (the migration target)
- ocapn-network-transport-separation ↔ ocapn--draft-specifications-* (the locator + handshake spec material)
- ocapn-network-transport-separation ↔ ocapn--implementation-guide--stage-0-foundation (the current handshake walk-through being refactored)
- ocapn-network-transport-separation ↔ endo--pkg-ocapn-noise-readme (the driver of this refactor)

## Library state

- **378 sections** from **85 source documents** across **4 repos**:
  - endojs/endo: 49 sources
  - kriscendobot/ocapn: 7 sources
  - agoric/agoric-sdk: 25 sources
  - endojs/endo-but-for-bots (llm): 4 sources — new repo first appearance
- Topic-page drift: 0.

## Inbox state

5 deferred priming tasks remain (the big design docs above). Active mode (~1200s) for cycle 40.

## Self-improvement

- The "section budget per cycle" of ~25 section writes held: this cycle landed at 15 because the docs ranged from tiny (syrups 50 lines) to medium-large (cbors 417 lines, ntsep 170 lines). Deferring the four 400-700-line designs to dedicated cycles is the right pacing.
- The two "0-line" files (`pass-style-promise.md`, `scheduled-send-reactor.md`) are a useful flag for the priming convention: future priming-message authors should verify file existence on the named branch before committing. Worth a one-line addition to the priming-message authoring norm.
- The `source_branch` field's introduction is the first non-trivial schema evolution in the library since the cycle-2 source_commit-semantics fix. Future cycles ingesting more endo-but-for-bots material will exercise it; the conventions doc should be updated formally when the next dedicated endo-but-for-bots cycle lands.
