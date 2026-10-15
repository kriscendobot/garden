I've applied all of panel-7's must-fix items to kriscendobot/garden-book#15 and pushed them. CI came back green, though this repo has no CI workflows, so that result just means zero checks ran. The real proof is `npm test`, which passes locally (90 tests).

**Pushed:** six follow-up commits on `garden-book-illuminations-republish-20261014`, moving the head from `f1b549b` to `df9e13a` with `safe-push-pr-head.sh` (advance mode, so no history was rewritten).

- **`e974cd2`, symlinks (locksmith, saboteur, wire-watcher):** the clip server now uses `lstatSync`, so a symbolic link gets a 404 instead of its target's contents. A new test fails against the old `statSync` and passes with the fix. Another test serves a real committed WebP plate and checks the 200 status, `image/webp` type, and exact bytes (prover).
- **`177b600`, browser contexts (engine-realist, typist):** `checkEdition` now closes each Playwright context in a `finally`, and `serve` has a typed JSDoc signature. A new test makes page loading fail and checks that both the context and the server get closed. The fake browser in the tests now fetches the edition's real WebP plate.
- **`1e080b2`, publish URLs (corner-prober, breaker):** relative image URLs are normalized, so `./x.webp`, `x.webp?rev=1` and `x.webp#figure` all publish as `x.webp`. Publishing now refuses `srcset`, `<source>`, `..` paths and subdirectory paths. These tests ended up in the `1890df4` commit because they share a test file with the property tests.
- **`553bde1`, naming (stylist):** the placement field `alt` is now `alternativeText` in the data and tests. The rendered HTML still uses the `alt` attribute.
- **`1890df4`, property tests (fast-checker):** I added `fast-check` as a dev dependency, with property tests for byte preservation through publishing (200 runs) and for the Node tree's `writeBytes`/`readBytes` round trip.
- **`df9e13a`, docs:**
  - **migrator:** `build/README.md` now marks the binary tree contract as a breaking change, and the package version goes from 1.0.0 to 2.0.0. That bump is in `package.json`/`package-lock.json`, which also landed in `1890df4`.
  - **benchmarker:** `art/OPENAI-ILLUMINATIONS.md` explains why comparing other encodings isn't worth doing.
  - **integrator:** the em dashes are gone from the evidence prose.
- **PR description (pruner):** trimmed the per-file tour down to the behavior summary and the one layout change reviewers need to check.
- **Missing summaries (scribe):** posted one comment covering the fix rounds 2–4 that never got a summary, plus this round.

**CI wait:** the first `ci-wait-merge.sh` run waited for checks that never appear, so I stopped it. I reran it with `GARDEN_CI_ALLOW_NO_CHECKS=1` (the opt-in for a repo without CI), and it returned rc 0 with `total=0`.

**Not checked:** I couldn't run the real browser check (`tools/browser-check.mjs`) because Playwright isn't installed on this host. The changed browser-check code is covered only by the fake-browser unit tests.

**Follow-ups:** none from me. The driver re-posts panel-8.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2339885 cached reads)
- Output: 18029 tokens
- Cost: $1.4977569999999998
- Wall-clock: 902s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
