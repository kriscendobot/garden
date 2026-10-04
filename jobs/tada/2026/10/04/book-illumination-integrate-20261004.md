I've opened draft PR https://github.com/kriscendobot/garden-book/pull/11 with all 25 approved illuminations woven into the edition. It isn't merged or published, and the supervisor successor has the PR URL, head SHA and verification summary in its inbox. Tests pass (30/30), the build is byte-identical across two clean runs, and all four browser configurations pass.

**Branch:** `book-illumination-integrate`, head `b716cab73d6dbeaf4caf0631ba75ae23888c1e2c`, against a new frozen base `main-32cf234` (which equals `main` at `32cf234`). No art file was changed.

**Placement**
- A new table, `build/illuminations.mjs`, says where each image goes. For every image it gives the target heading, how far into the section to place it, and a caption. The generator inserts the figures; nothing in the build output is hand-edited.
- The build fails, naming the image, if a target heading is missing, a figure would land outside its section, the paragraph count runs past the next heading, or the art file is missing. A renamed heading can't silently move an image.
- The 10 chapter openers sit under the chapter titles. The 15 section figures follow the brief's placement notes.
- One deliberate move: the ch1 bidding-market image sits two paragraphs into §1.5. The section opens with a quotation, and the picture reads better between "What is wrong with the race" and "What replaces it". The PR body says why.
- No image was dropped. The one portrait plate (ch9 opener) hangs in the margin on wide screens and folds inline at phone width.

**Inline safety and accessibility:** each SVG is inlined unchanged apart from an added class, keeping its `<title>`/`<desc>` as alt text. Each sits in a `figure` with a `figcaption`. All CSS is in `build/styles.css`. In dark mode the plates are dimmed slightly with a filter and stay legible.

**Old title background: removed entirely.** I tried the brief's alternative, a corner ornament cropped from the vine, trellis and lower bed. It read as a clipped, generic garden rather than a frame: the soft background washes showed a hard rectangular edge, and on phones it crowded the title. The interim chapter 2 garden-bed figure is also gone, since the chapter 2 opener replaces it. Both files stay in `art/`, and `MANIFEST.md` marks them as no longer used. The title-page edition note now reads "Edition of 2026-10-04, illuminated".

**Reproducible build:** two runs of `npm ci && npm test && node build/build.mjs chapters out` from clean gave identical output.
- `out/index.html`: sha256 `2f59a229a2323f24a2e4fe9e26c140ffa8b1766622f23db6694cc3bfa4c65c25`
- `out/styles.css`: sha256 `5a2598c7bb06bd7ec88b24a21776aa5e038842c91ac9ce80a62c9886a66273a7`

A new test file, `test/illuminations-placement.test.mjs`, covers the placement logic, the failure cases, and a full build from the real chapters. That build checks there are 25 figures, each placed once after its own heading, with unique ids and no inline style.

**Browser checks:** a new script, `tools/browser-check.mjs`, runs headless Chromium at 390×844 and 1440×900 in light and dark. It isn't under `test/` because `node --test` would pick it up there.

| Configuration | Horizontal overflow | Figure problems | Caption contrast (min) | Result |
| --- | --- | --- | --- | --- |
| Phone, light | none | none | 5.68:1 | pass |
| Phone, dark | none | none | 6.28:1 | pass |
| Desktop, light | none | none | 5.68:1 | pass |
| Desktop, dark | none | none | 6.28:1 | pass |

"Figure problems" covers clipped figures, runaway heights and overlap with text. To prove the check can fail, I injected an overlapping style once and it reported FAIL in all four configurations. I looked at 20 screenshots (title page, ch1 and ch9 openers, ch2 and ch8 section figures, in each configuration). No fixes were needed beyond a screenshot scroll offset.

**Screenshots:** they're on a separate branch, `evidence/book-illumination-integrate`, and linked from the PR body; none are committed to the PR. That branch can be deleted after review.

**Copy-edit PR #8:** its chapters build cleanly with this placement table, so all 25 target headings survive it.

**Garden change:** I added a note to `skills/svg-visual-review` on main2 (commit `14dc4b170b9`). It covers scripting browser checks with the copy of `playwright-core` already on the host, and keeping such scripts out of `test/`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-illumination-integrate-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (7131710 cached reads)
- Output: 51652 tokens
- Cost: $3.8917499999999996
- Wall-clock: 563s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
