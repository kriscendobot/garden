Job complete. All work is committed, pushed, the draft PR is open, and the maintainer's linking directive is satisfied.

## Completion report

**Job:** Build streaming mount search (`streamGlob` / `streamGrep`) per `designs/mount-stream-glob-grep.md` in `endojs/endo-but-for-bots`.

**What I did**
- Opened **draft PR endojs/endo-but-for-bots#1085** against `llm` (`feat/mount-stream-glob-grep`), two commits (one per remaining phase).
- Posted the requested linking comment on #647 with the correlation marker (`#647-issuecomment-5460578130`), satisfying the maintainer directive relayed to my inbox.

**Key finding — Phase 1 was already landed.** The design's Phase 1 (turn the glob walker into lazy async generators; make eager `glob`/`grep` bounded collectors over them) had already been done independently: the walk now lives in the shared `@endo/platform/fs/search` engine as batch async generators (`globPaths`/`grepFiles`), and the eager `mount.js` `glob`/`grep` are already collectors over them. So there was no second walker to add — I built the streaming variants directly on that shared engine, which is exactly the design's "one walker, no drift" intent.

**What changed**
- **Phase 2 — Stream surface** (`packages/daemon/src/`): `streamGlob`/`streamGrep` on `EndoMount` returning `PassableReader` synchronously via `@endo/exo-stream` `readerFromIterator`; `MountInterface` guards; `clampStreamBuffer`/`STREAM_BUFFER_MAX` (ceiling 1,024); help-text entries + eager cross-reference; `EndoMount` typedefs. `assertLive()` at invocation and re-checked per element; generators driven at `batchSize: 1` for true per-pull backpressure; `streamGrep`'s `glob` option pipes enumeration into grep with no intermediate materialization; streaming excluded from the `ReadableTree` view.
- **Phase 3 — Tests**: new `packages/daemon/test/mount-stream-search.test.js` (parity, incrementality, backpressure, cancellation, mid-stream revocation, confinement/denial parity, pattern guard, options + buffer clamp) + the conformance test's pinned extension set.

**Deviation noted (in PR body):** because glob's order is a global sort, its walk fully completes before the first element (bounded message size, not time-to-first-result), so the incrementality test is expressed over `readFileText` (file-content reads), where `streamGrep` is genuinely incremental — reflecting the platform engine's walk-then-sort architecture rather than the design's original `readDirectory` wording.

**Verified by real execution** (local, bin-shims + sandbox disabled):
- `ava test/mount-stream-search.test.js` → **19 passed**.
- `ava` mount/glob/grep/glorp/revocation suites → **123 passed** (no regression).
- `ava` conformance/help-text/snapshot suites → **30 passed**.
- `tsc` clean; `eslint` changed files → 0 errors; `prettier --check` clean; composite-tsconfig `--check` → no drift (no new deps).

**Follow-ups:** none required from me — the draft PR auto-runs the gauntlet (clean → panel → fix-loop → un-draft) under its supervising gardener. `ensure-pr.sh` needed `GARDEN_ENSURE_PR_LIST_LIMIT=600` (the repo now has >200 open bot PRs) to enumerate past the page limit; worth noting for future PR-opening jobs on this repo.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-mount-stream-glob-grep-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 214 tokens (16752811 cached reads)
- Output: 83454 tokens
- Cost: $12.539721499999995
- Wall-clock: 1373s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
