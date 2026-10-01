The round 3 panel on PR #1396 (head `c951573936`) came back **must-fix**. `panel.sh` exited 0, so this is a real verdict, not a panel error.

**What I ran:** the panel in single-round mode against an isolated checkout of `endojs/endo-but-for-bots@build/sturdyref-captp-construct`. I passed the merge-base SHA `2d2a656b84` as the base rather than the branch name, because `panel.sh` can pick up a stale base when given a bare branch name.

**Result:** all 33 seats ran — 3 request-changes (typist, purist, integrator), 8 comment-only, 22 approve. The 6 must-fix items from round 2 are all resolved.

**Posted:** review 5375470129 on https://github.com/endojs/endo-but-for-bots/pull/1396 (46 KB). It went up as COMMENTED, not request-changes, because GitHub won't let the bot request changes on its own PR. Rounds 1 and 2 were posted the same way. The raw aggregate was 83 KB, over GitHub's 65,536-character limit for a review body. So the review holds a written summary, the full text of the 11 non-approving seats plus warden and locksmith (approvals with notes), and a list of the other 20 approving seats.

**Must-fix for the fixer:**
1. The PR body still says `designator`, and its OCapN mapping sentence is now wrong; change it to `network` throughout.
2. The PR body has an invented `## Stack index` heading that isn't in the template.
3. `packages/captp/src/captp.js:1182` and `:1214` use inline `import('@endo/pass-style').SturdyRef`; use the file's top-level `@import` instead.
4. The claim that no error ever reveals `objectId` is tested with only one literal value. It needs a property test, which means adding `fast-check` as a devDependency of `@endo/captp` and `@endo/ocapn`.

**Should-fix:**
- Check that `data` is a non-null object before destructuring it.
- Copy a `Uint8Array` `objectId` instead of storing the caller's buffer.
- Use `Reflect.ownKeys` for the top-level extra-property check, as the `hints` check already does.
- Give the `l-0` locator a real type instead of an `any` cast.
- Squash fixup commits `4330ae6f00` and `14e9810335` into the commits they repair.
- Document that `peerId` is not a security boundary.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1330927 cached reads)
- Output: 8875 tokens
- Cost: $1.0811814000000004
- Wall-clock: 701s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
