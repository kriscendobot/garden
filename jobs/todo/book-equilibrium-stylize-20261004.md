---
role: builder
provider: openai
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
arc: garden-book
---

# Stylize the review-economics charts to belong to the illuminated book

Repository: `kriscendobot/garden-book`. This is STYLIZE, stage 3 of the production supervised by `book-equilibrium-data-supervisor-20261004`, explicitly pinned to Codex/OpenAI.

The shared draft PR is https://github.com/kriscendobot/garden-book/pull/12, branch `book-equilibrium-data`, exact starting head `f4e89b070794639419bc096b8351f9ff33b965e7`. Do not open a second PR. Use:

```sh
/home/kris/garden/scripts/jobs/ensure-project-worktree.sh book-equilibrium-stylize-20261004 kriscendobot/garden-book book-equilibrium-data
```

Fetch and check out the current remote branch; require that it contains the starting head, then push your commit back without overwriting concurrent work. Keep the PR draft. Do not merge, publish, or integrate the charts into the chapter yet.

## Visual brief

Restyle the nine existing SVGs `art/equilibrium-e1-*.svg` through `art/equilibrium-e9-*.svg` so they unmistakably belong to the same illuminated-manuscript garden as the 25 chapter illustrations. Read and match:

- `art/MANIFEST.md`, especially the exact 13-color palette;
- `art/chapter-illustrations-brief.md`;
- `art/generate-illuminations.mjs` and several representative `art/illumination-*.svg` assets;
- `art/equilibrium-data-spec.md` § Visual language;
- the VISUALIZE evidence and generator at `art/equilibrium-charts-evidence.md` and `art/generate-equilibrium-charts.mjs`.

This stage changes **how the charts look, never what they say**. Preserve every datum, label, unit, sample size, kind distinction (observed/derived/scenario), axis mapping including log scales, annotation, caveat, direct-label relationship, chart ID, title/description meaning, series geometry and scenario minimum. Preserve E8's off-scale treatment and E7's visibly attached caveat. Do not add, remove, round differently, reorder, or reinterpret data. Do not change the chart specification, aggregates, scenarios, or manuscript argument.

Work in the deterministic generator and regenerate all nine SVGs. Focus only on visual treatment:

- illuminated borders and restrained corner/vine ornament outside plotting areas;
- the established warm-paper/sand/soil palette and manuscript-gold emphasis, without any new hue;
- line texture, hatching, tick/callout treatment, and typography rhythm that echo the chapter plates;
- subtle botanical motifs that frame or guide, never become pictorial data marks or clutter the plot;
- coherent treatment across E1–E9, including dark mode.

The result should feel like charts drawn into the same manuscript, not a separate analytics report stapled into it. Keep ornament restrained enough that dense phone-width charts remain readable.

## Non-negotiable technical constraints

- Maintain deterministic byte-for-byte generation and update the existing tests only where their expected visual markup legitimately changes.
- Inline-safe SVG under the existing CSP: globally unique IDs; no external references, remote fetches, embedded fonts, scripts, handlers, `foreignObject`, inline `style` attributes/elements, or new palette colors.
- At 353 px rendered width, all labels remain at least 12 px, nothing clips, and no text/ornament overlaps. Essential meaning must not depend on color.
- Keep the chart checker and exact-number/spec consistency tests passing. Do not weaken a test to admit a data/content change.

Run the full test suite. Render and inspect all nine restyled charts in a real browser at 353 px in both light and dark schemes. Record concrete evidence in the existing evidence document, including any ornament-specific overflow/contrast observations. Push the same draft PR and send the exact new head SHA plus a concise account of visual changes and verification to:

```sh
/home/kris/garden/scripts/jobs/inbox-send.sh book-equilibrium-data-supervisor-20261004
```

If you genuinely finish but cannot preserve the data/geometry/accessibility gates while styling, emit `<<<GARDEN-ORCHESTRATION-FAILED>>>` immediately before your completion signal.
