---
role: web-designer
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
arc: garden-book
---

# Integrate the finished review-economics charts into the book

Repository: `kriscendobot/garden-book`. This is the layout INTEGRATE stage supervised by `book-equilibrium-data-supervisor-20261004`.

The shared draft PR is https://github.com/kriscendobot/garden-book/pull/12, branch `book-equilibrium-data`. The required starting history includes VISUALIZE `f4e89b070794639419bc096b8351f9ff33b965e7`, STYLIZE `479fb3995d3dc8f47de70e129dec3498f4b27c82`, and the first panel's data/model fixes through `634e04b9fc9f250826e82c2073340c35ba50d183`. Fetch the current branch and require that it contains all three before editing. Work in:

```sh
/home/kris/garden/scripts/jobs/ensure-project-worktree.sh book-equilibrium-integrate-20261004 kriscendobot/garden-book book-equilibrium-data
```

Do not open a second PR, merge, publish, or take the PR out of draft. Push integration to the same branch without overwriting concurrent work.

## Integrate, do not reinterpret

Place all nine finished E1–E9 SVGs into section 8.8 at the anchors and narrative pauses specified in `art/equilibrium-data-spec.md` and the chart manifest. Add a deterministic placement mechanism analogous to `build/illuminations.mjs`, or extend that mechanism cleanly, so a renamed/missing heading or asset fails the build rather than moving silently.

For every chart:

- Inline the SVG safely as a meaningful `figure`, preserving its `role="img"`, `<title>`, `<desc>`, chart ID and all data/geometry/style exactly.
- Add the draft caption from the chart generator/manifest, edited only for surrounding prose and accessibility. It must state observed/derived/scenario kind, sample size and cutoff as the spec requires.
- Add the spec's exact-value HTML table directly after the figure, preferably inside an accessible `details` disclosure when the table is large. The values, labels and units must exactly match `art/equilibrium-data-spec.md` and the committed JSON. Missing values must read "not recorded", never zero.
- Copy the chart CSS snippet into the same-origin `build/styles.css` in a maintainable section; no inline styles and no CSP weakening.
- Avoid duplicating the manuscript's existing prose tables unnecessarily: when the chart + disclosure faithfully replaces a table, remove the redundant prose table; otherwise keep the prose readable without making the reader parse the same dense numbers three times.

The nine figures should form deliberate pauses, not a wall of graphics. E1/E2, E3/E4, and E8/E9 share subsections: space and place them so each answers a distinct question. Keep the existing 25 illuminated plates in their positions.

Do not change the analysis, prose argument, aggregates, scenario values, chart data, chart generator, or visual styling except for a necessary integration bug that you report explicitly. A concurrent old gauntlet may advance against earlier heads; rebase safely and preserve any substantive data fixes it lands.

## Verification

Add tests that prove:

- all nine charts are placed exactly once at the intended section anchor and cannot drift out of that section;
- every chart has its caption and exact-value table/disclosure;
- every exact value rendered in the tables is checked against the committed data/spec;
- all inline IDs remain globally unique with the 25 illuminations;
- no external references, scripts, handlers, inline styles or `foreignObject` enter the built HTML.

Run the full tests and build twice from clean output directories, comparing hashes for reproducibility. Run a real browser over the complete built book at 390×844 and 1440×900 in light and dark. Check no horizontal overflow, clipping, figure/text overlap, or illegible chart/table/caption text; check that every disclosure is operable; inspect at least all nine chart placements on phone and both schemes, not just a sample. Record concrete evidence in the PR or a committed integration evidence file.

Push the same draft PR and report the exact new head SHA plus test/build/browser results to:

```sh
/home/kris/garden/scripts/jobs/inbox-send.sh book-equilibrium-data-supervisor-20261004
```

If you genuinely finish but cannot integrate all nine charts with their exact values and accessibility gates, emit `<<<GARDEN-ORCHESTRATION-FAILED>>>` immediately before your completion signal.
