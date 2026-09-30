I added the refusal test and made the `search-tools.test.js` stub strict, as the corner-prober juror asked, and pushed it to PR #1390 as follow-up commit `970f27de73` (fast-forward on `build/pet-name-path-only`). The `@endo/lal` tests (53), eslint and `yarn lint:types` all pass locally. I haven't waited for CI on the new head.

**What changed** (only `packages/lal/test/search-tools.test.js`):
- **Strict stub:** the stub's `lookup` now refuses anything that isn't an array, with a `TypeError` and the same "try again with an array of path components" hint as the daemon's `namePathFrom` and the updated `mock-powers.js`.
- **Existing cases:** all glob/grep tests that passed the bare string `'workspace'` now pass `['workspace']`, and their expected calls match.
- **New refusal test:** "dispatch forwards a bare-string petNamePath to the refusing lookup" covers `lookup`, `list` (its `name` argument), `readText`, `writeText`, `editText`, `glob`, and `grep` with and without a glob filter. Each case checks two things:
  - the string reaches `lookup` unchanged, so a dispatch that quietly wrapped it into an array would fail the test;
  - the call rejects with the retry-hint `TypeError`.

**Follow-ups:** none from this job. Other findings from the same review rounds (the lal tool descriptions still saying "(string or string[])", and the `@endo/lal` changeset wording) are separate items I didn't touch here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-ebfb-petname-path-only-sweep-gauntlet-fix-4-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (858342 cached reads)
- Output: 5532 tokens
- Cost: $0.7794684
- Wall-clock: 102s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
