I applied the round-5 panel fixes to kriscendobot/garden-book PR #15 and pushed them as two commits (cb9f9bd → 6908701). `npm test` passes locally (71/71). The repo has no CI, so "green" only means there were no checks to fail.

**Archivist (three should-fix items):**
- **Tree contract** (`build/README.md`): it now says the build does not check `file`, `width`, `height` or `alt`, and names what does. The values come from the metadata map in `build/illuminations.mjs`. `test/illustrations.test.mjs` checks the dimensions against the WebP headers and that the alt text is descriptive. Publishing refuses a plate reference that isn't a `.webp` in the output.
- **Browser check** (`tools/browser-check.mjs`): the column "Tallest figure" is now "Tallest plate", and `tallestSvg` is now `tallestPlate`.
- **CSP header** (`tools/clip-server.mjs`): it now names the four directives the garden skill documents (script-src, style-src, connect-src, img-src) and says the rest of `CLIP_CSP` is this tool's assumption.

**Pruner (items 1–8):**
- **`build/README.md`:** removed the "no longer a single `index.html`" narration and the dated byte counts. The limit, the test pointer and the recovery steps stay.
- **`art/illumination-redraw-evidence.md`:** removed the sentence about what was deleted and the paragraph that repeated other docs. The contact-sheet link stays.
- **`art/MANIFEST.md`:** removed the scene-description column and the redundant first clause of the alt-text note.
- **`art/chapter-illustrations-brief.md`:** removed the critique of the retired title scene, plus the paragraphs about reusing it and the garden-bed figure, since both files are gone. The section is now "Existing paper texture" and keeps only the texture paragraph.
- **PR body:** the verification and publish-size paragraphs now link to the `build/README.md` sections instead of repeating them. I dropped the old claim that the browser check "passed on this head" because I did not run it on this head.

I also posted a summary comment on the PR, since the scribe noted that earlier fix rounds had none.

**CI:** with no checks, `ci-wait-merge.sh` by default keeps waiting on an empty check list until its deadline. I stopped that run and reran it with `GARDEN_CI_ALLOW_NO_CHECKS=1`, which returned rc 0 (total=0, failed=0), as fix round 4 did.

**Follow-ups:**
- The driver posts panel round 6.
- garden-book gauntlet stages should set `GARDEN_CI_ALLOW_NO_CHECKS=1` from the start, so they don't wait out the deadline.
- I left the archivist's comment-only notes alone: the uncited `json.dumps` claim, "before writing anything" vs. "before calling publish", and the `MANIFEST.md:9` wording.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1450632 cached reads)
- Output: 9023 tokens
- Cost: $1.0932184
- Wall-clock: 860s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
