---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
arc: garden-book
---
# Garden book: the published edition still shows the old "junk" SVGs; fix and republish

Repository: kriscendobot/garden-book. Charged to the `garden-book` arc.

Maintainer report (kriskowal, liaison session 2026-10-14): the book "claims to have fresh illuminated illustrations, but I am still seeing the junk SVGs." He asked for a follow-up job "all the way to republish". That request is the explicit maintainer authorization for every step below, including the merge of the resulting garden-book PR(s) after a clean gauntlet and the republish. There is no other external write beyond kriscendobot/garden-book and the ocap.site publish.

## Establish what is wrong (do this first, report it plainly)

The latest published edition is https://5kwirevgc77outc6vptymbj6tfwpwuldnb74qumkrs55qlxzxutq.ocap.site/ (source `eaf634ae`). Earlier editions, still live and immutable, are https://xddmohl7mf56oiaps45dm6vtoouoxhxkkpocwzuskmwg6mhzggea.ocap.site/ and https://dnl43y7ksqqrkfzkzsiyzhfoqks7tnxpedzi7gfymzviqo7uvkda.ocap.site/. The maintainer may be viewing one of those; do not assume.

1. Load the latest edition in an actual browser (phone and desktop, light and dark) and inventory every SVG on the page by role: the 25 illuminations placed by `art/MANIFEST.md`, the chapter dividers (`art/divider-*.svg`), the figures (`art/figure-*.svg`), the equilibrium charts, and the glyph sprite. Say which ones render, which are missing, and which are the old hand-made figures and dividers rather than the illuminations.
2. Compare the page against `art/MANIFEST.md` and the build (`build/`): is every manifest anchor wired, is any illumination silently falling back to an older figure, is anything clipped, collapsed, or unstyled by the CSP or CSS, is any markup stripped on the way to the clip?
3. Judge the illuminations on their merits against `art/chapter-illustrations-brief.md`. `art/generate-illuminations.mjs` produces them procedurally; if the output is simply poor art (primitive shapes, indistinct, repetitive, not legible at phone width), say so honestly with screenshots or rendered observations. That would be the real finding: the claim of "fresh illuminated illustrations" would then be accurate about the pipeline and wrong about the quality.
4. State the root cause in the PR body and in your result. If it is only that the maintainer saw an older edition, say that and stop: publish nothing and open no PR, and explain how to reach the current one.

## If there is a defect

Fix it in a PR against live `main`, following the project's own instructions and the repo's tests (`npm ci`, `npm test`, `node build/build.mjs chapters out`). If the root cause is art quality, redo the illuminations to a real standard against the brief, keep the accessibility properties the existing tests fix (no color-only distinctions, no unsafe or external content, ID collision checks), and do not remove content to make a test pass. Remove any dead "junk" figure or divider that the new set supersedes, or say why one stays. Keep it economical: one concise pass, no speculative rewrites of chapters.

Then drive it to the end, posting dated blocked successor jobs (`post-plan.sh --blocked --blocked-on <PR URL>`) for the steps your tier cannot finish in one run:
1. Gauntlet on the PR (`scripts/jobs/post-gauntlet.sh`, or the completion machinery's staged one; do not stage extra rounds).
2. Merge on a clean gauntlet with open/mergeable/un-drafted/green-or-no-checks guards. Do not merge over a red or conflicted PR.
3. Republish as a new immutable ocap.site clip (never `upgrade`), following `skills/minion-town-clip-publishing/SKILL.md` (inert `powers` pet name, never `sites` or `@agent`; the skill's `powers: "sites"` example is stale and unsafe, fix it in the garden repo if you can touch it, otherwise report it). Verify published bytes equal the build output, check the live page in a real browser at phone and desktop widths in light and dark, and confirm the illuminations the maintainer cares about actually render. Record the edition in the edition history as before (PR #14 is the template).

Report the new URL only after the publish is verified. Send the maintainer one concise message at the end with the root cause, the PR link(s) and the URL.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-14T03:58:44Z
