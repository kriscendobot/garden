Design job complete: the plan for exo-stream variants of the mount search methods is posted as draft PR #647, with a reply on the originating review thread.

## Completion report

**Job:** `endojs-endo-but-for-bots-mount-stream-glob-grep-127` (designer) — plan exo-stream variants of the mount bulk search methods, per @kriskowal's inline review on PR #127 (comment 3548861664).

**What I did:**
- Surveyed the PR #127 branch (`feat/mount-extensions`): `glob()`/`grep()` in `packages/daemon/src/mount.js` (the `walkGlob` walker, `GLOB_MAX_RESULTS` 10k, grep `maxResults` 1k), the `MountInterface` guards, the read-only `ReadableTree` view exclusion, and the revocation (`assertLive`) mechanism.
- Confirmed `@endo/exo-stream` is the intended substrate (already used by the mount for `streamBase64`, blob writes, and tar check-in; journal library concept page `exo-stream` matched the code).
- Wrote `designs/mount-stream-glob-grep.md` on branch `design/mount-stream-glob-grep` off `origin/llm` and opened **draft PR [#647](https://github.com/endojs/endo-but-for-bots/pull/647)** against `llm` (designer-role default; commit `3483040`, bot identity).

**Design highlights:** `streamGlob`/`streamGrep` return `PassableReader` remotables synchronously (pipelining-friendly, `entry`/`readOnly` precedent), backed by a lazy async-generator refactor of `walkGlob` shared with the eager variants (no behavioral drift in confinement/deny/ordering; incidentally fixes grep's full-file-list materialization). Backpressure and cancellation delegate to the Exo Stream Protocol (`buffer: 0` default, clamped buffer option, early close stops the remote walk); generators re-check `assertLive()` per step so revocation cuts in-flight streams. Streaming search stays off the structural `ReadableTree` view. `streamList` rejected (redundant with `streamGlob`), `snapshot()` out of scope (already streams bytes), `followNameChanges` named to adopt the same reader shape later. Test plan extends the `mount.test.js` fixture shared with the mount-extensions reconstruction (parity, incrementality, backpressure, cancellation, mid-stream revocation, denial parity, pattern guards).

**Outward-facing artifacts:** draft PR #647; reply on the originating thread ([discussion_r3554009225](https://github.com/endojs/endo-but-for-bots/pull/127#discussion_r3554009225)) linking the plan. Both under standing endo-but-for-bots authorization.

**Follow-ups:** implementation is a separate builder job stacking on #127 (or landing after the mount stack merges); roadmap binning of the new design in `designs/README.md` is left to the journalist pass. Open questions for the maintainer are in the design (streaming search on tree views later; buffer clamp constant).

Not verified by execution (design-only job, no code changed); the design file renders on the PR diff and both links above were confirmed by their API responses.

Self-improvement: nothing this time.
