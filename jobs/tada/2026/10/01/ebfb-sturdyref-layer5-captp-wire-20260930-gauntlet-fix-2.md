I applied all four must-fix items from the round-2 panel review (5374480276) to endojs/endo-but-for-bots PR #1394, pushed them, and CI is green: all 33 checks passed with no failures (`ci-wait-merge` rc 0).

**What changed** (pushed to `build/sturdyref-captp-wire` with `safe-push-pr-head.sh`, head now `7516782577`):
1. **Changeset bump** (`64ce96fd6c`): `.changeset/sturdyref-captp-wire.md` now bumps `@endo/ocapn` as `major` instead of `minor`. The package is past 1.0, and its exported `SturdyRef` type and `passStyleOf` result change in ways existing callers will notice. `@endo/captp` stays `minor` because its change only adds the new `s+N` slot kind.
2. **JSDoc import** (`7516782577`): `packages/ocapn/src/client/sturdyrefs.js` now brings in the type with `@import { SturdyRef as PassStyleSturdyRef } from '@endo/pass-style'` at the top of the file. The inline `import()` reference is gone. Locally, ocapn's type check (`tsc`) passed, eslint showed 0 errors, and the `api-surface` and `sturdyref` tests passed (16).
3. **PR body**: I removed the inline test counts and the sentence about the hand-edited snapshot, replacing the counts with one line saying the suites pass. I also updated the Upgrade section, which still said both packages get minor bumps, to name the major bump.
4. **Summary comment**: posted https://github.com/endojs/endo-but-for-bots/pull/1394#issuecomment-5924120367. It covers all three fix rounds (head SHAs, review IDs, and what each commit fixed), since the first two rounds never posted one.

**Follow-ups not done** (the panel marked these should-fix or comment-only):
- None of `captp`, `ocapn` or `sturdyref` runs its tests on XS (`test:xs` is a stub), so the realm-global `@endo/sturdyref` shim has no XS coverage.
- CapTP builds a new `SturdyRefEnlivener` object on every call instead of caching one per export.
- `opts` should be renamed to `options` in `packages/captp/test/sturdyref.test.js`.
- One reviewer suggested checking whether `@endo/captp` also needs a major bump; I judged `minor` correct.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1358404 cached reads)
- Output: 6475 tokens
- Cost: $0.9393648000000001
- Wall-clock: 3136s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
