# Fix round 9: kriscendobot/garden-book PR #15

I applied all three must-fix items from the round-9 panel and pushed them to the PR head as two commits: `92124597e3` → `f8fec61`. `npm test` passes (77 pass, 1 skipped). CI counts as green only because the repo has no checks at all, so nothing ran.

**1. decomplector: the local HTTP server is gone (`9b23b82`)**
- I deleted `tools/clip-server.mjs` and `test/clip-server.test.mjs`.
- For a local edition, `tools/browser-check.mjs` now loads exactly the files `makePublishContent` returns. Playwright serves them in-process through `context.route("https://edition.invalid/**", …).fulfill` under the clip's CSP. Any file the clip leaves out answers 404.
- The CSP constant now lives in `tools/browser-check.mjs` and is exported from there, along with `EDITION_ORIGIN`, `loadPlaywright` and `findChromium`. `checkEdition` takes an optional `plates` list in place of the old `serve` hook.
- I rewrote the fake-browser tests in `test/browser-check.test.mjs` around the route handler. They cover: the CSP header, a 404 for an unpublished file, refusal when a declared plate is missing, context closing on failure, and CSP console violations.

**2. coverage-auditor: `measure()` is now tested in a real browser**
- The new `test/browser-check-chromium.test.mjs` builds a fresh edition and checks that all four configurations report no problems and 25 figures.
- It also builds a known-bad copy (plates forced to 3000px wide plus an inline `<script>`). Every configuration must report sideways overflow, "art leaves the viewport", and a CSP violation. That last one confirms Chromium enforces CSP on fulfilled responses.
- Playwright isn't a dependency of the book, so the test is skipped under a plain `npm test` and the skip message gives the reason.
- I ran it manually with playwright-core 1.64.1 and headless shell 1243, and it passed.
- The command-line gate on the same build also passed: scroll widths 390/390 and 1440/1440, 25 figures, minimum caption contrast 5.68:1, minimum body contrast 12.9:1. The PR body now records that run and explains the skip.

**3. pruner: deletion-only prose cuts (`f8fec61`)**
- **`build/README.md`:** folded § Multi-file output into the build-artifacts paragraph. Removed the 1.x→2.0.0 history sentence and the test tour from § Tree contract. Updated the browser-check paragraph for the new loading path and the Chromium test.
- **`art/OPENAI-ILLUMINATIONS.md`:** removed the duplicated publish-limit rationale.
- **`art/illumination-redraw-evidence.md`:** removed the restated opening and § Replacement, but kept the contact-sheet link because nothing else carries it. The policy section now points to `tools/browser-check.mjs` instead of the deleted server.
- **PR body:** cut the stale "uploads every relative image" sentence and the browser-check sentence.
- The pruner's suggested cut in `test/clip-server.test.mjs` went away with that file.

**CI**
- The first `ci-wait-merge.sh` run waited on an empty check list. garden-book has no `.github` directory, so no checks will ever attach.
- I stopped that run and reran with `GARDEN_CI_ALLOW_NO_CHECKS=1`. It returned rc 0 with "total=0 → CI GREEN".

**Follow-ups**
- The coverage-auditor's non-blocking suggestion still stands: add c8 to `npm test` so that seat gets a coverage report.
- Without Playwright in CI, the Chromium test only runs when someone sets `PLAYWRIGHT_CORE`.
- The panel-10 driver should know that every CI wait on this repo needs `GARDEN_CI_ALLOW_NO_CHECKS=1`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2241266 cached reads)
- Output: 18892 tokens
- Cost: $1.4931651999999997
- Wall-clock: 865s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
