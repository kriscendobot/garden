---
role: web-designer
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---

# Design the per-chapter/section illuminated illustration set for Better Code and Gardens

Repository: `kriscendobot/garden-book`.

This is the DESIGN stage of the maintainer-authorized illumination production. Work only in this repository, using an isolated project worktree obtained with `scripts/jobs/ensure-project-worktree.sh book-illumination-design-20261004 kriscendobot/garden-book <branch>`. Read `AGENTS.md` or equivalent repository instructions before changing anything. Read the current merged `main`, including every chapter, every section heading, `build/README.md`, the existing `art/` assets and manifest, and the current JavaScript generator.

The maintainer wants the dense narrative broken up by thematic images: ideally one image for every chapter, plus images for sections whose content is distinct enough to earn one. Use editorial judgment; do not mechanically assign an image to every section.

Create `art/chapter-illustrations-brief.md`. It must contain one entry per proposed image, and each entry must include:

- the exact target chapter or section anchor used by the current generator;
- that chapter/section's central theme in plain words;
- a concrete visual description that makes the theme legible rather than merely decorative;
- an ornate illuminated-manuscript treatment with a gardening motif throughout;
- accessibility/pacing guidance useful to the later integration step, including an appropriate composition/aspect-ratio suggestion where helpful.

Use these two motifs subtly where they fit naturally, not in every image and never as foreground gimmicks: a wizard tower with a beacon glimpsed within a natural scene, and hanging gardens. The set should feel coherent without repeating the same scene.

Explicitly assess the existing flat background image introduced by the first illustration edition (PRs #4/#5). Recommend keep, drop, or repurpose it (for example, title-page-only), and explain why in light of the maintainer's judgment that it does not add much.

Do **not** specify exact hex colors or lock a palette. State verbatim or equivalently in the brief that **anchoring the color scheme is the next step's job**. Codex owns that choice in the production stage.

This job creates the thematic brief only, not the SVG assets and not generator integration. Commit the brief on a dedicated branch, push it, and open a draft PR using `scripts/jobs/gardening/ensure-pr.sh book-illumination-design-20261004 kriscendobot/garden-book <head-branch> main --title ... --body-file ...`. Rediscover an existing marked PR before opening a new one. Report the PR URL, image-entry count, chapter/section coverage, background-image recommendation, and any genuine ambiguity. Do not merge or publish.

The supervisor is authorized to review and merge this design PR. A successful design PR may stage the normal draft-PR review machinery; leave it intact and report it rather than pretending it does not exist.

Self-improvement: follow the standing skill at the end of the engagement.
