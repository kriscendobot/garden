I'm stopping here. The only check left, the macOS 22.x re-run, has been queued for a runner for 40 minutes, and this job is close to its time limit.

## Fix round 1 — endojs/endo-but-for-bots#1394

**Where the review items came from:** The panel-1 review (5373303744) and its record `panel-runs/endojs-endo-but-for-bots-1394/e7fbb476174c.md` only list the first 20 must-fix items, each cut off mid-sentence. The panel's per-seat notes were deleted after the run on the recording host. That left me readable items from archivist, locksmith and migrator only. Pruner, purist, typist, warden and wire-watcher also voted must-fix, but none of their items appear anywhere I could reach, so I could not address them. Panel-2 will show whether any of them still stand.

**Pushed** to `build/sturdyref-captp-wire` (9a9aa310f9 → 1ff926bc52) as three follow-up commits, via `safe-push-pr-head.sh`:
1. `fix(captp)`: **locksmith must-fix** — the object answering a peer's call on an exported SturdyRef is no longer a bare record (`captp.js` CTP_CALL `s` branch).
   - `enliven()` with no arguments is answered by `Far('SturdyRefEnlivener', …)`.
   - Any other method, any extra arguments, or a property get is now rejected with an error back to the peer. That includes methods inherited from the prototype, like `toString` and `hasOwnProperty`.
   - I checked at the call site rather than relying on `Far` alone, because a `Far` object still answers `toString` and other prototype methods. This keeps captp from needing new `@endo/exo`/`@endo/patterns` dependencies.
   - New test: "a CapTP SturdyRef enliven facet refuses other methods and arguments".
2. `fix(ocapn)`: **archivist must-fix** — `enlivenUnbound` now takes the `details` parameter its `EnlivenSturdyRefDetails` type declares.
3. `docs(changeset)`: **migrator must-fix** — added a compatibility note for `@endo/ocapn` callers:
   - the exported `SturdyRef` type changed from `CopyTagged<'ocapn-sturdyref'>` to the realm `SturdyRef`;
   - `passStyleOf` now reports `'sturdyRef'`, not `'tagged'`;
   - a ref from the top-level `makeSturdyRef` cannot be enlivened.
   
   Also added an authority note for locksmith's comment-only point: the ability to enliven now travels with the ref, not with whoever holds the client.

**Local checks:** captp and ocapn tests pass (44 and 563). `yarn lint` passes for both, with warnings only. The repo-root `tsc` shows no errors in captp or ocapn files, but it does exit 1 — I didn't look at what else it reports.

**CI:** 32 of 33 checks are green. The first run on the new head had two failures, both in code this PR doesn't touch:
- `cover (22.x)`: an `@endo/patterns` property test (`copySet › setIsSuperset`) failed after 68 random cases.
- `test (22.x, macos-15)`: `daemon-teardown › an orphaned daemon shuts itself down`.

`ci-wait-merge` returned rc 3 (red) at its deadline. I re-ran the failed jobs: `cover (22.x)` now passes. The macOS 22.x re-run has been waiting for a runner since 01:14Z and was still queued at 01:54Z, so the result is still pending (the re-run turned the red into pending; nothing failed again).

**Follow-up:** Panel-2 should run the full seat set again on head `1ff926bc52`. Separately, @endo/ocapn is at 1.x and this changeset bumps it as minor, but it changes behaviour existing callers depend on. Whether that should be a major bump is for the maintainer to decide.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4422525 cached reads)
- Output: 19451 tokens
- Cost: $2.083261
- Wall-clock: 6244s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
