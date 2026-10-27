Un-draft stage for PR #1349 is done, with nothing to change: the PR was already out of draft (https://github.com/endojs/endo-but-for-bots/pull/1349, "fix(ses): encapsulate TextEncoder and TextDecoder behind SES-owned constructors").

**Gate checks**
- **Before any change:** state was OPEN, the head was exactly `91cca8a5511d5c846eec173989fb025b5e4fa919` (the commit the panel passed) and isDraft was already false. So I did not run `gh pr ready`.
- **Re-checked after the advisory pass:** the head was still `91cca8a5…` and isDraft was still false.

**Advisory appellate pass (advisory only, does not block)**
A light `claude -p` review of the diff found these points the panel may have missed:
1. **Partial state on failure:** `tameTextCodecs` changes the global codecs and the host `prototype.constructor` partway through `repairIntrinsics`. If a later step throws, or lockdown is retried, the realm is left half-changed. No test covers this.
2. **Detection is narrow:** it checks only the own `arguments` descriptor, not `caller`.
3. **Docs overstate the versions:** they say "Chromium before version 138", but the changeset lists only some observed versions (120, 126, 127, 133, 136, 137).
4. **XS scope:** the XS change (compartments now use `%Shared*%` intrinsics, plus a new `repairIntrinsics` callback parameter) is what drives the `major` bump. It could be split into its own PR.
5. **Unrelated changes are bundled in:** CI runner pins, browser tests on every base branch, a Playwright `baseURL`, quote churn in the docs, and the guide duplicated in two places.
6. **Changeset reference:** `tender-lions-tickle.md` points to the other changeset by filename, which won't resolve in a generated changelog.
7. **Test gaps:** no test for the mixed case (affected encoder, clean decoder) under Node, for a second SES copy that has already encapsulated, or for objects that leak out through host-constructor errors or `encodeInto` results.

None of these reopens the gate. They are possible follow-ups for the maintainer's review. I changed no files and posted no jobs.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-91cca8a5-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176882 cached reads)
- Output: 1485 tokens
- Cost: $0.4160044
- Wall-clock: 67s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
