# Fix round 3 for kriscendobot/garden-book PR #6: pushed and green

I fixed the round-3 panel's must-fix items in three follow-up commits on top of `bfdd5b7`, pushed with `safe-push-pr-head.sh`, and left the PR head at `9fbd5aa`. The repo has no checks, so "green" comes from `ci-wait-merge.sh` with `GARDEN_CI_ALLOW_NO_CHECKS=1` (rc 0, total=0). The real gate also passes: `npm ci && npm test` runs 21 of 21 tests, and `node build/build.mjs chapters out` gives output byte-identical to the build before this round (`roles=36 skills=98`).

**Commits:**
- **`dea185c`** (breaker; assessor note; corner-prober #2):
  - The JSON-RPC peer now records its first closure error, whether from exit, spawn error, invalid JSON or `close()`. Any `call()` made after that rejects at once instead of hanging forever.
  - If sending a call throws, its pending entry is removed.
  - Write errors on the child's stdin (broken pipe) are ignored, because the exit handler already reports the closure.
  - New tests cover a call after exit, a call after `close()`, and a SIGTERM exit (`code=null, signal=SIGTERM`).
- **`da4e141`** (assessor; corner-prober #1 and #3):
  - A heading's own anchor now registers even when its parenthetical names another entry. Only the leading name claims an anchor. The existing test now expects `builder` to link within the book (role count 3).
  - `chapterKey` rejects `-part0` and `-part1` files, whose anchor prefix would collide with the unsuffixed chapter's.
  - Adds a test for slugging a character outside the Basic Multilingual Plane (a surrogate pair).
- **`9fbd5aa`** (purist base64; saboteur should-fix):
  - The hand-rolled base64 encoder is replaced with the web-standard `btoa`. I did not use `Buffer` because the PR keeps Node built-ins out of the core modules.
  - `publish.mjs` now names the `<bridge-environment-json>` argument when it fails to parse.

**Declined, with reasons given on the PR:**
- **Purist's `path.posix.normalize` suggestion:** `render-book.mjs` has no Node imports by design. I added a code comment explaining why the path normaliser is hand-written.
- **Corner-prober #4 (unclosed Contents list):** markdown-it with `html:false` always produces balanced lists, so real input can't reach that error. I added no test.

I posted a summary comment on the PR: https://github.com/kriscendobot/garden-book/pull/6#issuecomment-5967717272. As the scribe asked, it also gives the missing account of the round-1 fix commits (head `8fccc61`).

**Follow-ups (not done here):** the breaker suggested adding a "settle after close" check for subprocess-backed RPC peers to the adversarial-review skills. The purist suggested widening the reuse-over-reimplementation rule to cover Node and web built-ins. Both are garden-library changes; I left them for the driver or a later job.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-build-js-retool-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1647120 cached reads)
- Output: 13299 tokens
- Cost: $1.2153079999999998
- Wall-clock: 137s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
