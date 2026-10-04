---
role: web-designer
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
---

# Render the review-economics chart specification as accurate SVGs

Repository: `kriscendobot/garden-book`. This is VISUALIZE, stage 2 of the production supervised by `book-equilibrium-data-supervisor-20261004`.

The accepted data/draft is the existing draft PR https://github.com/kriscendobot/garden-book/pull/12, branch `book-equilibrium-data`, exact starting head `6035935a849ba824c84d63ad9b0b41399a4a2a47`. Do not open a second PR. Work in an isolated checkout:

```sh
/home/kris/garden/scripts/jobs/ensure-project-worktree.sh book-equilibrium-visualize-20261004 kriscendobot/garden-book book-equilibrium-data
```

Fetch and check out the current remote branch; require that it contains the accepted starting head, then push your commits back to that branch without overwriting concurrent work. Keep the PR draft. Do not merge or publish.

## Source of truth

Read `art/equilibrium-data-spec.md` completely. Render **every chart E1 through E9** as an actual SVG asset using exactly the series, labels, units, sample counts, observed/derived/scenario distinctions, annotations, caveats, and phone layouts in that specification. The committed `data/equilibrium/aggregates.json` and `data/equilibrium/scenario.json` are machine-readable checks on the spec. Do not re-derive, reinterpret, smooth, omit, or change the data. If a spec value disagrees with its committed data, stop and report the discrepancy to the supervisor instead of silently choosing one.

The charts should make the argument visually legible, not look like nine generic bar charts. In particular:

- E8 must make the marginal crossing/minima obvious as the human-review cost rises and residual risk falls.
- E9 must make diminishing returns from additional machine rounds obvious without implying the scenario is observed.
- E4 should communicate the orders-of-magnitude latency gap between automated and human review.
- E7 must keep its strong caveat visibly attached to the learning-flow evidence.

Use chart forms and axes exactly as specified. Preserve log scales where required. Essential meaning must never depend on color alone. Use direct labeling, line treatment, shapes, patterns and annotations. All scenario graphics must visibly say "scenario".

## Asset and generator requirements

- Prefer a deterministic generator under `art/` or `tools/` that reproduces the committed SVGs byte-for-byte from the committed data, plus tests that verify reproduction and exact numeric labels/series.
- Use stable, globally unique SVG IDs prefixed per asset. No external references, remote fetches, embedded fonts, scripts, event handlers, `foreignObject`, or inline `style` attributes. The SVGs must be safe to inline under the book's CSP.
- Each asset needs a meaningful `<title>` and `<desc>` matching the spec's alt-text intent. Preserve the separate exact-value table requirement for the later integration stage; do not try to hide a data table inside SVG text.
- At 353 px rendered width, labels must remain at least 12 px and nothing may clip or require horizontal scrolling. Also verify the SVGs in the book's dark scheme.
- Read `art/MANIFEST.md` and the current illuminated assets for technical conventions. Use the existing 13-color palette and semantic color roles as the spec directs, but do not spend this stage on manuscript ornament: the next Codex stage owns final borders, texture, typography, and ornamentation. Geometry, axes, data encodings, labels and accessibility semantics must be complete now.
- Add the new assets and their deterministic mapping/spec provenance to `art/MANIFEST.md` or a dedicated adjacent manifest section so later integration has unambiguous filenames for E1–E9.

Do not insert the charts into the generated book yet unless a minimal preview harness is required to test them; the styling stage must be able to alter visual treatment without disturbing manuscript integration.

## Verification and handoff

Run the repository's tests and add coverage for all nine chart assets: deterministic generation, exact spec numbers/labels, safe inline markup, globally unique IDs, no disallowed elements/references, and complete E1–E9 mapping. Render and inspect all nine charts in an actual browser at 353 px in both light and dark modes; record concrete results and any screenshots/evidence in the PR or committed evidence. Check that log axes and clipped/off-scale annotations remain truthful.

Push to the same draft PR, report the exact new head SHA and asset list to:

```sh
/home/kris/garden/scripts/jobs/inbox-send.sh book-equilibrium-data-supervisor-20261004
```

If you genuinely finish but cannot achieve the gated deliverable, emit `<<<GARDEN-ORCHESTRATION-FAILED>>>` immediately before your completion signal.
