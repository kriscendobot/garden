Completed the illuminated illustration set in draft PR https://github.com/kriscendobot/garden-book/pull/9 at head `1200afb01bee81a85ca208412e8e5863d3700811`.

- Added exactly 25 reproducible, hand-auditable thematic SVGs covering all 10 chapter openers and 15 section entries.
- Updated `art/MANIFEST.md` with one mapping per target anchor, including role/theme, ratio/placement, and accessibility intent.
- Reused the established warm-paper palette: paper/sand, brown ink, moss/sage/fresh greens, terracotta, pink, lavender, and manuscript gold. Essential distinctions also use shape and line treatment.
- Added a source generator and tests enforcing byte-for-byte reproducibility, 25-entry coverage, unique prefixed IDs, resolved references, accessibility metadata, and absence of scripts, handlers, external resources, data URLs, embedded fonts, or unsafe elements.
- Verified all 25 SVGs with XML parsing and rendered contact-sheet inspection at reduced sizes.
- `npm test`: 24/24 tests passed.
- `npm run build`: passed; 10 files and 857,064 characters produced.
- Pre-push gates: 10/10 stages passed; local verification passed.
- No build, rendering, HTML, CSS, or publication integration was added.
- PR remains draft against pinned base `main-ab5990e`; no repository CI checks are configured.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-illumination-produce-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1046s

<!-- garden-usage-end -->
