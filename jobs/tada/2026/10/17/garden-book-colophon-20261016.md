## Report: garden-book colophon (garden-book-colophon-20261016)

I opened draft PR **https://github.com/kriscendobot/garden-book/pull/16** with one commit, head `fe9ece3`, based on the frozen base `main-51f6c5d`. `main-51f6c5d` is a snapshot of `main` at `51f6c5d`, which includes the merged PR #15; `ensure-pr.sh` needs that frozen base. I did not merge, un-draft or publish anything. The usual gauntlet follows.

**What changed:** there is a new back-matter colophon after chapter 10. Its source is the new file `build/colophon.html`, under three headings: Editions, Text and editing, and Build and publication. The sidebar and the contents link to it under "Back matter". It uses the chapter styling and has its own table styles. I checked it in dark and light at phone and desktop widths, and nothing scrolls sideways.

### Passages moved
| Source | Short quote | Destination |
|---|---|---|
| `build/intro.html`, title-page edition margin note | "Draft edition of 2026-10-16, repainted illuminations. This is a draft…" | Editions (verbatim) |
| same note | "Earlier editions: 2026-10-13 linked and reader copy-edited; … 2026-09-30 first edition" | Editions (same words and links, now a list) |
| `build/intro.html`, intro paragraph | "Each chapter was written by a separate garden job … grounded on." | Text and editing (verbatim) |
| Every chapter's provenance margin note (built by `render-book.mjs` from the chapter frontmatter) | "Written by gardener (job book-ch1, …); grounded on main2 7f0cb21902c. Source: ch1-….md" | Text and editing, as a table with one row per chapter |
| ch1, "Orchestration jobs" bullet | "This book was produced that way: each chapter is a child of the orchestration `garden-book-orch`." | Text and editing (merged) |
| ch2, § 2.2 | "This book is itself an orchestration, `garden-book-orch`, which first ran eight chapter children in parallel." | Text and editing (merged) |
| ch3, "Orchestration" | "This book is itself one such orchestration … halt on failure." | Text and editing (merged) |
| Page footer (`render-book.mjs`) | "Assembled from the chapters in kriscendobot/garden-book." | Build and publication; the footer is removed |

The three orchestration asides are merged into one sentence that links to § 7.4.

I did not add any text about how the illuminations were generated. The book itself contains none: those notes are in `art/*.md`, which the book does not show, so there is no Illuminations heading.

### Borderline passages left in place
- **ch7 § 7.4.5, "A lifecycle, walked through":** it uses the book's own orchestration as the worked example. I recommend keeping it, since moving it would empty the subsection.
- **ch8 § 8.8 data-sources paragraph** ("…live in this book's repository under `tools/equilibrium/` … no journal prose … is copied into the book"): this says how to reproduce the analysis rather than how the book was made. I recommend keeping it; it could move if the maintainer prefers.
- **Title-page note "Links to source files go to `main2`…":** a reading aid. Its mention of grounding commits now links to the colophon, so nothing points at missing text. I recommend keeping it.

### Title page (question for the maintainer)
The title page keeps the kicker, title, subtitle, frieze and the five-part overview. The only edition mark left is a one-line margin note: "**Draft edition of 2026-10-16.** Earlier editions, and how the book was made, are in the colophon." Should that line stay, or should the title page carry no edition mark at all?

### Build and checks
- **File count:** the build still writes **27 files** (`index.html`, `styles.css` and 25 plates). The colophon is a section inside `index.html`, so no manifest, publish count or limit changed. If the maintainer wants it as a separate HTML file instead, that would be a follow-up.
- **Tests updated:**
  - `test/units.test.mjs` checks that provenance appears in the colophon and not in the chapters, that the navigation and contents have their Back matter entries, and that there is no footer.
  - `test/build.test.mjs` checks for the colophon section and that the output is exactly `index.html` and `styles.css` when no plates are declared.
  - `test/illuminations-placement.test.mjs` now expects the chapter opener figure directly after the chapter heading.
  - The existing every-internal-link test now covers the colophon's anchors as well.
- **`build/README.md`** now documents `colophon.html` and `{{PROVENANCE}}`.
- **Results:**
  - `npm ci`: succeeded.
  - `npm test`: 85 pass, 0 fail, 1 skipped (the Chromium test, which `npm run test:browser` runs).
  - `npm run test:browser`: passes, with `PLAYWRIGHT_CORE` pointed at `/tmp/pwc/node_modules/playwright-core`, because Playwright is not a project dependency.
  - `npm run build`: 10 chapters, 27 files.
  - `tools/browser-check.mjs`: passes at 390x844 and 1440x900 in light and dark, with 25 figures.
  - The equilibrium integration check passes for every chart.

**Follow-ups:** the maintainer's decisions on the title-page line and the three borderline passages; the colophon's Editions list needs a new entry with each published edition.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-book-colophon-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3842012 cached reads)
- Output: 24101 tokens
- Cost: $2.2423904000000006
- Wall-clock: 428s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
