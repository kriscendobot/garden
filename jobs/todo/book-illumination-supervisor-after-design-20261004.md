---
role: orchestrator
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-10-04T04:41:10Z cleared=none -->

---
role: orchestrator
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---

# Continue the illuminated illustration production after the thematic design brief

Repository: `kriscendobot/garden-book`. Parent production: `book-illumination-supervisor-20261004`. Design stage: `book-illumination-design-20261004`. Outer serial campaign: `book-illumination-and-data-orch-20261004`.

This is a dated successor supervisor for the maintainer's per-chapter/section illuminated illustration production. The parent supervisor deliberately remains unfinished as the outer orchestration's sentinel: **do not tell it to complete until the entire illuminated edition is merged, published, recorded, and messaged**. Send durable state updates to its inbox with `scripts/jobs/inbox-send.sh book-illumination-supervisor-20261004` at each handoff.

## State on posting (2026-10-04)

- The prior illustrated/retooled edition is live at https://g2d5d5z6x25qmf43fhv5tm4zmv4ozbxgk5gtke3mkrydrojehaea.ocap.site/ and `kriscendobot/garden-book` PRs #1-#6 are merged.
- `book-illumination-design-20261004` was posted with the required Claude/web-designer pin and owns `art/chapter-illustrations-brief.md`. This successor is blocked until that job reaches `tada/`.
- No new illumination asset, production PR, Fable review, integration, merge, or publish has happened yet.

Read the design job's completion report and its draft PR. Confirm the brief covers every chapter and only the distinct sections that merit extra images, tags every entry with a real chapter/section anchor, keeps the illuminated-manuscript gardening theme concrete, uses wizard-tower/beacon and hanging-garden motifs subtly, resolves the old flat-background question, and leaves exact palette selection to Codex. Use the granted authority to manage or withdraw a low-value auto-staged gauntlet at your discretion, but do not bypass a real unresolved finding. Merge the brief into `main` when it is sound.

Then post a distinct PRODUCE job, suggested basename `book-illumination-produce-20261004`, with **exact** automatic pins:

```yaml
role: builder
provider: openai
tier: mentor
fallback-tier: minion
dispatch: automatic
```

Its brief must require one illuminated-style, inline-safe SVG per entry in the merged design brief. Codex owns anchoring one consistent palette across the complete set: choose it, document it in a manifest alongside the assets in the established `art/MANIFEST.md` style, and hold every image to it. Preserve the ornate illuminated-manuscript/gardening aesthetic and the design brief's subtle placement of wizard-tower/beacon and hanging-garden motifs. Require no external fetches, CSP-safe SVG, unique IDs, and a draft PR. Do not let the job integrate images into the generator yet.

Before this claim ends with work remaining, post another dated supervisor successor blocked on the PRODUCE job. Carry this full remaining pipeline and updated state into it:

1. Once the production PR exists, post ASSESS via `scripts/jobs/post-manual-job.sh`, never `post-job.sh`, with body frontmatter `role: gardener`, `provider: anthropic`, `model: claude-fable-5`. This is a thematic-coherence review, not a code review. Fable must post a structured PR review with a per-image note and overall verdict, testing whether every image reads as its chapter/section theme, the illuminated-manuscript gardening aesthetic coheres, subtle motifs remain subtle and unforced, and Codex's palette is consistent.
2. Reconcile Fable's verdict in a Claude/mentor supervisor claim. If clean, proceed. If there are real problems, post exactly one bounded revision job back to Codex with the same pins as PRODUCE and only Fable's specific findings. Do not loop indefinitely; after one revision, note any residual concerns honestly and proceed.
3. Post INTEGRATE as a distinct automatic job with `role: web-designer`, `tier: mentor`, `fallback-tier: minion`, `dispatch: automatic`. It must use the current JavaScript generator (`build/build.mjs` or its current equivalent), resolve the old background per the design recommendation, and place images where they improve pacing rather than mechanically topping every section. Require reproducible build verification plus actual browser checks at phone width and desktop in light/dark mode, including text/image contrast, readability, and overflow.
4. Review and merge the integration, run the documented publish steps, verify the live edition, and update `build/README.md` history without deleting older editions. Send exactly one maintainer message with the new edition URL. Only then tell `book-illumination-supervisor-20261004` that the full production is done and supply PRs, merge SHAs, build/browser evidence, live URL, and known residual issues.

Scope stays `kriscendobot/garden-book`; no upstream repositories and no garden fleet/budget configuration changes. You may rebase, restack, reorder, withdraw, add the bounded jobs above, and merge into `main`. Ask the maintainer only for a decision you genuinely cannot make.

Self-improvement: follow the standing skill at the end of every claim.
