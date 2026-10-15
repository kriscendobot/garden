Fix round 8 for kriscendobot/garden-book#15 is pushed, the local test suite passes, and the CI wait came back green. The repo has no CI workflow, so "green" only means there were no checks to fail (details below).

**Fixes, pushed as three follow-up commits (head moved from `df9e13a` to `9212459` via `safe-push-pr-head.sh`):**
- **Publish file list (decomplector, locksmith, saboteur, breaker, spec-keeper, wire-watcher, corner-prober).** `build/publish-book.mjs` no longer works out which images to upload by regex-matching `index.html`. `makePublishContent` and `publishBook` now take a `plates` list, which defaults to the plates declared in `build/illuminations.mjs`. That list is checked first: each name must be a WebP file directly in the edition directory, and publishing refuses if one is missing from the build output. Nothing else in the output tree is ever uploaded. New tests cover:
  - the default plate list;
  - an undeclared sibling WebP that the page names (quoted, unquoted, and with `>` inside an attribute) never being published;
  - a missing plate;
  - non-WebP, parent-directory and subdirectory names.
- **MCP client version (integrator).** The `initialize` call now reports the version from `package.json` (2.0.0) instead of `"1"`, and the test asserts that call (`calls[0]`).
- **Rename (stylist).** `fc` is now `fastCheck` in `test/build.test.mjs` and `test/units.test.mjs`.
- **Docs (archivist, integrator, pruner).**
  - `art/chapter-illustrations-brief.md` now says production is complete and `build/illuminations.mjs` is the asset manifest; the stale "SVG construction" wording is gone.
  - `build/README.md` describes the new publish behavior.
  - The defensive paragraph in `art/OPENAI-ILLUMINATIONS.md` about not benchmarking other encodings is cut.
- **PR title and body (integrator, gateway).** The title is now `feat(build)!: publish WebP illuminations as a multi-file edition`. The body gains a line explaining why `fast-check` is a root devDependency.

`npm test`: 86 pass, 0 fail.

**CI:** with the default settings, `ci-wait-merge.sh` would have waited the full hour on an empty check list. That's because the repo has no workflow, as its own `build/README.md` says. I reran it with `GARDEN_CI_ALLOW_NO_CHECKS=1`, which returned rc 0 with zero checks.

**Not addressed this round:**
- **packager:** splitting the 2.0.0 version bump out of commit `1890df4` would mean rewriting already-pushed history. That needs a rewrite-mode push, not a follow-up commit.
- **pruner:** the narrating comments and JSDoc block in `tools/browser-check.mjs` are still there.
- **purist (should-fix):** switching to `@endo/base64` was skipped; the module keeps its no-dependency exemption.
- **coverage-auditor:** a real browser test for `tools/browser-check.mjs` was not added. The repo has no `browser-test/` harness or CI to run one in.
- **integrator:** the request to trim the PR body's file-by-file pointers and methodology footer was not done.

**Follow-up:** the gauntlet driver should run its CI waits for this repo with `GARDEN_CI_ALLOW_NO_CHECKS=1`, or later stages will time out on the empty check list.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1879527 cached reads)
- Output: 12260 tokens
- Cost: $1.2610254
- Wall-clock: 1317s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
