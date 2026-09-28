# Fix round 2 for endojs/endo-but-for-bots PR #1097: done, CI green

I applied all three must-fix items from the panel's round-2 review and pushed them in one follow-up commit, `6eb5969f22`, on `fix/readableblob-byte-array-cleanup`. The push went through `safe-push-pr-head.sh` in advance mode, moving the head from `517fb54105` to `6eb5969f22`. CI is green (33 checks, 0 failed), but only after I re-ran two failed macOS jobs once.

## Changes

1. **The reorder now produces the snapshot's order (assessor, saboteur, breaker).** The splice in `packages/platform/test/cached-fs.test.js` has moved into a module-level helper, `canonicalizeStreamEventsRace`.
   - It moves the caller-drain `streamBase64` return to right after the `events` call's own return, found by matching question IDs. The old code put it right after the `events` call, which is not where the snapshot has it.
   - It moves the return only when it came before the `events` return.
   - A new synthetic test runs the raced transcript shape through the helper and gets exactly the snapshot order. It also checks that an already-ordered transcript comes back unchanged.
2. **The helper checks its assumptions (prover, corner-prober).**
   - It requires exactly 1 `events` call and 2 `streamBase64` calls (the caller's drain, then the background populate), and says in a comment that it moves the first one.
   - A return only counts as the answer to a call if it matches the question ID and travels the opposite way from the call. This matters because each side of a CapTP connection numbers its own questions.
   - It throws on a missing return instead of skipping quietly, which also covers the saboteur's should-fix.
   - The synthetic test covers a return going the wrong way, an extra `streamBase64` call, and an extra `events` call, and each is rejected.
3. **PR title and body rewritten (integrator).**
   - The title is now `test(platform): stabilize cached-fs miss transcript ordering; align ReadableBlob changeset`.
   - The body now says the range-attenuation refactor is already on the base (`0668baf85f`) and that the changeset amends the pending one from #754. The `garden-job` marker is kept.

## Checks

- `npx ava test/cached-fs.test.js` passes locally: 8/8, including the new test.
- ESLint reports no errors. Its one warning, an unused `eslint-disable` directive, was already there.

## CI

The first run failed on 2 cells: `test (22.x, macos-15)` and `test (24.x, macos-15)`.
- Both failures were in `packages/daemon`: `daemon-teardown › an orphaned daemon shuts itself down…` on 24.x, and `endo.test.js` exiting non-zero on 22.x.
- My commit only touches a platform test file, and the previous head `517fb54105` was green, so I treated these as macOS timing flakes and re-ran the failed jobs once.
- The re-run passed, and `ci-wait-merge.sh` returned rc 0 (GREEN).

## Not done

I did not act on these should-fix items:
- The integrator's request to squash `481de8826a` and `517fb54105` into one `test(platform)` commit. That would rewrite history, and this stage only adds follow-up commits.
- The integrator's suggestion to replace the snapshot with assertions that don't depend on event order.

Panel round 3 can decide on both.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1097-gauntlet-20260928-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1567193 cached reads)
- Output: 10351 tokens
- Cost: $1.0886266000000002
- Wall-clock: 3643s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
