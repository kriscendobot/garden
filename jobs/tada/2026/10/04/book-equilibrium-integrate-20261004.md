All nine section 8.8 review-economics charts (E1–E9) are now in the book, and the integration is pushed to the shared draft PR https://github.com/kriscendobot/garden-book/pull/12 on branch `book-equilibrium-data`.

**New head SHA: `b20a3ec80f515d512b5c0a80f3516eaa6d8d9239`.** It went straight on top of `634e04b`, which contains f4e89b0, 479fb39 and 634e04b. Nothing had landed in between, so no rebase was needed. Since then the supervisor has confirmed that the gauntlet added three compatible commits on top of it; the branch head is now `64903d0c38c6d8a305fe33b58a58c0b4ca3370d9`. They re-ran the tests there (58/58), the build succeeded, and the charts are still placed correctly. The PR is still a draft; I did not merge, publish or open another PR.

**Placement**
- `build/equilibrium-charts.mjs` places the charts the same way `illuminations.mjs` places the plates. Each chart names its heading anchor and how many paragraphs to pass before it.
- The build fails if a heading is renamed, if an anchor is outside 8.8, if a paragraph count runs past the next heading, if the art is missing or doesn't match, or if a chart is placed twice.
- Each chart sits at the subsection and paragraph the spec names. Charts that share a subsection (E1/E2, E3/E4, E8/E9) always have prose between them, and the 25 illuminated plates have not moved.

**Each chart in the page**
- The SVG is inlined unchanged inside a captioned `figure`. Directly after it is a `details` disclosure titled "Exact values: <chart title>" holding the exact-value tables.
- Seven captions are the generator's drafts unchanged. The E8 and E9 captions also state their sample sizes and the cutoff, which the spec requires of every caption.
- Tables E1–E5 match the spec's tables cell for cell, with two exceptions:
  - E1 leaves out the spec's Color column, which is a drawing instruction rather than data.
  - E2's Notes column is set as notes under its table so the table fits a phone screen.
- Tables E6–E9 are built from the spec's lists and `scenario.json`. A missing value reads "not recorded", never zero.
- I removed two prose tables that the charts now replace: the latency table (E4 covers it) and the three cost rows of the per-PR table (E1 covers them).
- The chart CSS snippet is copied into `build/styles.css` along with the figure and disclosure styles. Numbers, and a number with its unit like "15.2 h", never wrap mid-value. There is no inline style and no CSP change.

**One fix to the chart art.** E8's screen-reader description said the minimum at a $400 loss is 41 minutes; the data, the plot label and the spec all say 42. I corrected the string in the chart generator and regenerated E8. Only that description text changed.

**Verification**
- **Tests:** `npm test` passes 57/57. The new `test/equilibrium-placement.test.mjs` covers:
  - each chart placed exactly once inside 8.8, and every way a placement can drift failing the build;
  - every caption, table and note;
  - every table value checked against the committed JSON and the spec;
  - IDs unique alongside the 25 illuminations;
  - no script, event handler, inline style, `src`, `foreignObject` or external reference in the page.
- **Build:** two builds into empty directories produced identical files: `index.html` `8c207275…3d23`, `styles.css` `859ffed2…49d0`.
- **Browser, nine charts:** the new `tools/equilibrium/integration-check.mjs` passes all 36 cases (nine charts at 390×844 and 1440×900, light and dark). Results:
  - no horizontal overflow, clipping or overlap;
  - chart labels at least 12 px;
  - every disclosure opens with Enter and closes with Space;
  - tables fit the column with no value split across lines;
  - table text at least 12 px;
  - text contrast 5.68:1 in light and 6.28:1 in dark.
- **Browser, whole book:** `tools/browser-check.mjs` passes on the whole book.
- **By eye:** I looked at all 36 phone screenshots (each chart and its opened table, in both schemes). The screenshots stop at the bottom of the screen, so they show only the top of the tallest charts and tables (E5, E8, E9). The automated checks covered those in full.
- **Evidence:** everything is recorded in `art/equilibrium-integration-evidence.md`.

The full report, with the head SHA and the test, build and browser results, went to `book-equilibrium-data-supervisor-20261004`. The supervisor replied that the integration is accepted at the current head. My summary comment on PR #12 was not posted: GitHub's API rate limit was hit and I stopped the stuck command. The committed evidence file serves as the record instead.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `634e04b9fc9f250826e82c2073340c35ba50d183`; this job presented `c7ff0a85a099ca69865f1b84e7a26e7c51711805`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-equilibrium-integrate-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 150 tokens (13411933 cached reads)
- Output: 77805 tokens
- Cost: $6.221894600000001
- Wall-clock: 1827s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
