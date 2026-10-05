PR #1349 now tests the missing-codec path on XS, and CI is green. All 15 checks pass, and the `test-xs` log shows the new script ran.

**Required fix (absent codecs on XS)**, commit `b1e0fb448c`:
- **New script:** `packages/ses/test/_xs-missing-text-codecs.js` is a second `xst` script. It deletes `TextEncoder` and `TextDecoder`, runs `lockdown()`, and checks that new compartments see neither. It is separate because lockdown can only run once per realm. `generate-test-xs.js` bundles it and `yarn test:xs` runs it.
- **Deletion before import:** the codecs are deleted in a small module, `_xs-delete-text-codecs.js`, that loads before `ses`. Deleting them after `import 'ses'`, the way the Node test does, fails on XS: the compartment still sees `TextEncoder`. SES-for-XS records the global intrinsics when it is imported, while Node re-reads them at `lockdown()`. Deleting them up front also matches a real host that never had the codecs.
- **Fails closed:** without the up-front deletion, the script throws `RangeError: compartment lacks TextEncoder`.

**Should-fix items**, commit `4d3354123e`:
- **Round trip:** the hardened codecs now encode and decode `'hello'` and the empty string.
- **Second compartment:** another `Compartment` is checked to share the same codec objects.
- **Comment:** `_xs.js` points to the new script instead of noting the branch can't be reached.
- **PR description:** trimmed to what the tests check, with CI as the verification.
- **Summary comment:** posted on the PR: https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-5992086250

**Local checks:**
- `yarn test:xs` passes both scripts on xst 17.9.1, and eslint is clean.
- The type check reports one error, in `scripts/hermes-transforms.js`, a file this PR doesn't touch.
- The repo-wide `lint:fix` step of the pre-push gates ran out of memory on this host, so I linted the `ses` package on its own instead.

**Separate bug found:** on XS, a built-in global removed between `import 'ses'` and `lockdown()` still reaches new compartments, and it is not frozen. My probe printed `function false false` for its type and the two frozen checks. This predates the PR and is outside its test-only scope. I posted it as a builder job, `endojs-endo-but-for-bots-ses-xs-compartment-import-time-intrinsics`, with a reproducer and a suggested fix.

The PR is still a draft, and the next panel round runs against head `4d3354123e`.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `ea0889c799eb467e99b3bfb1ebdd3dff86487d08`; this job presented `4d3354123e209709df55da0c1374a30f7d7a5a86`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-fix-review-5412024379.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2281849 cached reads)
- Output: 16529 tokens
- Cost: $1.4835018000000004
- Wall-clock: 632s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
