**Completion report: undraft stage for endojs/endo-but-for-bots#1584, "test(ses): smoke-test the host text codecs on XS"**

PR #1584 is now ready for review. The head is still exactly `6ff4138d1a12086e2b70c3256e377b3d16c1f24d`, the head the passing panel reviewed.

**Steps:**
1. **Pre-mutation gate:** I fetched fresh metadata just before changing anything. The PR was OPEN, its head matched the reviewed commit, and it was still a draft.
2. **Un-draft:** I ran `gh pr ready` and it succeeded.
3. **Post-check:** I fetched the metadata again. `isDraft` is false and the head is unchanged.

**Advisory appellate pass** (a light `claude -p` review of the 203-line diff; it does not block anything). Points a maintainer may want to check:
- **`assert` before `lockdown()`:** Both XS fixtures call `assert.equal` before `lockdown()`. If the `assert` global isn't there yet under xst, this throws. Worth confirming `yarn test:xs` was actually run on real XS.
- **New bundle skips the usual wrapper:** The missing-codecs bundle is written raw from `makeBundle`, without the `xsPrelude` wrapper that `test-xs.js` uses. It should be checked that xst can run it as-is.
- **Weak negative test:** The missing-codecs test only shows that lockdown doesn't crash. Its `typeof TextEncoder === 'undefined'` check passes regardless of how SES handles missing codecs.
- **Unrelated workflow edits:** The PR also pins the `depcheck.yml` runner to `ubuntu-24.04` and changes a version comment in `ci.yml` to `# v3.0.3`. It's worth confirming the pinned SHA really is the v3.0.3 tag.
- **CI wiring:** The diff doesn't show whether CI runs `test:xs` for these paths. The new xst run is chained with `&&`, so it is skipped whenever the earlier xst run fails.

**Follow-ups:** none required.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1584-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176430 cached reads)
- Output: 1511 tokens
- Cost: $0.41625
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
