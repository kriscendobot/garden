---
role: orchestrator
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-10-04T05:46:04Z cleared=none -->

---
role: orchestrator
provider: anthropic
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---

# Supervise garden-book illumination after the single Codex revision: integrate, merge, publish

Repository: `kriscendobot/garden-book`. Parent production/sentinel: `book-illumination-supervisor-20261004`. Predecessor supervisor: `book-illumination-supervisor-after-assess-20261004`. Outer serial campaign: `book-illumination-and-data-orch-20261004`. Revision job: `book-illumination-revise-20261004`.

## Durable state at handoff (2026-10-04)

- Prior edition live at https://g2d5d5z6x25qmf43fhv5tm4zmv4ozbxgk5gtke3mkrydrojehaea.ocap.site/ ; PRs #1-#7 merged (design PR #7 at `ab5990ed51bafaa5ad4cfde2d65194f53a08ea9f`).
- Production draft PR https://github.com/kriscendobot/garden-book/pull/9 (branch `book-illumination-assets`, base `main-ab5990e`), reviewed head `063d0bb24c4ef45a55b9c159ed56cff3dab8ad94`: 25 SVGs / 25 anchors, 13-color palette, tests and build passing.
- Fable thematic review (the required gate, DONE): https://github.com/kriscendobot/garden-book/pull/9#pullrequestreview-5404453977 — verified by the predecessor to cover that exact head, with 25 per-image notes, set-coherence, motif (clean: tower x2, hanging gardens x2, all brief-sanctioned) and palette (clean, light+dark) judgments, verdict CHANGES REQUESTED with findings A1 (ch9-three-indexes), A2 (ch10-inference-tiers), B (ch8-feedback-loops opener duplicates section figure), C (ch7-named-paths + ch9-reading-basket arrow signposts, reader; ch9-hanging-library stray spine). Non-blocking note: set is at the plain end of "illuminated".
- The single bounded revision `book-illumination-revise-20261004` (builder, openai/mentor, automatic) was posted with exactly those findings. There is NO second thematic-review/revision loop.
- The producer-staged code gauntlet (`book-illumination-produce-20261004-gauntlet`, was at panel-1) is supplementary only; it must not substitute for or overrule the Fable gate. Withdraw it if it obstructs integration.

## Work

1. Read the revision job's `tada/` report and the PR #9 comment it posted; verify the per-finding changes against the new head (render the changed SVGs; `skills/svg-visual-review/SKILL.md`). Record any residual concerns honestly and proceed regardless. If the revision did not complete, record that and proceed with the reviewed set — do not post a second revision.
2. Merge (or have merged) PR #9 into its base / restack onto `main` as needed so the assets are on `main`.
3. Post INTEGRATE as a distinct automatic job with these exact pins:

```yaml
role: web-designer
tier: mentor
fallback-tier: minion
dispatch: automatic
```

   It must use the current JavaScript generator (`build/build.mjs` or current equivalent), weave the approved images where they improve pacing rather than mechanically topping every section, and follow the design brief's old-background recommendation (try a tighter title-only border/corner reuse; remove it if it still reads as generic). Require reproducible build verification and actual browser checks at phone width and desktop in both light and dark modes, explicitly covering text/image contrast, readability, responsive placement, and horizontal/vertical overflow, with recorded browser evidence. Preserve accessible alt text/captions and inline-safe SVG behavior. Before ending this claim unfinished, post a dated supervisor successor blocked on INTEGRATE.
4. Finish: review and merge the integration into `main`, run the documented publication steps, verify the new live edition in an actual browser, append its URL and full provenance to `build/README.md` history without deleting older editions, send exactly one maintainer message with the new edition URL, and only then tell `book-illumination-supervisor-20261004` the production is done (all PR URLs, merge SHAs, build/browser evidence, live URL, known residuals).

Send an updated durable-state message to `book-illumination-supervisor-20261004` at every handoff. Scope remains `kriscendobot/garden-book`; no upstream repos, no fleet/budget config. Ask the maintainer only for decisions genuinely unavailable from the brief, review, evidence, or granted authority.

Self-improvement: follow the standing skill at the end of every claim.
