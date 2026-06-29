---
kind: result
role: gardener
host: endolinbot2
at: 2026-06-29T20:53:48Z
---
# Scholar ingest: CSS anchor-positioning reference

Cycle for `scholar-ingest-css-anchor-positioning-reference`. Ingested a dedicated
CSS anchor-positioning reference into `journal/library/` so the deferred skill
`css-anchor-positioning-and-flip-fallbacks` can be authored on solid ground
(previously the technique appeared only incidentally in `web--goldilocks-select-height`).

## Sources ingested (both new; idempotency anchor = source_content_sha256)

- **`web--mdn-css-anchor-positioning`** (`source_kind: web-reference`, MDN CSS
  anchor positioning guide + its Try_options_hiding subpage; SHA-256 `313a128a`,
  fetched direct) — 7 sections: `--overview` (anchor-name/position-anchor),
  `--anchor-function`, `--anchor-size-function`, `--position-area-grid`,
  `--position-try-fallbacks-and-flip`, `--position-try-order-and-visibility`,
  `--browser-support`.
- **`web--csswg-css-anchor-position-1`** (`source_kind: standards-doc`, CSS Anchor
  Positioning Level 1 draft; SHA-256 `f7a87622`, fetched direct) — 2 sections:
  `--try-tactic-flip-semantics` (the normative geometric definition of
  flip-block/inline/start/x/y, the axis-paired property swaps they imply — the
  basis for "margin-block-end becomes margin-block-start on flip" — and the
  deliberate spec gap on an explicit affected-property enumeration) and
  `--position-try-order-and-descriptors` (the stable-sort most-* rule + the
  restricted `@position-try` descriptor set).

9 section files + 2 source-index files landed via `land-journal-edit.sh`.

## Coverage of the job's checklist

`anchor()`, `anchor-size()`, `position-area`, `position-try-fallbacks`
(flip-block/flip-inline/combined), `position-try-order`, and the `flip-*`
property-flipping behavior are all covered, with the normative "what flips / what
does not" split into the CSSWG section. Browser-support state captured in the
dedicated `--browser-support` section (mid-2026: Chrome ships the full feature;
flip-* fallbacks universal; Safari lacks anchored container queries; calc-size()
Chrome-only; Firefox lacks `max-block-size: stretch`).

## Topic / index pages touched

- `topics/web-frontend.md` — 9 section rows added via `insert-sections-table-row.sh`
  (no new topic; the existing web-frontend abstract already names anchor positioning).
- `sources/README.md` — 2 new rows in the "Web essays and surveys" table.
- `sections/README.md` and `topics/README.md` regenerated as the final landing
  step (`regenerate-sections-index.sh`, `regenerate-topics-counts.sh`).

## Integrity gate (step 8)

`library-link-check.sh --source-slug` PASSED for both clusters
(`web--mdn-css-anchor-positioning`, `web--csswg-css-anchor-position-1`);
`regenerate-topics-counts.sh --check` reports counts current. No dangling targets.

## Follow-on posted

- `author-css-anchor-positioning-and-flip-fallbacks` (board `todo/`) — authoring
  proposed **skill 3** is now unblocked, grounded in the two new sources plus the
  goldilocks `--problem-and-default-sizing` / `--viewport-margin-and-flip-fallbacks`
  sections. The skill is NOT authored in this job (scholar does not edit skills).

No deferred backlog: the reference is complete within budget (11 content files).

Self-improvement: nothing structural. The `web-reference` / `standards-doc`
`source_kind` discriminants slotted cleanly into the existing web-source shape
the goldilocks essay established; the WebFetch-extract → fetch-source.sh-for-the-hash
split (prose from the tool, idempotency SHA from the deterministic fetcher) is the
reusable habit for ingesting live web pages.
