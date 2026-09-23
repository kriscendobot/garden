All 27 checks pass — CI is **GREEN** on the final head `ed5fbadabe`. The fix stage is complete.

## Completion report

**FIX round 2 — endojs/endo-but-for-bots PR #1085** (streaming mount search `streamGlob`/`streamGrep`)

Applied all seven of the panel-2 must-fix items as review-feedback follow-up commits to the PR head `feat/mount-stream-glob-grep`, pushed via `safe-push-pr-head.sh`, and drove CI to green (27/27 pass).

**Must-fix items applied:**
1. **Revocation now load-bearing** — interposed a per-path-batch liveness check (`assertLivePathBatches`) on the `globPaths` source feeding both stream methods, and made `streamGrep` always enumerate through `globPaths` (default `**`) so the check covers the glob-omitted case. A `revoke()` during the eager walk or a sparse grep is now observed within one path batch (was: 199 further `readFileText` calls, stream ended clean). Added a `streamGlob` mid-stream revoke test (previously zero coverage) and a sparse-`streamGrep` revoke test.
2. **Long-line parity** — gave the `text` (and `streamGlob` path) `readPattern` an explicit `STREAM_STRING_LENGTH_LIMIT = 10,000,000` instead of `M.string()`'s default 100,000, which the reader pump enforced per element and would throw on, aborting the whole stream. Added an `ok / big / ok` long-line fixture test pinning both sides of the boundary and eager-grep parity.
3. **Repeated-`stream()` bound** — corrected the claimed bound (the panel's allowed alternative to latching): documented across `mount.js`, `interfaces.js`, `types.d.ts`, and the design that the clamp bounds the pre-ack window *per `stream()` call*, not the whole daemon high-water mark (the engine sorts the full path set internally) nor per-reader (k concurrent streams scale k×buffer).
4. **Retracted-claim survivors + false resource claims** — fixed the design's "stops the walk" and "before each directory read"; restated "no intermediate file list is materialized" (false) as "no full path array round-trips as grep's argument and the 10,000-path cap is dropped" across all five surfaces; retitled/reworded the cancellation test to name content reads.
5. **Broken `iterateReader` specifier** — `@endo/exo-stream`'s index is `export {}`; fixed help.md (and regenerated `help-text-data.js`) and the changeset to `@endo/exo-stream/iterate-reader.js`.
6. **Changeset regression** — restored the agent-tools code-mode sentence, the `STREAM_BUFFER_MAX`/`clampStreamBuffer` exports, `streamGrep`'s `glob` option, corrected `MountControl`→`EndoMountControl`, re-wrapped sentence-per-line.
7. **Abbreviations** — `relPath`→`relativePath`; test dir prefixes spelled out (`-incremental-`/`-backpressure-`/`-revoke-buffer-`); plus the hostile U+21D2 glyph (should-fix) replaced.

Also fixed a CI-red `lint:prettier` failure (reformatted the new test additions).

**Verification:** 30/30 tests pass in `mount-stream-search.test.js`; `lint:types` (tsc) clean; `lint` 0 errors; prettier clean; CI 27/27 green.

**Follow-ups (panel-noted, out of scope this round):** per-grant `buffer` ceiling / single-stream latch to make the revocation bound per-reader; `should-fix` items (closed-rest option guards, `.test-d.ts` return-type pins, fast-check coverage, `glorp` cross-pointer) left for a future round; a maintainer summary comment on the earlier premature-halt escalation.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1085-gauntlet-20260901-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 278 tokens (20361386 cached reads)
- Output: 75125 tokens
- Cost: $17.820065
- Wall-clock: 2667s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
