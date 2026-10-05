**Gauntlet UNDRAFT stage: endojs/endo-but-for-bots#1349 is now ready for review**

PR #1349 ("test(ses): XS smoke check for hardened TextEncoder/TextDecoder", head `4d3354123e`, base `master-6ee3fda`, 6 files, +129/−3) was still an open draft, so this stage was not a no-op.

**What I did**
1. Ran the advisory appellate review: one short `claude -p` (sonnet) pass over the PR diff. It is advisory only and did not gate the un-draft. Its findings are recorded below and were not posted to the PR.
2. Ran `gh pr ready`. The PR now shows `isDraft: false` and `state: OPEN`.

**Appellate findings (advisory, not verified against the repo)**
- **CI wiring:** nothing in the diff shows `test:xs` running in CI. If no workflow invokes it, the new `_xs-missing-text-codecs.js` smoke test never runs automatically. This is the finding most worth checking.
- **Action pin label:** the `paths-filter` change only edits the comment (`v3` → `v3.0.3`) and leaves the SHA as it was. Someone should confirm that SHA really is upstream tag `v3.0.3`.
- **Coverage gaps:**
  - No test covers a host that has only one of `TextEncoder` or `TextDecoder`.
  - If `lockdown()` throws, the test crashes generically; nothing catches it and fails with a named assertion.
- **Minor:**
  - The new file uses `assert` without declaring it in its `/* global */` comment. The existing `_xs.js` does the same.
  - If the first `xst` run fails, the `&&` chain stops and stale `tmp/` artifacts are left behind.

**Follow-ups:** if the maintainer wants it, a fixer could check the CI wiring and the action pin. Otherwise there's nothing else to do.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20260930-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (157347 cached reads)
- Output: 1291 tokens
- Cost: $0.3623933999999999
- Wall-clock: 67s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
