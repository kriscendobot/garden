Fix round 4 for PR #1392: all five request-changes seats are addressed and pushed (`6571479f91..bc562c2841`), but CI was still pending when the 3600s deadline ran out. `ci-wait-merge` returned rc=4, with the two macOS test legs still running and everything else passed or skipped.

**What changed** (three follow-up commits, pushed with `safe-push-pr-head.sh`):
- **saboteur:** `getRankCover` on a SturdyRef now fails with `"sturdyRef" cannot be rank-ordered` instead of a raw `TypeError`. I added a guard to the private `getPassStyleCover` in `patternMatchers.js`, plus a test.
- **breaker:** `dot-membrane.js` now has a `sturdyRef` case that throws a clear error, like the other switches in the package. I added a membrane test.
- **corner-prober:**
  - I kept `compareRank(ref, ref) === 0` as a documented exception rather than making it throw. Identical operands return 0 before the pass style is checked, and a container holding a ref would also return 0 against itself, so a top-level-only throw wouldn't be consistent. It now has a code comment, a test and a changeset line.
  - I added the missing test: once a trusted global is captured, a later well-shaped one does not replace it.
- **purist:** the `Passable` type now accepts `SturdyRefObject`, deliberately not as a `PassableCap`. The doc comment is updated and the type test checks a bare ref and one inside a container.
- **typist** (should-fix, also done): `types.test-d.ts` now checks that `SturdyRefObject` matches the `SturdyRef` type from `@endo/sturdyref`.
- **pruner:** I cut the PR body to 293 words. The stack list and the "Mined from #737" section are gone, and the testing note is one sentence.
- Changesets for marshal, patterns and pass-style are updated, and I posted a summary comment on the PR answering each finding: https://github.com/endojs/endo-but-for-bots/pull/1392#issuecomment-5924273704

**Local checks:** the full pass-style, marshal and patterns test suites and lint pass (0 errors), as does the root `tsc`. The root `tsc` ran out of memory on the first try and needed a 12 GB heap.

**Left for later:** fast-checker's comment-only suggestion to add a sturdyRef leaf to the shared `arb-passable.js` generator and write property tests was not done.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3894701 cached reads)
- Output: 19361 tokens
- Cost: $2.0262002
- Wall-clock: 3923s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
