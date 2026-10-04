---
role: orchestrator
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-10-04T05:26:05Z cleared=none -->

---
role: orchestrator
provider: anthropic
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---

# Reconcile Fable's illumination review, integrate, merge, and publish

Repository: `kriscendobot/garden-book`. Parent production/sentinel: `book-illumination-supervisor-20261004`. Current supervisor: `book-illumination-supervisor-after-produce-20261004`. Outer serial campaign: `book-illumination-and-data-orch-20261004`. Thematic reviewer: `book-illumination-assess-20261004`.

## Durable state at handoff (2026-10-04)

- The prior illustrated/retooled edition remains live at https://g2d5d5z6x25qmf43fhv5tm4zmv4ozbxgk5gtke3mkrydrojehaea.ocap.site/ and repository PRs https://github.com/kriscendobot/garden-book/pull/1 through https://github.com/kriscendobot/garden-book/pull/7 are merged.
- Design PR https://github.com/kriscendobot/garden-book/pull/7 merged at `ab5990ed51bafaa5ad4cfde2d65194f53a08ea9f`. Its 25-entry brief covers all ten chapter openers plus fifteen distinct section scenes.
- Production job `book-illumination-produce-20261004` completed with draft production PR https://github.com/kriscendobot/garden-book/pull/9. Original production commit was `1200afb01bee81a85ca208412e8e5863d3700811`; an auto-clean stage added a focused regeneration-path test, making the reviewed handoff head `063d0bb24c4ef45a55b9c159ed56cff3dab8ad94`.
- Supervisor verification on the production branch observed exactly 25 SVGs for the brief's 25 unique anchors, one manifest mapping per asset/anchor, 50 globally unique prefixed SVG IDs with all references resolved, no external/script/handler/unsafe elements, and the documented established 13-color palette. `npm test` passed 24/24 at the original production head and `npm run build` produced 10 files / 857,064 characters. The producer also recorded XML parsing and reduced-size rendered contact-sheet inspection.
- The assets depict concrete objects and relationships specified by the brief. The wizard tower/beacon is confined to the contextual chapter-1 metamorphosis and deliberate-deploy scenes; hanging/terraced garden imagery is reserved for the disposable host, library, and inference-tier contexts rather than repeated indiscriminately.
- The ordinary producer-staged gauntlet had already advanced into its clean stage before this supervisor could withdraw it while parked. It is supplementary and must not substitute for or overrule the required Fable thematic review.
- `book-illumination-assess-20261004` is the required manual Fable review, pinned to `provider: anthropic`, `model: claude-fable-5`, and explicitly authorized to post one structured GitHub review with separate notes for all 25 images plus an overall verdict.

First read the ASSESS completion report and the actual review on https://github.com/kriscendobot/garden-book/pull/9. Verify that it covered the exact current PR head and delivered all 25 per-image notes, motif/palette/set-level judgments, and a clear overall verdict. Do not substitute the ordinary code gauntlet for this thematic gate. Send an updated durable state message to `book-illumination-supervisor-20261004` at every handoff; that parent stays unfinished until merge, publication, history, and maintainer notification are complete.

## Reconciliation

If Fable's verdict is clean, proceed. If it identifies real problems, post exactly one bounded revision job back to Codex containing only Fable's specific findings, with these exact automatic pins:

```yaml
role: builder
provider: openai
tier: mentor
fallback-tier: minion
dispatch: automatic
```

The revision job may update the production PR and must report verification. There is no second thematic-review/revision loop: after this one revision, record any residual concerns honestly and proceed. Before ending any unfinished claim, post a new dated supervisor successor blocked on the outstanding review or revision so the chain remains durable.

## Integration

Post INTEGRATE as a distinct automatic job with these exact pins:

```yaml
role: web-designer
tier: mentor
fallback-tier: minion
dispatch: automatic
```

It must use the current JavaScript generator (`build/build.mjs` or its current equivalent), weave the approved images where they improve pacing rather than mechanically topping every section, and follow the design brief's old-background recommendation: try a tighter title-only border/corner reuse and remove it if it still reads as generic. Require reproducible build verification and actual browser checks at phone width and desktop in both light and dark modes. Those checks must explicitly cover text/image contrast, readability, responsive placement, and horizontal/vertical overflow, and must record browser evidence rather than relying on code inspection. Preserve accessible alternative text/captions and inline-safe SVG behavior.

## Finish

Review and merge the integration into `main`, run the documented publication steps, and verify the new live edition in an actual browser. Append its URL and full provenance to `build/README.md` history without deleting any older edition. Send exactly one maintainer message with the new edition URL. Only after all this is complete tell `book-illumination-supervisor-20261004` the production is done, including all PR URLs, merge SHAs, build/browser evidence, live URL, and known residual issues.

Scope remains `kriscendobot/garden-book`; do not touch upstream repositories or garden fleet/budget configuration. You may rebase, restack, reorder, withdraw low-value parked automation, merge into `main`, and post the single bounded revision if Fable requires it. Ask the maintainer only for a decision genuinely unavailable from the brief, Fable review, repository evidence, or granted authority.

Self-improvement: follow the standing skill at the end of every claim.
