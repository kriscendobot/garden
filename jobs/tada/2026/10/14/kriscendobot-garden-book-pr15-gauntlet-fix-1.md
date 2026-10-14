## Gauntlet fix round 1 for kriscendobot/garden-book#15: done, with a publishing blocker escalated

I fixed all three must-fix items. While checking the first one against the live host, I found that the PR's edition can't be published at all, so that now needs a maintainer decision.

**Commit history (packager must-fix items 2 and 3).** I rewrote the history and force-pushed it with `safe-push-pr-head.sh --mode rewrite` (`755ef9b` → `7ad6fef`). The procedural-redraw commit `05f1907` is gone. The 71-file commit is now three commits, and `755ef9b` is folded into the second. The file tree after those three is identical to the old `755ef9b`, and `npm test` passes at every commit.
1. `340dba1`: adds the 25 WebP illustrations, the contact sheet and the prompt record.
2. `02a0726`: switches the build pipeline, tests and tools to raster images.
3. `c7d9e9e`: removes the SVG plates, their generator and the unused SVGs, and updates the manifest, the evidence file and the art-inventory test.

**CSP and host (migrator must-fix item 1).**
- **The CSP is not a problem.** Every published `ocap.site` clip I fetched sends `img-src 'self' data:`, so same-origin images load.
- **The check tool now uses the real policy** (`4369491`). `tools/illumination-check.mjs` serves its preview over local HTTP with that exact CSP header and fails on any CSP violation. It passes with all 25 images in both color schemes. A control run with images blocked failed with 50 violations, as it should. I also fixed the `.svg` → `.webp` naming bug in that tool, which the panel listed as should-fix.
- **A small live test clip worked.** I published `index.html`, `styles.css` and one image. The image came back as `image/webp` with identical bytes and rendered in Chromium with no errors. I then unpublished it.
- **The full edition cannot be published.** A real publish returned HTTP 413:
  - minion.town limits each `/mcp` request to 2 MB (`MCP_JSON_BODY_LIMIT` in `src/http.ts`, a maintainer decision from 2026-09-23 that is meant to drop to about 64 KB later).
  - The whole book goes up in one request, and with the images it encodes to about 11.3 MB.
  - Test uploads were accepted at 1.89 MB and rejected at 2.80 MB.
  - `index.html` alone takes about 1.4 MB, so the 25 images would have to be about 16 KB each to fit.

**Size guard** (`7ad6fef`). `build/publish-book.mjs` now checks the encoded size before writing anything and fails with a clear size error. Before, it surfaced as a misleading "MCP unreachable" 413. I added a test for this. The README and `art/illumination-redraw-evidence.md` (new section "Published-clip verification") record the findings. I also marked the brief's leftover `title-garden.svg` reference as historical.

I posted a summary comment on the PR and sent the maintainer the decision through the liaison inbox. The options are:
- (a) wait for the out-of-band (git-HTTP) clip upload that minion.town plans,
- (b) raise the 2 MB limit,
- (c) shrink the images to about 16 KB each, or
- (d) go back to inline SVG art.

**CI:** the repo has no workflows, so `ci-wait-merge.sh` only reports GREEN (0 checks) when run with `GARDEN_CI_ALLOW_NO_CHECKS=1`; it returned rc 0. A first run without that flag was still pending in the background when I finished and will be stopped automatically.

The panel's other should-fix items (stale files in the output directory, aspect ratios not checked against image sizes, the `×` character) are not addressed. The next panel round can decide on them.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4618010 cached reads)
- Output: 26136 tokens
- Cost: $2.3655780000000006
- Wall-clock: 997s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
