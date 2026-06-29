Completion report follows.

---

# scholar-ingest-mdn-customizable-select-guide — done

Ingested the MDN **Customizable select elements** guide and the three reference pages it leans on into the library, grounding the accessibility/semantics half of the deferred web-designer skill `native-customizable-form-control-styling` (proposed skill 4). All landed to `journal2` through `land-journal-edit.sh` (producer-clone CAS path); every integrity gate is green.

## What I ingested (4 sources, 8 sections — all `source_kind: web`, fetched direct)

- **`web--mdn-customizable-select`** (guide; SHA `013b9f8c`, src date 2026-04-06) — **5 sections**: background-and-feature-inventory, markup-and-opt-in, styling-the-parts, popover-and-anchor-positioning, accessibility-and-browser-support.
- **`web--mdn-appearance-base-select`** (SHA `cc527ff3`, 2026-04-20) — the `appearance` none/base framing and the `base-select` opt-in.
- **`web--mdn-selectedcontent`** (SHA `3ebe0744`, 2026-04-24) — `cloneNode()` clone semantics, inertness, independent styling, fallback button.
- **`web--mdn-picker-select-pseudo-element`** (SHA `806408c9`, 2026-04-17) — what `::picker(select)` targets, the base-select precondition, and the browser default position / position-try-fallback styles.

The job's requested coverage is all captured: the opt-in while preserving native semantics; the stylable parts + pseudo-elements; the accessibility guarantees the native control keeps that a `<div>`/JS widget would re-implement (gathered into a dedicated section); and the mid-2026 support state (Limited availability / Chrome ships / Firefox+Safari implementing).

## Concepts and indexes

- New concept **`customizable-select`** (full 8-section table) and new concept **`progressive-enhancement-supports`** — the latter also resolves a *pre-existing* dangling `[[progressive-enhancement-supports]]` wikilink on `css-intrinsic-sizing` (it cites 6 existing `@supports` sections).
- Cross-linked `css-intrinsic-sizing` ↔ `customizable-select` (See-also both directions).
- `keywords.md` +20 lines; `topics/web-frontend.md` +8 section rows (via `insert-sections-table-row.sh`); `sources/README.md` +4 rows (in the web-frontend "Web essays and surveys" cluster); `concepts/README.md` +2 rows.

## Gates (steps 8–9)

- `library-link-check.sh --source-slug` PASSED for all 4 sources; nav + `--wikilinks` PASSED across every touched file (zero dangling).
- `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` ran and landed; topic counts current/idempotent.

## Follow-ups

- Posted **`author-native-customizable-form-control-styling-skill`** to the board: skill 4 is now authorable (it's a role/`main2` artifact, not a scholar deliverable).
- **Deferred (noted, not silently dropped):** the thin standalone `::picker-icon` and `::checkmark` MDN reference pages were not ingested as separate sources — they're fully covered by the guide's styling/accessibility sections, so a separate source would be a near-empty stale mirror.

Result entry: `entries/2026/06/29/205937Z-result-gardener-b160e5.md`. Job moved doin → tada; temp worktree torn down.

Self-improvement: nothing this time.
